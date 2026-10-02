/// Player RPG stats mapped to the `UserProfile` SQLite table.
///
/// A single row is stored (id = 1) and updated as habits are completed.
class UserProfile {
  const UserProfile({
    this.id = 1,
    required this.level,
    required this.currentXp,
    required this.maxXp,
    required this.currentHp,
    required this.maxHp,
    required this.coins,
  });

  /// Starting profile for a new player.
  factory UserProfile.initial() {
    return const UserProfile(
      level: 1,
      currentXp: 0,
      maxXp: 100,
      currentHp: 100,
      maxHp: 100,
      coins: 0,
    );
  }

  final int id;
  final int level;
  final int currentXp;
  final int maxXp;
  final int currentHp;
  final int maxHp;
  final int coins;

  double get xpProgress => maxXp == 0 ? 0 : currentXp / maxXp;

  double get hpProgress => maxHp == 0 ? 0 : currentHp / maxHp;

  factory UserProfile.fromMap(Map<String, dynamic> map) {
    return UserProfile(
      id: map['id'] as int? ?? 1,
      level: map['level'] as int,
      currentXp: map['currentXp'] as int,
      maxXp: map['maxXp'] as int,
      currentHp: map['currentHp'] as int,
      maxHp: map['maxHp'] as int,
      coins: map['coins'] as int,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'level': level,
      'currentXp': currentXp,
      'maxXp': maxXp,
      'currentHp': currentHp,
      'maxHp': maxHp,
      'coins': coins,
    };
  }

  UserProfile copyWith({
    int? id,
    int? level,
    int? currentXp,
    int? maxXp,
    int? currentHp,
    int? maxHp,
    int? coins,
  }) {
    return UserProfile(
      id: id ?? this.id,
      level: level ?? this.level,
      currentXp: currentXp ?? this.currentXp,
      maxXp: maxXp ?? this.maxXp,
      currentHp: currentHp ?? this.currentHp,
      maxHp: maxHp ?? this.maxHp,
      coins: coins ?? this.coins,
    );
  }
}
