import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../avatar/widgets/avatar_widget.dart';
import '../models/habit.dart';
import '../providers/home_controller.dart';
import '../widgets/habit_tile.dart';
import '../widgets/weekly_board.dart';

/// Home: avatar, sliding week board, and the selected day's habits.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final HomeController controller = context.watch<HomeController>();

    if (controller.isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: Color(0xFFC9A227)),
      );
    }

    return SafeArea(
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 8, 12, 0),
            child: AvatarWidget(
              profile: controller.profile,
              equippedItems: controller.equippedItems,
              avatarHeight: 150,
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
            child: WeeklyBoard(
              selectedDay: controller.selectedDay,
              onDaySelected: controller.selectDay,
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(12, 0, 12, 88),
              children: <Widget>[
                _HabitSection(
                  title: 'Hábitos diários',
                  habits: controller.dailyHabits,
                  canToggle: controller.isSelectedToday,
                  onToggle: controller.toggleHabit,
                  emptyLabel: 'Nenhum hábito diário ainda.',
                ),
                const SizedBox(height: 12),
                _HabitSection(
                  title: 'Hábitos específicos',
                  habits: controller.specificHabits,
                  canToggle: controller.isSelectedToday,
                  onToggle: controller.toggleHabit,
                  emptyLabel: 'Nada agendado para este dia.',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _HabitSection extends StatelessWidget {
  const _HabitSection({
    required this.title,
    required this.habits,
    required this.canToggle,
    required this.onToggle,
    required this.emptyLabel,
  });

  final String title;
  final List<Habit> habits;
  final bool canToggle;
  final ValueChanged<Habit> onToggle;
  final String emptyLabel;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          title,
          style: const TextStyle(
            color: Color(0xFFC9A227),
            fontWeight: FontWeight.w700,
            fontSize: 13,
            letterSpacing: 0.4,
          ),
        ),
        const SizedBox(height: 8),
        if (habits.isEmpty)
          Text(
            emptyLabel,
            style: const TextStyle(color: Color(0xFF8A7460), fontSize: 13),
          )
        else
          ...habits.map(
            (Habit habit) => HabitTile(
              habit: habit,
              canToggle: canToggle,
              onToggle: () => onToggle(habit),
            ),
          ),
      ],
    );
  }
}
