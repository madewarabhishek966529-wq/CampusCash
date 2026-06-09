import 'package:flutter/material.dart';

ValueNotifier<int> selectedPageNotifier = ValueNotifier(0);

// ─── Design tokens (match dashboard) ──────────────────────────────────────────
const _navSurface = Color(0xFF16162A);
const _navPurple = Color(0xFF8B5CF6);
const _navGrey = Color(0xFF6B7280);

class Navbar extends StatefulWidget {
  const Navbar({super.key});

  @override
  State<Navbar> createState() => _NavbarState();
}

class _NavbarState extends State<Navbar> {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<int>(
      valueListenable: selectedPageNotifier,
      builder: (context, selectedIndex, _) {
        return Container(
          decoration: BoxDecoration(
            color: _navSurface,
            border: const Border(
              top: BorderSide(color: Color(0xFF2A2A45), width: 1),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.4),
                blurRadius: 20,
                offset: const Offset(0, -4),
              ),
            ],
          ),
          child: SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _NavItem(
                    icon: Icons.home_rounded,
                    label: 'Home',
                    index: 0,
                    selectedIndex: selectedIndex,
                  ),
                  _NavItem(
                    icon: Icons.pie_chart_rounded,
                    label: 'Stats',
                    index: 1,
                    selectedIndex: selectedIndex,
                  ),

                  SizedBox(width: 50),
                  _NavItem(
                    icon: Icons.receipt_long_rounded,
                    label: 'Records',
                    index: 3,
                    selectedIndex: selectedIndex,
                  ),
                  _NavItem(
                    icon: Icons.person_rounded,
                    label: 'Profile',
                    index: 4,
                    selectedIndex: selectedIndex,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final int index;
  final int selectedIndex;

  const _NavItem({
    required this.icon,
    required this.label,
    required this.index,
    required this.selectedIndex,
  });

  @override
  Widget build(BuildContext context) {
    final isSelected = index == selectedIndex;
    return GestureDetector(
      onTap: () => selectedPageNotifier.value = index,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? _navPurple.withValues(alpha: 0.15)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 24, color: isSelected ? _navPurple : _navGrey),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.normal,
                color: isSelected ? _navPurple : _navGrey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
