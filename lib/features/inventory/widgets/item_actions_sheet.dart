import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../habits/providers/home_controller.dart';
import '../models/inventory_item.dart';

Future<void> showItemActionsSheet(BuildContext context, InventoryItem item) {
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
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: const Color(0xFF6B4E31),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                item.name,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Color(0xFFF3E6C2),
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '${_categoryLabel(item.category)} · ${_rarityLabel(item.rarity)}',
                textAlign: TextAlign.center,
                style: const TextStyle(color: Color(0xFFB9A58A), fontSize: 12),
              ),
              const SizedBox(height: 16),
              if (!item.isPurchased)
                FilledButton.icon(
                  onPressed: () async {
                    final bool bought =
                        await context.read<HomeController>().buyItem(item);
                    if (!sheetContext.mounted) {
                      return;
                    }
                    Navigator.pop(sheetContext);
                    if (!context.mounted) {
                      return;
                    }
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          bought
                              ? '${item.name} comprado.'
                              : 'Moedas insuficientes (${item.coinPrice}).',
                        ),
                      ),
                    );
                  },
                  icon: const Icon(Icons.shopping_cart),
                  label: Text('Comprar · ${item.coinPrice} moedas'),
                )
              else ...<Widget>[
                if (!item.isEquipped)
                  FilledButton.icon(
                    onPressed: () async {
                      await context.read<HomeController>().equipOwnedItem(item);
                      if (sheetContext.mounted) {
                        Navigator.pop(sheetContext);
                      }
                    },
                    icon: const Icon(Icons.checkroom),
                    label: const Text('Equipar'),
                  )
                else
                  const Text(
                    'Este item já está equipado.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Color(0xFFC9A227)),
                  ),
                const SizedBox(height: 8),
                OutlinedButton.icon(
                  onPressed: () async {
                    final bool sold =
                        await context.read<HomeController>().salvageItem(item);
                    if (!sheetContext.mounted) {
                      return;
                    }
                    Navigator.pop(sheetContext);
                    if (!context.mounted) {
                      return;
                    }
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          sold
                              ? '${item.name} desmontado · +${item.salvageValue} moedas'
                              : 'Não foi possível vender este item.',
                        ),
                      ),
                    );
                  },
                  icon: const Icon(Icons.recycling),
                  label: Text(
                    'Vender / desmontar · ${item.salvageValue} moedas',
                  ),
                ),
              ],
            ],
          ),
        ),
      );
    },
  );
}

String _categoryLabel(ItemCategory category) {
  switch (category) {
    case ItemCategory.weapon:
      return 'Arma';
    case ItemCategory.outfit:
      return 'Roupa';
    case ItemCategory.accessory:
      return 'Acessório';
    case ItemCategory.background:
      return 'Fundo';
  }
}

String _rarityLabel(ItemRarity rarity) {
  switch (rarity) {
    case ItemRarity.common:
      return 'Comum';
    case ItemRarity.uncommon:
      return 'Incomum';
    case ItemRarity.rare:
      return 'Raro';
    case ItemRarity.epic:
      return 'Épico';
    case ItemRarity.legendary:
      return 'Lendário';
  }
}
