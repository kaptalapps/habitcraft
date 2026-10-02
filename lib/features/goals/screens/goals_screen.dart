import 'package:flutter/material.dart';

/// Placeholder until the goals feature is implemented.
class GoalsScreen extends StatelessWidget {
  const GoalsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const SafeArea(
      child: Center(
        child: Text(
          'Metas em breve',
          style: TextStyle(color: Color(0xFFE8D5B5), fontSize: 16),
        ),
      ),
    );
  }
}
