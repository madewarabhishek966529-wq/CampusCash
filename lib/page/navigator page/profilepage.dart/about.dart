import 'package:flutter/material.dart';

class About extends StatelessWidget {
  const About({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0D1A),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Container(
              decoration: const BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Color(0xFF8B5CF6),
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  ),
                ],
                gradient: LinearGradient(
                  colors: [
                    Color(0xFF4C1D95), // deep purple
                    Color(0xFF7C3AED), // violet
                    Color(0xFF6D28D9),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(36),
                ),
              ),
              padding: const EdgeInsets.fromLTRB(20, 56, 20, 32),
              child: Column(
                children: [
                  // Back button row
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.arrow_back_ios_new_rounded,
                            color: Colors.white,
                            size: 18,
                          ),
                        ),
                      ),
                    ],
                  ),
                  // App Icon
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(22),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.3),
                        width: 2,
                      ),
                    ),
                    child: const Icon(
                      Icons.account_balance_wallet_rounded,
                      color: Colors.white,
                      size: 44,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    "Student Expense Tracker",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.3,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    "Version 1.0.0",
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.65),
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Badge chips
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _Chip(icon: Icons.shield_rounded, label: "Secure"),
                      SizedBox(width: 10),
                      _Chip(icon: Icons.bolt_rounded, label: "Fast"),
                      SizedBox(width: 10),
                      _Chip(icon: Icons.wifi_off_rounded, label: "Offline"),
                    ],
                  ),
                ],
              ),
            ),
          ),
          // ── CONTENT ──
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 24, 16, 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // About card
                  _Card(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        _CardHeader(icon: Icons.info_rounded, title: "About This App"),
                        SizedBox(height: 12),
                        Text(
                          "A student expense tracker is a powerful tool designed to help students take control of their personal finances. By recording, categorizing, and analyzing daily expenses, students gain clear visibility into where their money goes.\n\nAt a stage of life where income is often limited — pocket money, scholarships, or part-time jobs — small expenses like food, transport, subscriptions, and entertainment can quietly drain a budget. This app solves that problem.",
                          style: TextStyle(
                            fontSize: 14,
                            color: Color.fromARGB(255, 255, 255, 255),
                            height: 1.65,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Features card
                  _Card(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        _CardHeader(icon: Icons.star_rounded, title: "Key Features"),
                        SizedBox(height: 14),
                        _Feature(
                          icon: Icons.receipt_long_rounded,
                          title: "Expense Logging",
                          subtitle: "Quickly add and categorize every expense",
                        ),
                        _Feature(
                          icon: Icons.pie_chart_rounded,
                          title: "Visual Analytics",
                          subtitle: "Charts and reports to spot spending patterns",
                        ),
                        _Feature(
                          icon: Icons.savings_rounded,
                          title: "Budget Goals",
                          subtitle: "Set limits and get alerted when you overspend",
                        ),
                        _Feature(
                          icon: Icons.history_rounded,
                          title: "Full History",
                          subtitle: "Complete record of all past transactions",
                        ),
                        _Feature(
                          icon: Icons.offline_bolt_rounded,
                          title: "Works Offline",
                          subtitle: "All data stored locally — no internet needed",
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Developer card
                  _Card(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const _CardHeader(icon: Icons.person_rounded, title: "Developer"),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Container(
                              width: 52,
                              height: 52,
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [
                                    Color(0xFF4C1D95), // deep purple
                                    Color(0xFF7C3AED), // violet
                                    Color(0xFF6D28D9),
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: const Icon(
                                Icons.person_rounded,
                                color: Colors.white,
                                size: 28,
                              ),
                            ),
                            const SizedBox(width: 14),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Omkar Madewar",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Color.fromARGB(255, 247, 247, 247),
                                  ),
                                ),
                                const SizedBox(height: 3),
                                Text(
                                  "madewaromkar@gmail.com",
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey[500],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Tech stack card
                  _Card(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        _CardHeader(icon: Icons.code_rounded, title: "Built With"),
                        SizedBox(height: 14),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            _TechBadge(label: "Flutter"),
                            _TechBadge(label: "Dart"),
                            _TechBadge(label: "SQLite"),
                            _TechBadge(label: "fl_chart"),
                            _TechBadge(label: "Lottie"),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 28),
                  // Footer
                  Center(
                    child: Text(
                      "Made with ❤️ for students",
                      style: TextStyle(color: Colors.grey[400], fontSize: 13),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Widget helpers ─────────────────────────────────────────
class _Chip extends StatelessWidget {
  final IconData icon;
  final String label;
  const _Chip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E35),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: Colors.white.withValues(alpha: 0.25)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.white, size: 14),
          const SizedBox(width: 5),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class _Card extends StatelessWidget {
  final Widget child;
  const _Card({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E35),
        borderRadius: BorderRadius.circular(18),
      ),
      child: child,
    );
  }
}

class _CardHeader extends StatelessWidget {
  final IconData icon;
  final String title;
  const _CardHeader({required this.icon, required this.title});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 34,
          height: 34,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [
                Color(0xFF4C1D95), // deep purple
                Color(0xFF7C3AED), // violet
                Color(0xFF6D28D9),
              ],
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: Colors.white, size: 18),
        ),
        const SizedBox(width: 10),
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Color.fromARGB(255, 248, 248, 248),
          ),
        ),
      ],
    );
  }
}

class _Feature extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  const _Feature({required this.icon, required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 221, 223, 226),
              borderRadius: BorderRadius.circular(9),
            ),
            child: Icon(
              icon,
              color: const Color.fromARGB(255, 1, 37, 79),
              size: 18,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    color: Color.fromARGB(255, 255, 255, 255),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TechBadge extends StatelessWidget {
  final String label;
  const _TechBadge({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFEFF6FF), Color(0xFFE0F2FE)],
        ),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: const Color(0xFFBADBF9)),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: Color.fromARGB(255, 1, 37, 79),
        ),
      ),
    );
  }
}
