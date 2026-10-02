import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../../features/avatar/models/user_profile.dart';
import '../../features/habits/models/habit.dart';
import '../../features/inventory/models/inventory_item.dart';

/// Local SQLite access layer for HabitCraft (offline-first).
///
/// Tables: `Habits`, `UserProfile`, `Inventory`.
class DatabaseHelper {
  DatabaseHelper._();

  static final DatabaseHelper instance = DatabaseHelper._();

  static const String _databaseName = 'habitcraft.db';
  static const int _databaseVersion = 2;

  static const String tableHabits = 'Habits';
  static const String tableUserProfile = 'UserProfile';
  static const String tableInventory = 'Inventory';

  static const String _placeholderPath =
      'assets/images/placeholders/item_placeholder.png';

  Database? _database;

  Future<Database> get database async {
    final Database? existing = _database;
    if (existing != null) {
      return existing;
    }
    final Database opened = await _initDatabase();
    _database = opened;
    return opened;
  }

  Future<Database> _initDatabase() async {
    final String dbPath = join(await getDatabasesPath(), _databaseName);
    return openDatabase(
      dbPath,
      version: _databaseVersion,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $tableHabits (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        difficulty TEXT NOT NULL,
        xpReward INTEGER NOT NULL,
        coinsReward INTEGER NOT NULL,
        hpPenalty INTEGER NOT NULL,
        streak INTEGER NOT NULL DEFAULT 0,
        isCompletedToday INTEGER NOT NULL DEFAULT 0,
        frequency TEXT NOT NULL,
        weekdays TEXT NOT NULL DEFAULT ''
      )
    ''');

    await db.execute('''
      CREATE TABLE $tableUserProfile (
        id INTEGER PRIMARY KEY,
        level INTEGER NOT NULL,
        currentXp INTEGER NOT NULL,
        maxXp INTEGER NOT NULL,
        currentHp INTEGER NOT NULL,
        maxHp INTEGER NOT NULL,
        coins INTEGER NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE $tableInventory (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        category TEXT NOT NULL,
        rarity TEXT NOT NULL,
        assetPath TEXT NOT NULL,
        placeholderAssetPath TEXT NOT NULL,
        hasCustomSprite INTEGER NOT NULL,
        gripType TEXT NOT NULL,
        isEquipped INTEGER NOT NULL DEFAULT 0,
        isPurchased INTEGER NOT NULL DEFAULT 0
      )
    ''');

    await db.insert(tableUserProfile, UserProfile.initial().toMap());
    await _seedInventory(db);
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute(
        "ALTER TABLE $tableHabits ADD COLUMN weekdays TEXT NOT NULL DEFAULT ''",
      );
    }
  }

  /// Catalog used by the shop; most items start locked (`isPurchased = 0`).
  Future<void> _seedInventory(Database db) async {
    final List<InventoryItem> catalog = <InventoryItem>[
      const InventoryItem(
        name: 'Espada de Ferro',
        category: ItemCategory.weapon,
        rarity: ItemRarity.common,
        assetPath: 'assets/images/items/sword_iron_posB.png',
        placeholderAssetPath: _placeholderPath,
        hasCustomSprite: true,
        gripType: GripType.posicaoB,
        isPurchased: true,
        isEquipped: true,
      ),
      const InventoryItem(
        name: 'Espada de Bronze',
        category: ItemCategory.weapon,
        rarity: ItemRarity.common,
        assetPath: 'assets/images/items/sword_bronze_posB.png',
        placeholderAssetPath: _placeholderPath,
        hasCustomSprite: true,
        gripType: GripType.posicaoB,
        isPurchased: true,
        isEquipped: true,
      ),
      const InventoryItem(
        name: 'Espada de Prata',
        category: ItemCategory.weapon,
        rarity: ItemRarity.common,
        assetPath: 'assets/images/items/sword_silver_posB.png',
        placeholderAssetPath: _placeholderPath,
        hasCustomSprite: true,
        gripType: GripType.posicaoB,
        isPurchased: true,
        isEquipped: true,
      ),
      const InventoryItem(
        name: 'Espada de Ouro',
        category: ItemCategory.weapon,
        rarity: ItemRarity.common,
        assetPath: 'assets/images/items/sword_gold_posB.png',
        placeholderAssetPath: _placeholderPath,
        hasCustomSprite: true,
        gripType: GripType.posicaoB,
        isPurchased: true,
        isEquipped: true,
      ),
      const InventoryItem(
        name: 'Espada de Diamante',
        category: ItemCategory.weapon,
        rarity: ItemRarity.common,
        assetPath: 'assets/images/items/sword_diamond_posB.png',
        placeholderAssetPath: _placeholderPath,
        hasCustomSprite: true,
        gripType: GripType.posicaoB,
        isPurchased: true,
        isEquipped: true,
      ),
      const InventoryItem(
        name: 'Espada de Ametista',
        category: ItemCategory.weapon,
        rarity: ItemRarity.common,
        assetPath: 'assets/images/items/sword_amethyst_posB.png',
        placeholderAssetPath: _placeholderPath,
        hasCustomSprite: true,
        gripType: GripType.posicaoB,
        isPurchased: true,
        isEquipped: true,
      ),
      const InventoryItem(
        name: 'Armadura de Cavaleiro',
        category: ItemCategory.outfit,
        rarity: ItemRarity.uncommon,
        assetPath: 'assets/images/outfits/knight_posA.png',
        placeholderAssetPath: _placeholderPath,
        hasCustomSprite: true,
        gripType: GripType.posicaoA,
        isPurchased: true,
        isEquipped: true,
      ),
      const InventoryItem(
        name: 'Capa do Viajante',
        category: ItemCategory.outfit,
        rarity: ItemRarity.common,
        assetPath: '',
        placeholderAssetPath: _placeholderPath,
        hasCustomSprite: false,
        gripType: GripType.posicaoA,
      ),
      const InventoryItem(
        name: 'Machado Rúnico',
        category: ItemCategory.weapon,
        rarity: ItemRarity.rare,
        assetPath: '',
        placeholderAssetPath: _placeholderPath,
        hasCustomSprite: false,
        gripType: GripType.posicaoC,
      ),
      const InventoryItem(
        name: 'Elmo Ancestral',
        category: ItemCategory.accessory,
        rarity: ItemRarity.epic,
        assetPath: '',
        placeholderAssetPath: _placeholderPath,
        hasCustomSprite: false,
        gripType: GripType.posicaoA,
      ),
      const InventoryItem(
        name: 'Taberna (fundo)',
        category: ItemCategory.background,
        rarity: ItemRarity.common,
        assetPath: 'assets/images/background/bg_tavern.png',
        placeholderAssetPath: _placeholderPath,
        hasCustomSprite: true,
        gripType: GripType.posicaoA,
        isPurchased: true,
        isEquipped: true,
      ),
    ];

    for (final InventoryItem item in catalog) {
      await db.insert(tableInventory, item.toMap());
    }
  }

  // --- Habits ---

  Future<int> insertHabit(Habit habit) async {
    final Database db = await database;
    return db.insert(tableHabits, habit.toMap());
  }

  Future<List<Habit>> getHabits() async {
    final Database db = await database;
    final List<Map<String, dynamic>> rows = await db.query(
      tableHabits,
      orderBy: 'id DESC',
    );
    return rows.map(Habit.fromMap).toList();
  }

  Future<Habit?> getHabitById(int id) async {
    final Database db = await database;
    final List<Map<String, dynamic>> rows = await db.query(
      tableHabits,
      where: 'id = ?',
      whereArgs: <Object>[id],
      limit: 1,
    );
    if (rows.isEmpty) {
      return null;
    }
    return Habit.fromMap(rows.first);
  }

  Future<int> updateHabit(Habit habit) async {
    final Database db = await database;
    return db.update(
      tableHabits,
      habit.toMap(),
      where: 'id = ?',
      whereArgs: <Object?>[habit.id],
    );
  }

  Future<int> deleteHabit(int id) async {
    final Database db = await database;
    return db.delete(
      tableHabits,
      where: 'id = ?',
      whereArgs: <Object>[id],
    );
  }

  /// Resets daily completion flags (call on a new local day).
  Future<int> resetDailyHabitCompletions() async {
    final Database db = await database;
    return db.update(
      tableHabits,
      <String, Object>{'isCompletedToday': 0},
    );
  }

  // --- UserProfile ---

  Future<UserProfile> getUserProfile() async {
    final Database db = await database;
    final List<Map<String, dynamic>> rows = await db.query(
      tableUserProfile,
      where: 'id = ?',
      whereArgs: <Object>[1],
      limit: 1,
    );
    if (rows.isEmpty) {
      final UserProfile initial = UserProfile.initial();
      await db.insert(tableUserProfile, initial.toMap());
      return initial;
    }
    return UserProfile.fromMap(rows.first);
  }

  Future<int> updateUserProfile(UserProfile profile) async {
    final Database db = await database;
    return db.update(
      tableUserProfile,
      profile.toMap(),
      where: 'id = ?',
      whereArgs: <Object>[profile.id],
    );
  }

  // --- Inventory ---

  Future<List<InventoryItem>> getInventoryItems() async {
    final Database db = await database;
    final List<Map<String, dynamic>> rows = await db.query(
      tableInventory,
      orderBy: 'id ASC',
    );
    return rows.map(InventoryItem.fromMap).toList();
  }

  Future<List<InventoryItem>> getPurchasedItems() async {
    final Database db = await database;
    final List<Map<String, dynamic>> rows = await db.query(
      tableInventory,
      where: 'isPurchased = ?',
      whereArgs: <Object>[1],
      orderBy: 'id ASC',
    );
    return rows.map(InventoryItem.fromMap).toList();
  }

  Future<List<InventoryItem>> getEquippedItems() async {
    final Database db = await database;
    final List<Map<String, dynamic>> rows = await db.query(
      tableInventory,
      where: 'isEquipped = ?',
      whereArgs: <Object>[1],
    );
    return rows.map(InventoryItem.fromMap).toList();
  }

  Future<int> updateInventoryItem(InventoryItem item) async {
    final Database db = await database;
    return db.update(
      tableInventory,
      item.toMap(),
      where: 'id = ?',
      whereArgs: <Object?>[item.id],
    );
  }

  /// Unequips and returns the item to the shop catalog.
  Future<int> salvageItem(int itemId) async {
    final Database db = await database;
    return db.update(
      tableInventory,
      <String, Object>{'isPurchased': 0, 'isEquipped': 0},
      where: 'id = ?',
      whereArgs: <Object>[itemId],
    );
  }

  /// Equips [itemId] and unequips other items in the same [ItemCategory].
  Future<void> equipItem(int itemId) async {
    final Database db = await database;
    final List<Map<String, dynamic>> rows = await db.query(
      tableInventory,
      where: 'id = ?',
      whereArgs: <Object>[itemId],
      limit: 1,
    );
    if (rows.isEmpty) {
      return;
    }
    final InventoryItem item = InventoryItem.fromMap(rows.first);
    await db.update(
      tableInventory,
      <String, Object>{'isEquipped': 0},
      where: 'category = ?',
      whereArgs: <Object>[item.category.name],
    );
    await db.update(
      tableInventory,
      <String, Object>{'isEquipped': 1, 'isPurchased': 1},
      where: 'id = ?',
      whereArgs: <Object>[itemId],
    );
  }

  /// Marks every catalog item as purchased so they appear in inventory tests.
  Future<int> unlockAllItemsDevMode() async {
    final Database db = await database;
    return db.update(
      tableInventory,
      <String, Object>{'isPurchased': 1},
    );
  }

  /// Closes the connection (useful in tests).
  Future<void> close() async {
    final Database? db = _database;
    if (db != null) {
      await db.close();
      _database = null;
    }
  }
}
