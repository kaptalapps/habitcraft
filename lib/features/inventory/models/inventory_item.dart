/// Cosmetic / equipment slot for shop and avatar layering.
enum ItemCategory {
  weapon,
  outfit,
  accessory,
  background,
}

/// Visual rarity used in the shop and inventory UI.
enum ItemRarity {
  common,
  uncommon,
  rare,
  epic,
  legendary,
}

/// Grip pose used to align layered PNG sprites on the avatar [Stack].
///
/// Matches the three engine positions from the avatar spec.
enum GripType {
  posicaoA('posicao_A'),
  posicaoB('posicao_B'),
  posicaoC('posicao_C');

  const GripType(this.storageValue);

  /// Canonical string persisted in SQLite.
  final String storageValue;

  /// Suffix used by body/outfit PNG files (`posA`, `posB`, `posC`).
  String get poseAssetSuffix {
    switch (this) {
      case GripType.posicaoA:
        return 'posA';
      case GripType.posicaoB:
        return 'posB';
      case GripType.posicaoC:
        return 'posC';
    }
  }

  static GripType fromStorage(String value) {
    return GripType.values.firstWhere(
      (GripType type) => type.storageValue == value || type.name == value,
      orElse: () => GripType.posicaoA,
    );
  }
}

/// Domain model mapped to the `Inventory` SQLite table.
class InventoryItem {
  const InventoryItem({
    this.id,
    required this.name,
    required this.category,
    required this.rarity,
    required this.assetPath,
    required this.placeholderAssetPath,
    required this.hasCustomSprite,
    required this.gripType,
    this.isEquipped = false,
    this.isPurchased = false,
  });

  final int? id;
  final String name;
  final ItemCategory category;
  final ItemRarity rarity;
  final String assetPath;
  final String placeholderAssetPath;

  /// When `false`, show [placeholderAssetPath] in shop/inventory and skip
  /// this layer on the avatar stack.
  final bool hasCustomSprite;
  final GripType gripType;
  final bool isEquipped;
  final bool isPurchased;

  /// Shop price derived from rarity.
  int get coinPrice {
    switch (rarity) {
      case ItemRarity.common:
        return 40;
      case ItemRarity.uncommon:
        return 80;
      case ItemRarity.rare:
        return 160;
      case ItemRarity.epic:
        return 320;
      case ItemRarity.legendary:
        return 640;
    }
  }

  /// Coins returned when selling or dismantling (50% of [coinPrice]).
  int get salvageValue => coinPrice ~/ 2;

  /// Path to render in lists (placeholder if the custom sprite is missing).
  String get displayAssetPath =>
      hasCustomSprite ? assetPath : placeholderAssetPath;

  factory InventoryItem.fromMap(Map<String, dynamic> map) {
    return InventoryItem(
      id: map['id'] as int?,
      name: map['name'] as String,
      category: ItemCategory.values.byName(map['category'] as String),
      rarity: ItemRarity.values.byName(map['rarity'] as String),
      assetPath: map['assetPath'] as String,
      placeholderAssetPath: map['placeholderAssetPath'] as String,
      hasCustomSprite: (map['hasCustomSprite'] as int? ?? 0) == 1,
      gripType: GripType.fromStorage(map['gripType'] as String),
      isEquipped: (map['isEquipped'] as int? ?? 0) == 1,
      isPurchased: (map['isPurchased'] as int? ?? 0) == 1,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      if (id != null) 'id': id,
      'name': name,
      'category': category.name,
      'rarity': rarity.name,
      'assetPath': assetPath,
      'placeholderAssetPath': placeholderAssetPath,
      'hasCustomSprite': hasCustomSprite ? 1 : 0,
      'gripType': gripType.storageValue,
      'isEquipped': isEquipped ? 1 : 0,
      'isPurchased': isPurchased ? 1 : 0,
    };
  }

  InventoryItem copyWith({
    int? id,
    String? name,
    ItemCategory? category,
    ItemRarity? rarity,
    String? assetPath,
    String? placeholderAssetPath,
    bool? hasCustomSprite,
    GripType? gripType,
    bool? isEquipped,
    bool? isPurchased,
  }) {
    return InventoryItem(
      id: id ?? this.id,
      name: name ?? this.name,
      category: category ?? this.category,
      rarity: rarity ?? this.rarity,
      assetPath: assetPath ?? this.assetPath,
      placeholderAssetPath:
          placeholderAssetPath ?? this.placeholderAssetPath,
      hasCustomSprite: hasCustomSprite ?? this.hasCustomSprite,
      gripType: gripType ?? this.gripType,
      isEquipped: isEquipped ?? this.isEquipped,
      isPurchased: isPurchased ?? this.isPurchased,
    );
  }
}
