import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../habits/providers/home_controller.dart';
import '../widgets/avatar_widget.dart';

/// Full-size avatar view using the currently equipped items.
class AvatarScreen extends StatelessWidget {
  const AvatarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final HomeController controller = context.watch<HomeController>();
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 12, 12, 88),
        child: AvatarWidget(
          profile: controller.profile,
          equippedItems: controller.equippedItems,
          avatarHeight: 320,
        ),
      ),
    );
  }
}
