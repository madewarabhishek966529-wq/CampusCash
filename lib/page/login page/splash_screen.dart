import 'dart:async';
import 'package:campuscash/data/local/auth_service.dart';
import 'package:campuscash/page/login%20page/welcome.dart';
import 'package:campuscash/widgetpage.dart';
import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:lottie/lottie.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkSessionAndNavigate();
  }

  Future<void> _checkSessionAndNavigate() async {
    // Show splash for at least 2 seconds
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;

    // Check Firebase auth state via AuthService
    final session = await AuthService.instance.loadSession();

    if (!mounted) return;

    if (session != null) {
      // Already signed in — go directly to main screen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => WidgetPage(
            userName: session['name']?.toString() ?? 'User',
            userEmail: session['email']?.toString() ?? '',
          ),
        ),
      );
    } else {
      // Not signed in — go to welcome / login flow
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const WelcomePage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0D1A),
      body: Stack(
        children: [
          // Background Orbs
          _buildOrb(
            top: -100,
            left: -100,
            size: 300,
            color: const Color(0xFF8B5CF6),
          ),
          _buildOrb(
            bottom: -50,
            right: -50,
            size: 250,
            color: const Color(0xFF4C1D95),
          ),

          SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Hero(
                  tag: 'herolottie',
                  child: Center(
                    child: Lottie.asset(
                      'assets/lotties/money.json',
                      width: 200,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  'CampusCash',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.5,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Smart spending for students',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.5),
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 48),
                Center(
                  child: SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: const Color(0xFF8B5CF6).withValues(alpha: 0.7),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrb({
    double? top,
    double? bottom,
    double? left,
    double? right,
    required double size,
    required Color color,
  }) {
    return Positioned(
      top: top,
      bottom: bottom,
      left: left,
      right: right,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color.withValues(alpha: 0.15),
        ),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 80, sigmaY: 80),
          child: Container(color: Colors.transparent),
        ),
      ),
    );
  }
}
