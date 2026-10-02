import 'package:flutter/material.dart';

import '../models/inventory_item.dart';

class ItemGridTile extends StatelessWidget {
  const ItemGridTile({
    super.key,
    required this.item,
    required this.onTap,
  });

  final InventoryItem item;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final Color rarityColor = _rarityColor(item.rarity);
    return Material(
      color: const Color(0xFF2A1C14),
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Ink(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: rarityColor, width: 1.4),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              children: <Widget>[
                Expanded(child: _ItemPreview(item: item)),
                const SizedBox(height: 6),
                Text(
                  item.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Color(0xFFF3E6C2),
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  item.isPurchased
                      ? (item.isEquipped ? 'Equipado' : 'Possuído')
                      : '${item.coinPrice} moedas',
                  style: TextStyle(
                    color: item.isEquipped
                        ? const Color(0xFFC9A227)
                        : const Color(0xFFB9A58A),
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Color _rarityColor(ItemRarity rarity) {
    switch (rarity) {
      case ItemRarity.common:
        return const Color(0xFF8A7460);
      case ItemRarity.uncommon:
        return const Color(0xFF3D9E5F);
      case ItemRarity.rare:
        return const Color(0xFF2E86C1);
      case ItemRarity.epic:
        return const Color(0xFF8E44AD);
      case ItemRarity.legendary:
        return const Color(0xFFC9A227);
    }
  }
}

/// Renders the custom sprite, or the placeholder plus a mystery/chest overlay.
class _ItemPreview extends StatelessWidget {
  const _ItemPreview({required this.item});

  final InventoryItem item;

  @override
  Widget build(BuildContext context) {
    final String path = item.hasCustomSprite
        ? item.assetPath
        : item.placeholderAssetPath;

    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: ColoredBox(
        color: const Color(0xFF1B1410),
        child: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            Image.asset(
              path,
              fit: BoxFit.contain,
              filterQuality: FilterQuality.none,
              errorBuilder: (
                BuildContext context,
                Object error,
                StackTrace? stackTrace,
              ) {
                return const ColoredBox(color: Color(0xFF1B1410));
              },
            ),
            if (!item.hasCustomSprite)
              const ColoredBox(
                color: Color(0x99000000),
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Icon(
                        Icons.help_outline,
                        color: Color(0xFFC9A227),
                        size: 28,
                      ),
                      SizedBox(height: 4),
                      Icon(
                        Icons.inventory_2_outlined,
                        color: Color(0xFFE8D5B5),
                        size: 18,
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
