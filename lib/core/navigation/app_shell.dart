import 'package:flutter/material.dart';

import '../../features/avatar/screens/avatar_screen.dart';
import '../../features/goals/screens/goals_screen.dart';
import '../../features/habits/screens/home_screen.dart';
import '../../features/habits/widgets/create_entry_sheet.dart';
import '../../features/inventory/screens/inventory_screen.dart';

/// Bottom navigation with a centered + action for habits and goals.
class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int _index = 0;

  static const List<Widget> _pages = <Widget>[
    HomeScreen(),
    GoalsScreen(),
    InventoryScreen(),
    AvatarScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF120E0C),
      body: IndexedStack(index: _index, children: _pages),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showCreateEntrySheet(context),
        backgroundColor: const Color(0xFFC9A227),
        foregroundColor: const Color(0xFF1B1410),
        child: const Icon(Icons.add, size: 32),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        color: const Color(0xFF1B1410),
        shape: const CircularNotchedRectangle(),
        notchMargin: 8,
        padding: EdgeInsets.zero,
        height: 64,
        child: Row(
          children: <Widget>[
            _NavButton(
              icon: Icons.home_filled,
              label: 'Início',
              selected: _index == 0,
              onTap: () => setState(() => _index = 0),
            ),
            _NavButton(
              icon: Icons.flag,
              label: 'Metas',
              selected: _index == 1,
              onTap: () => setState(() => _index = 1),
            ),
            const SizedBox(width: 64),
            _NavButton(
              icon: Icons.inventory_2,
              label: 'Itens',
              selected: _index == 2,
              onTap: () => setState(() => _index = 2),
            ),
            _NavButton(
              icon: Icons.person,
              label: 'Herói',
              selected: _index == 3,
              onTap: () => setState(() => _index = 3),
            ),
          ],
        ),
      ),
    );
  }
}

class _NavButton extends StatelessWidget {
  const _NavButton({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final Color color =
        selected ? const Color(0xFFC9A227) : const Color(0xFF8A7460);
    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Icon(icon, color: color, size: 22),
              const SizedBox(height: 2),
              Text(
                label,
                style: TextStyle(
                  color: color,
                  fontSize: 11,
                  fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
