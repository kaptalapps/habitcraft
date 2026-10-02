/// Difficulty used to scale XP, coin rewards and HP penalty.
enum HabitDifficulty {
  easy,
  medium,
  hard,
}

/// How often the habit is expected to be completed.
enum HabitFrequency {
  daily,
  weekly,
  custom,
}

/// Domain model mapped to the `Habits` SQLite table.
class Habit {
  const Habit({
    this.id,
    required this.title,
    required this.difficulty,
    required this.xpReward,
    required this.coinsReward,
    required this.hpPenalty,
    this.streak = 0,
    this.isCompletedToday = false,
    this.frequency = HabitFrequency.daily,
    this.weekdays = const <int>[],
  });

  final int? id;
  final String title;
  final HabitDifficulty difficulty;
  final int xpReward;
  final int coinsReward;
  final int hpPenalty;
  final int streak;
  final bool isCompletedToday;
  final HabitFrequency frequency;

  /// ISO weekdays (`1` = Monday … `7` = Sunday). Empty means every day.
  final List<int> weekdays;

  /// Builds a habit with default RPG rewards for the given [difficulty].
  factory Habit.create({
    required String title,
    required HabitDifficulty difficulty,
    HabitFrequency frequency = HabitFrequency.daily,
    List<int> weekdays = const <int>[],
  }) {
    switch (difficulty) {
      case HabitDifficulty.easy:
        return Habit(
          title: title,
          difficulty: difficulty,
          xpReward: 10,
          coinsReward: 5,
          hpPenalty: 5,
          frequency: frequency,
          weekdays: weekdays,
        );
      case HabitDifficulty.medium:
        return Habit(
          title: title,
          difficulty: difficulty,
          xpReward: 25,
          coinsReward: 15,
          hpPenalty: 10,
          frequency: frequency,
          weekdays: weekdays,
        );
      case HabitDifficulty.hard:
        return Habit(
          title: title,
          difficulty: difficulty,
          xpReward: 50,
          coinsReward: 30,
          hpPenalty: 20,
          frequency: frequency,
          weekdays: weekdays,
        );
    }
  }

  bool get isDaily => frequency == HabitFrequency.daily;

  /// Daily habits always apply; specific ones match [date]'s weekday.
  bool appliesTo(DateTime date) {
    if (isDaily || weekdays.isEmpty) {
      return true;
    }
    return weekdays.contains(date.weekday);
  }

  factory Habit.fromMap(Map<String, dynamic> map) {
    return Habit(
      id: map['id'] as int?,
      title: map['title'] as String,
      difficulty: HabitDifficulty.values.byName(map['difficulty'] as String),
      xpReward: map['xpReward'] as int,
      coinsReward: map['coinsReward'] as int,
      hpPenalty: map['hpPenalty'] as int,
      streak: map['streak'] as int? ?? 0,
      isCompletedToday: (map['isCompletedToday'] as int? ?? 0) == 1,
      frequency: HabitFrequency.values.byName(map['frequency'] as String),
      weekdays: _weekdaysFromStorage(map['weekdays']),
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      if (id != null) 'id': id,
      'title': title,
      'difficulty': difficulty.name,
      'xpReward': xpReward,
      'coinsReward': coinsReward,
      'hpPenalty': hpPenalty,
      'streak': streak,
      'isCompletedToday': isCompletedToday ? 1 : 0,
      'frequency': frequency.name,
      'weekdays': weekdays.join(','),
    };
  }

  static List<int> _weekdaysFromStorage(Object? raw) {
    if (raw is! String || raw.isEmpty) {
      return const <int>[];
    }
    return raw
        .split(',')
        .where((String part) => part.isNotEmpty)
        .map(int.parse)
        .toList();
  }

  Habit copyWith({
    int? id,
    String? title,
    HabitDifficulty? difficulty,
    int? xpReward,
    int? coinsReward,
    int? hpPenalty,
    int? streak,
    bool? isCompletedToday,
    HabitFrequency? frequency,
    List<int>? weekdays,
  }) {
    return Habit(
      id: id ?? this.id,
      title: title ?? this.title,
      difficulty: difficulty ?? this.difficulty,
      xpReward: xpReward ?? this.xpReward,
      coinsReward: coinsReward ?? this.coinsReward,
      hpPenalty: hpPenalty ?? this.hpPenalty,
      streak: streak ?? this.streak,
      isCompletedToday: isCompletedToday ?? this.isCompletedToday,
      frequency: frequency ?? this.frequency,
      weekdays: weekdays ?? this.weekdays,
    );
  }
}
