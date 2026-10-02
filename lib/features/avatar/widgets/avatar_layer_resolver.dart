import '../../inventory/models/inventory_item.dart';

/// Resolves body/outfit/weapon asset paths from equipped items and weapon grip.
class AvatarLayerResolver {
  const AvatarLayerResolver({required this.equippedItems});

  final List<InventoryItem> equippedItems;

  InventoryItem? itemFor(ItemCategory category) {
    for (final InventoryItem item in equippedItems) {
      if (item.category == category && item.isEquipped) {
        return item;
      }
    }
    for (final InventoryItem item in equippedItems) {
      if (item.category == category) {
        return item;
      }
    }
    return null;
  }

  /// Weapon grip drives which body and outfit pose files are used.
  GripType get activeGrip =>
      itemFor(ItemCategory.weapon)?.gripType ?? GripType.posicaoA;

  String get bodyAssetPath =>
      'assets/images/avatar/body_base_${activeGrip.poseAssetSuffix}.png';

  /// Returns `null` when the layer must be skipped (`hasCustomSprite == false`).
  String? spritePath(ItemCategory category) {
    final InventoryItem? item = itemFor(category);
    if (item == null || !item.hasCustomSprite || item.assetPath.isEmpty) {
      return null;
    }
    if (category == ItemCategory.outfit || category == ItemCategory.accessory) {
      return applyPose(item.assetPath, activeGrip);
    }
    return item.assetPath;
  }

  static String applyPose(String assetPath, GripType grip) {
    return assetPath.replaceAll(
      RegExp(r'pos[A-Da-d]'),
      grip.poseAssetSuffix,
    );
  }
}
