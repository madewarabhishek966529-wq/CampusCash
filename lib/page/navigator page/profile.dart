import 'package:campuscash/data/local/auth_service.dart';
import 'package:campuscash/page/login%20page/loginpage.dart';
import 'package:campuscash/page/navigator%20page/profilepage.dart/about.dart';
import 'package:flutter/material.dart';

class Profile extends StatefulWidget {
  final String userName;
  final String userEmail;
  const Profile({
    super.key,
    this.userName = "Omkar Madewar",
    this.userEmail = "madewaromkar@gmail.com",
  });
  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  static const _gradientColors = [Color(0xFF8B5CF6), Color(0xFF4C1D95)];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0D1A), // Deep dark background
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverToBoxAdapter(
            child: Container(
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: _gradientColors,
                ),
                borderRadius: const BorderRadius.vertical(
                  bottom: Radius.circular(36),
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF8B5CF6).withValues(alpha: 0.3),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              padding: const EdgeInsets.fromLTRB(20, 70, 20, 36),
              child: Column(
                children: [
                  Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withValues(alpha: 0.15),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.6),
                            width: 2.5,
                          ),
                        ),
                        child: const Icon(
                          Icons.person_rounded,
                          size: 60,
                          color: Colors.white,
                        ),
                      ),
                      Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: const Color(0xFF1E1E35),
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                        child: const Icon(
                          Icons.edit,
                          size: 16,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    widget.userName,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    widget.userEmail,
                    style: TextStyle(fontSize: 14, color: Colors.white70),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _sectionLabel("More"),
                  _tileGroup([
                    _tile(
                      icon: Icons.share_rounded,
                      title: "Invite Friends & Family",
                      isFirst: true,
                      onTap: () {},
                    ),
                    _tile(
                      icon: Icons.book_rounded,
                      title: "Blog",
                      onTap: () {},
                    ),
                    _tileGroup([
                      _tile(
                        icon: Icons.star_rounded,
                        title: "Rate Us",

                        onTap: () {},
                      ),
                    ]),
                    _tile(
                      icon: Icons.info_rounded,
                      title: "About",
                      isLast: true,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const About()),
                        );
                      },
                    ),
                  ]),
                  _sectionLabel("Account"),
                  _tileGroup([
                    _tile(
                      icon: Icons.logout_rounded,
                      title: "Logout",
                      isDestructive: true,
                      iconBg: Colors.redAccent.withValues(alpha: 0.2),
                      iconColor: Colors.redAccent,
                      isFirst: true,
                      isLast: true,
                      onTap: () async {
                        await AuthService.instance.logout();
                        if (!context.mounted) return;
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (_) => const Loginpage()),
                        );
                      },
                    ),
                  ]),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionLabel(String text) => Padding(
    padding: const EdgeInsets.only(left: 8, bottom: 12, top: 24),
    child: Text(
      text.toUpperCase(),
      style: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w700,
        letterSpacing: 1.5,
        color: Colors.grey[500],
      ),
    ),
  );

  Widget _tile({
    required IconData icon,
    required String title,
    String? subtitle,
    Color? iconBg,
    Color? iconColor,
    VoidCallback? onTap,
    bool isDestructive = false,
    bool isFirst = false,
    bool isLast = false,
  }) {
    final radius = BorderRadius.vertical(
      top: isFirst ? const Radius.circular(20) : Radius.zero,
      bottom: isLast ? const Radius.circular(20) : Radius.zero,
    );
    return ClipRRect(
      borderRadius: radius,
      child: Material(
        color: const Color(0xFF1E1E35), // Dark card background
        child: InkWell(
          onTap: onTap,
          highlightColor: Colors.white12,
          splashColor: Colors.white12,
          child: Container(
            decoration: BoxDecoration(
              border: Border(
                bottom: isLast
                    ? BorderSide.none
                    : const BorderSide(color: Colors.white12, width: 0.5),
              ),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: iconBg ?? Colors.white.withValues(alpha: 0.05),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: iconColor ?? Colors.white, size: 22),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: isDestructive
                              ? Colors.redAccent
                              : Colors.white,
                        ),
                      ),
                      if (subtitle != null) ...[
                        const SizedBox(height: 4),
                        Text(
                          subtitle,
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey[500],
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                Icon(
                  Icons.chevron_right_rounded,
                  color: Colors.grey[600],
                  size: 24,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _tileGroup(List<Widget> children) => Container(
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(20),
      border: Border.all(color: Colors.white12, width: 1),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.2),
          blurRadius: 10,
          offset: const Offset(0, 4),
        ),
      ],
    ),
    child: Column(children: children),
  );
}
