import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/habit.dart';
import '../providers/home_controller.dart';
import 'weekly_board.dart';

Future<void> showCreateEntrySheet(BuildContext context) {
  return showModalBottomSheet<void>(
    context: context,
    backgroundColor: const Color(0xFF1B1410),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (BuildContext sheetContext) {
      return SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: const Color(0xFF6B4E31),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'O que deseja criar?',
                style: TextStyle(
                  color: Color(0xFFF3E6C2),
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 16),
              ListTile(
                leading: const Icon(Icons.repeat, color: Color(0xFFC9A227)),
                title: const Text(
                  'Novo hábito',
                  style: TextStyle(color: Color(0xFFF3E6C2)),
                ),
                subtitle: const Text(
                  'Diário ou em dias específicos',
                  style: TextStyle(color: Color(0xFFB9A58A)),
                ),
                onTap: () {
                  Navigator.pop(sheetContext);
                  showDialog<void>(
                    context: context,
                    builder: (BuildContext dialogContext) {
                      return const _CreateHabitDialog();
                    },
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.flag, color: Color(0xFFC9A227)),
                title: const Text(
                  'Nova meta',
                  style: TextStyle(color: Color(0xFFF3E6C2)),
                ),
                subtitle: const Text(
                  'Objetivo de longo prazo',
                  style: TextStyle(color: Color(0xFFB9A58A)),
                ),
                onTap: () {
                  Navigator.pop(sheetContext);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'A criação de metas entra na próxima etapa.',
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      );
    },
  );
}

class _CreateHabitDialog extends StatefulWidget {
  const _CreateHabitDialog();

  @override
  State<_CreateHabitDialog> createState() => _CreateHabitDialogState();
}

class _CreateHabitDialogState extends State<_CreateHabitDialog> {
  final TextEditingController _titleController = TextEditingController();
  HabitDifficulty _difficulty = HabitDifficulty.medium;
  HabitFrequency _frequency = HabitFrequency.daily;
  final Set<int> _weekdays = <int>{};

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: const Color(0xFF1B1410),
      title: const Text(
        'Novo hábito',
        style: TextStyle(color: Color(0xFFF3E6C2)),
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TextField(
              controller: _titleController,
              style: const TextStyle(color: Color(0xFFF3E6C2)),
              decoration: const InputDecoration(
                labelText: 'Título',
                labelStyle: TextStyle(color: Color(0xFFB9A58A)),
              ),
            ),
            const SizedBox(height: 12),
            const Text('Dificuldade', style: TextStyle(color: Color(0xFFB9A58A))),
            Wrap(
              spacing: 8,
              children: HabitDifficulty.values.map((HabitDifficulty value) {
                return ChoiceChip(
                  label: Text(_difficultyLabel(value)),
                  selected: _difficulty == value,
                  onSelected: (_) => setState(() => _difficulty = value),
                );
              }).toList(),
            ),
            const SizedBox(height: 8),
            const Text('Frequência', style: TextStyle(color: Color(0xFFB9A58A))),
            Wrap(
              spacing: 8,
              children: HabitFrequency.values.map((HabitFrequency value) {
                return ChoiceChip(
                  label: Text(_frequencyLabel(value)),
                  selected: _frequency == value,
                  onSelected: (_) => setState(() => _frequency = value),
                );
              }).toList(),
            ),
            if (_frequency != HabitFrequency.daily) ...<Widget>[
              const SizedBox(height: 8),
              const Text(
                'Dias específicos',
                style: TextStyle(color: Color(0xFFB9A58A)),
              ),
              Wrap(
                spacing: 6,
                children: List<Widget>.generate(7, (int index) {
                  final int weekday = index + 1;
                  final bool selected = _weekdays.contains(weekday);
                  return FilterChip(
                    label: Text(kWeekdayLabels[index]),
                    selected: selected,
                    onSelected: (bool on) {
                      setState(() {
                        if (on) {
                          _weekdays.add(weekday);
                        } else {
                          _weekdays.remove(weekday);
                        }
                      });
                    },
                  );
                }),
              ),
            ],
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancelar'),
        ),
        TextButton(
          onPressed: () async {
            final String title = _titleController.text.trim();
            if (title.isEmpty) {
              return;
            }
            if (_frequency != HabitFrequency.daily && _weekdays.isEmpty) {
              return;
            }
            final Habit habit = Habit.create(
              title: title,
              difficulty: _difficulty,
              frequency: _frequency,
              weekdays: _frequency == HabitFrequency.daily
                  ? const <int>[]
                  : (_weekdays.toList()..sort()),
            );
            await context.read<HomeController>().addHabit(habit);
            if (context.mounted) {
              Navigator.pop(context);
            }
          },
          child: const Text('Salvar'),
        ),
      ],
    );
  }

  String _difficultyLabel(HabitDifficulty value) {
    switch (value) {
      case HabitDifficulty.easy:
        return 'Fácil';
      case HabitDifficulty.medium:
        return 'Médio';
      case HabitDifficulty.hard:
        return 'Difícil';
    }
  }

  String _frequencyLabel(HabitFrequency value) {
    switch (value) {
      case HabitFrequency.daily:
        return 'Diário';
      case HabitFrequency.weekly:
        return 'Semanal';
      case HabitFrequency.custom:
        return 'Específico';
    }
  }
}
