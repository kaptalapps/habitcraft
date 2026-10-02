import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../habits/providers/home_controller.dart';
import '../models/inventory_item.dart';
import '../widgets/item_actions_sheet.dart';
import '../widgets/item_grid_tile.dart';

/// Inventory (owned) and shop (locked) grids with equip/buy/salvage actions.
class InventoryScreen extends StatelessWidget {
  const InventoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final HomeController controller = context.watch<HomeController>();

    return DefaultTabController(
      length: 2,
      child: SafeArea(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
              child: Row(
                children: <Widget>[
                  const Text(
                    'Baú do herói',
                    style: TextStyle(
                      color: Color(0xFFF3E6C2),
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const Spacer(),
                  const Icon(Icons.monetization_on, color: Color(0xFFE8C547), size: 18),
                  const SizedBox(width: 6),
                  Text(
                    '${controller.profile.coins}',
                    style: const TextStyle(
                      color: Color(0xFFE8C547),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
            const TabBar(
              indicatorColor: Color(0xFFC9A227),
              labelColor: Color(0xFFC9A227),
              unselectedLabelColor: Color(0xFF8A7460),
              tabs: <Widget>[
                Tab(text: 'Inventário'),
                Tab(text: 'Loja'),
              ],
            ),
            Expanded(
              child: TabBarView(
                children: <Widget>[
                  _ItemGrid(
                    items: controller.ownedItems,
                    emptyLabel: 'Nenhum item no inventário.',
                  ),
                  _ItemGrid(
                    items: controller.shopItems,
                    emptyLabel: 'A loja está vazia.',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ItemGrid extends StatelessWidget {
  const _ItemGrid({
    required this.items,
    required this.emptyLabel,
  });

  final List<InventoryItem> items;
  final String emptyLabel;

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return Center(
        child: Text(
          emptyLabel,
          style: const TextStyle(color: Color(0xFF8A7460)),
        ),
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 88),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        childAspectRatio: 0.82,
      ),
      itemCount: items.length,
      itemBuilder: (BuildContext context, int index) {
        final InventoryItem item = items[index];
        return ItemGridTile(
          item: item,
          onTap: () => showItemActionsSheet(context, item),
        );
      },
    );
  }
}
