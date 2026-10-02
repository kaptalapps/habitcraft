import 'package:flutter/material.dart';

import '../models/habit.dart';

class HabitTile extends StatelessWidget {
  const HabitTile({
    super.key,
    required this.habit,
    required this.canToggle,
    required this.onToggle,
  });

  final Habit habit;
  final bool canToggle;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Material(
        color: const Color(0xFF2A1C14),
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          onTap: canToggle ? onToggle : null,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: Row(
              children: <Widget>[
                Icon(
                  habit.isCompletedToday
                      ? Icons.check_circle
                      : Icons.circle_outlined,
                  color: habit.isCompletedToday
                      ? const Color(0xFFC9A227)
                      : const Color(0xFF8A7460),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        habit.title,
                        style: TextStyle(
                          color: const Color(0xFFF3E6C2),
                          fontWeight: FontWeight.w600,
                          decoration: habit.isCompletedToday
                              ? TextDecoration.lineThrough
                              : TextDecoration.none,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${_difficultyLabel(habit.difficulty)} · +${habit.xpReward} XP · +${habit.coinsReward} moedas',
                        style: const TextStyle(
                          color: Color(0xFFB9A58A),
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),
                if (habit.streak > 0)
                  Text(
                    '${habit.streak}🔥',
                    style: const TextStyle(fontSize: 12),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _difficultyLabel(HabitDifficulty difficulty) {
    switch (difficulty) {
      case HabitDifficulty.easy:
        return 'Fácil';
      case HabitDifficulty.medium:
        return 'Médio';
      case HabitDifficulty.hard:
        return 'Difícil';
    }
  }
}
