import 'package:flutter/foundation.dart';

import '../../../core/database/database_helper.dart';
import '../../avatar/models/user_profile.dart';
import '../../inventory/models/inventory_item.dart';
import '../models/habit.dart';

/// Loads home data and applies habit completion rewards.
class HomeController extends ChangeNotifier {
  HomeController({DatabaseHelper? database})
      : _database = database ?? DatabaseHelper.instance;

  final DatabaseHelper _database;

  bool isLoading = true;
  UserProfile profile = UserProfile.initial();
  List<InventoryItem> equippedItems = const <InventoryItem>[];
  List<InventoryItem> catalog = const <InventoryItem>[];
  List<Habit> habits = const <Habit>[];
  DateTime selectedDay = _dateOnly(DateTime.now());

  bool get isSelectedToday => isSameDay(selectedDay, DateTime.now());

  List<Habit> get dailyHabits => habits
      .where((Habit habit) => habit.isDaily && habit.appliesTo(selectedDay))
      .toList();

  List<Habit> get specificHabits => habits
      .where((Habit habit) => !habit.isDaily && habit.appliesTo(selectedDay))
      .toList();

  List<InventoryItem> get ownedItems => catalog
      .where((InventoryItem item) => item.isPurchased)
      .toList();

  List<InventoryItem> get shopItems => catalog
      .where((InventoryItem item) => !item.isPurchased)
      .toList();

  Future<void> load() async {
    isLoading = true;
    notifyListeners();
    profile = await _database.getUserProfile();
    equippedItems = await _database.getEquippedItems();
    catalog = await _database.getInventoryItems();
    habits = await _database.getHabits();
    isLoading = false;
    notifyListeners();
  }

  void selectDay(DateTime day) {
    final DateTime normalized = _dateOnly(day);
    if (isSameDay(normalized, selectedDay)) {
      return;
    }
    selectedDay = normalized;
    notifyListeners();
  }

  Future<void> addHabit(Habit habit) async {
    await _database.insertHabit(habit);
    habits = await _database.getHabits();
    notifyListeners();
  }

  Future<void> _refreshEconomy() async {
    profile = await _database.getUserProfile();
    equippedItems = await _database.getEquippedItems();
    catalog = await _database.getInventoryItems();
    notifyListeners();
  }

  /// Buys a shop item. Returns `false` when coins are insufficient.
  Future<bool> buyItem(InventoryItem item) async {
    if (item.id == null || item.isPurchased) {
      return false;
    }
    if (profile.coins < item.coinPrice) {
      return false;
    }
    await _database.updateUserProfile(
      profile.copyWith(coins: profile.coins - item.coinPrice),
    );
    await _database.updateInventoryItem(item.copyWith(isPurchased: true));
    await _refreshEconomy();
    return true;
  }

  Future<void> equipOwnedItem(InventoryItem item) async {
    if (item.id == null || !item.isPurchased) {
      return;
    }
    await _database.equipItem(item.id!);
    await _refreshEconomy();
  }

  /// Sells/dismantles an owned item for 50% of its shop price.
  Future<bool> salvageItem(InventoryItem item) async {
    if (item.id == null || !item.isPurchased) {
      return false;
    }
    await _database.salvageItem(item.id!);
    await _database.updateUserProfile(
      profile.copyWith(coins: profile.coins + item.salvageValue),
    );
    await _refreshEconomy();
    return true;
  }

  Future<void> toggleHabit(Habit habit) async {
    if (!isSelectedToday || habit.id == null) {
      return;
    }
    final bool completing = !habit.isCompletedToday;
    final Habit updated = habit.copyWith(
      isCompletedToday: completing,
      streak: completing
          ? habit.streak + 1
          : (habit.streak > 0 ? habit.streak - 1 : 0),
    );
    await _database.updateHabit(updated);

    UserProfile nextProfile = completing
        ? _applyRewards(profile, habit)
        : _revertRewards(profile, habit);
    await _database.updateUserProfile(nextProfile);

    profile = nextProfile;
    habits = await _database.getHabits();
    notifyListeners();
  }

  UserProfile _applyRewards(UserProfile current, Habit habit) {
    int xp = current.currentXp + habit.xpReward;
    int level = current.level;
    int maxXp = current.maxXp;
    while (xp >= maxXp) {
      xp -= maxXp;
      level += 1;
      maxXp += 25;
    }
    return current.copyWith(
      currentXp: xp,
      level: level,
      maxXp: maxXp,
      coins: current.coins + habit.coinsReward,
    );
  }

  UserProfile _revertRewards(UserProfile current, Habit habit) {
    int xp = current.currentXp - habit.xpReward;
    int level = current.level;
    int maxXp = current.maxXp;
    int coins = current.coins - habit.coinsReward;
    if (coins < 0) {
      coins = 0;
    }
    while (xp < 0 && level > 1) {
      level -= 1;
      maxXp = maxXp > 25 ? maxXp - 25 : 100;
      xp += maxXp;
    }
    if (xp < 0) {
      xp = 0;
    }
    return current.copyWith(
      currentXp: xp,
      level: level,
      maxXp: maxXp,
      coins: coins,
    );
  }

  static DateTime _dateOnly(DateTime value) =>
      DateTime(value.year, value.month, value.day);

  static bool isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;
}
