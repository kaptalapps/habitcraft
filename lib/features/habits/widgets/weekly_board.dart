import 'package:flutter/material.dart';

import '../providers/home_controller.dart';

const List<String> kWeekdayLabels = <String>[
  'Seg',
  'Ter',
  'Qua',
  'Qui',
  'Sex',
  'Sáb',
  'Dom',
];

DateTime weekStartOf(DateTime date) {
  final DateTime day = DateTime(date.year, date.month, date.day);
  return day.subtract(Duration(days: date.weekday - 1));
}

/// Horizontal [PageView] of weeks; tap a day to filter habits.
class WeeklyBoard extends StatefulWidget {
  const WeeklyBoard({
    super.key,
    required this.selectedDay,
    required this.onDaySelected,
  });

  final DateTime selectedDay;
  final ValueChanged<DateTime> onDaySelected;

  static const int pageCount = 104;
  static const int initialPage = 52;

  @override
  State<WeeklyBoard> createState() => _WeeklyBoardState();
}

class _WeeklyBoardState extends State<WeeklyBoard> {
  late final PageController _controller;

  @override
  void initState() {
    super.initState();
    _controller = PageController(initialPage: WeeklyBoard.initialPage);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  DateTime _weekStartForPage(int page) {
    final DateTime currentWeek = weekStartOf(DateTime.now());
    return currentWeek.add(
      Duration(days: (page - WeeklyBoard.initialPage) * 7),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Text(
          _monthTitle(widget.selectedDay),
          style: const TextStyle(
            color: Color(0xFFF3E6C2),
            fontWeight: FontWeight.w700,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 78,
          child: PageView.builder(
            controller: _controller,
            itemCount: WeeklyBoard.pageCount,
            onPageChanged: (int page) {
              final DateTime start = _weekStartForPage(page);
              final DateTime next = start.add(
                Duration(days: widget.selectedDay.weekday - 1),
              );
              widget.onDaySelected(next);
            },
            itemBuilder: (BuildContext context, int page) {
              final DateTime start = _weekStartForPage(page);
              return Row(
                children: List<Widget>.generate(7, (int index) {
                  final DateTime day = start.add(Duration(days: index));
                  return Expanded(
                    child: _DayCell(
                      date: day,
                      selected: HomeController.isSameDay(
                        day,
                        widget.selectedDay,
                      ),
                      isToday: HomeController.isSameDay(day, DateTime.now()),
                      onTap: () => widget.onDaySelected(day),
                    ),
                  );
                }),
              );
            },
          ),
        ),
      ],
    );
  }

  String _monthTitle(DateTime date) {
    const List<String> months = <String>[
      'Janeiro',
      'Fevereiro',
      'Março',
      'Abril',
      'Maio',
      'Junho',
      'Julho',
      'Agosto',
      'Setembro',
      'Outubro',
      'Novembro',
      'Dezembro',
    ];
    return '${months[date.month - 1]} ${date.year}';
  }
}

class _DayCell extends StatelessWidget {
  const _DayCell({
    required this.date,
    required this.selected,
    required this.isToday,
    required this.onTap,
  });

  final DateTime date;
  final bool selected;
  final bool isToday;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final Color background = selected
        ? const Color(0xFFC9A227)
        : isToday
            ? const Color(0xFF3D2A16)
            : Colors.transparent;
    final Color foreground =
        selected ? const Color(0xFF1B1410) : const Color(0xFFE8D5B5);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2),
      child: Material(
        color: background,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isToday && !selected
                    ? const Color(0xFFC9A227)
                    : Colors.transparent,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  kWeekdayLabels[date.weekday - 1],
                  style: TextStyle(
                    color: foreground,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${date.day}',
                  style: TextStyle(
                    color: foreground,
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
