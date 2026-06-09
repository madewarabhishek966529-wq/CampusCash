import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

/// Centralised Firebase Auth + Firestore service.
/// All UI pages interact with [AuthService.instance].
class AuthService {
  static final AuthService instance = AuthService._();
  AuthService._();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // ── Current user helpers ───────────────────────────────────────────────────

  /// Returns the currently signed-in Firebase user, or null.
  User? get currentUser => _auth.currentUser;

  // ── Login ──────────────────────────────────────────────────────────────────

  /// Signs in with [email] and [password].
  ///
  /// Returns:
  /// ```dart
  /// {'result': {'name': '...', 'email': '...'}}          // success
  /// {'error': 'not_found'}                                 // no account
  /// {'error': 'wrong_password'}                            // bad credentials
  /// {'error': 'connection_failed', 'message': '...'}      // network error
  /// {'error': 'unknown', 'message': '...'}                 // other
  /// ```
  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    try {
      final cred = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = cred.user!;

      // Try to get display name from Firestore — fall back gracefully if unavailable
      String name = user.displayName ?? user.email ?? 'User';
      try {
        final doc =
            await _firestore.collection('users').doc(user.uid).get().timeout(
          const Duration(seconds: 5),
        );
        if (doc.exists) {
          name = doc.data()?['name'] as String? ?? name;
        }
      } catch (_) {
        // Firestore unavailable — use Firebase Auth display name as fallback
      }

      return {
        'result': {'email': user.email ?? email, 'name': name},
      };
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'user-not-found':
        case 'invalid-email':
          return {'error': 'not_found'};
        case 'wrong-password':
        case 'invalid-credential':
          return {'error': 'wrong_password'};
        case 'network-request-failed':
          return {
            'error': 'connection_failed',
            'message': 'No internet connection. Please try again.',
          };
        case 'too-many-requests':
          return {
            'error': 'unknown',
            'message':
                'Too many failed attempts. Please wait a moment and try again.',
          };
        default:
          return {'error': 'unknown', 'message': e.message ?? 'Login failed.'};
      }
    } catch (e) {
      return {
        'error': 'connection_failed',
        'message': 'Cannot connect. Please check your internet connection.',
      };
    }
  }

  // ── Register ───────────────────────────────────────────────────────────────

  /// Creates a new Firebase Auth user and tries to store user profile in Firestore.
  /// Navigation to home happens even if Firestore write fails (user is already created).
  ///
  /// Returns:
  /// ```dart
  /// {'result': {'name': '...', 'email': '...'}}   // success
  /// {'error': 'email_exists'}                       // email taken
  /// {'error': 'unknown', 'message': '...'}          // other
  /// ```
  Future<Map<String, dynamic>> register({
    required String username,
    required String email,
    required String password,
  }) async {
    try {
      final cred = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = cred.user!;

      // Update display name on Auth user (always works)
      await user.updateDisplayName(username).catchError((_) {});

      // Try to store profile in Firestore — non-blocking, failure is OK
      _firestore.collection('users').doc(user.uid).set({
        'uid': user.uid,
        'name': username,
        'email': email,
        'createdAt': FieldValue.serverTimestamp(),
      }).catchError((_) {
        // Firestore write failed (e.g. not yet created in console).
        // The Auth account is already created — we proceed to home.
      });

      return {
        'result': {'email': email, 'name': username},
      };
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'email-already-in-use':
          return {'error': 'email_exists'};
        case 'network-request-failed':
          return {
            'error': 'unknown',
            'message': 'No internet connection. Please try again.',
          };
        case 'weak-password':
          return {
            'error': 'unknown',
            'message': 'Password is too weak. Use at least 6 characters.',
          };
        default:
          return {
            'error': 'unknown',
            'message': e.message ?? 'Registration failed.',
          };
      }
    } catch (e) {
      return {
        'error': 'unknown',
        'message': 'Registration failed. Please check your connection.',
      };
    }
  }

  // ── Session / logout ───────────────────────────────────────────────────────

  /// Returns user data map if a Firebase session exists, otherwise null.
  /// Firestore fetch is optional — falls back to Auth user data.
  Future<Map<String, dynamic>?> loadSession() async {
    final user = _auth.currentUser;
    if (user == null) return null;

    // Start with Auth data (always available offline)
    String name = user.displayName ?? user.email ?? 'User';

    // Try to enrich with Firestore name
    try {
      final doc = await _firestore
          .collection('users')
          .doc(user.uid)
          .get()
          .timeout(const Duration(seconds: 5));
      if (doc.exists) {
        name = doc.data()?['name'] as String? ?? name;
      }
    } catch (_) {
      // Firestore unavailable — use Auth display name
    }

    return {'email': user.email ?? '', 'name': name};
  }

  /// Signs out the current user.
  Future<void> logout() async {
    await _auth.signOut();
  }

  // ── Validators (static, used by form fields) ───────────────────────────────

  static String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) return 'Please enter your email';
    final emailRegex = RegExp(r'^[\w.-]+@[\w.-]+\.\w+$');
    if (!emailRegex.hasMatch(value.trim())) {
      return 'Please enter a valid email address';
    }
    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) return 'Please enter your password';
    if (value.length < 6) return 'Password must be at least 6 characters';
    return null;
  }
}
