import 'package:flutter/material.dart';

import '../../inventory/models/inventory_item.dart';
import '../models/user_profile.dart';
import 'avatar_layer_resolver.dart';

/// Layered avatar panel: HP/XP bars on top, PNG stack aligned by weapon grip.
class AvatarWidget extends StatelessWidget {
  const AvatarWidget({
    super.key,
    required this.profile,
    required this.equippedItems,
    this.avatarHeight = 280,
  });

  final UserProfile profile;
  final List<InventoryItem> equippedItems;
  final double avatarHeight;

  @override
  Widget build(BuildContext context) {
    final AvatarLayerResolver resolver = AvatarLayerResolver(
      equippedItems: equippedItems,
    );

    return DecoratedBox(
      decoration: BoxDecoration(
        color: const Color(0xFF1B1410),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF6B4E31), width: 2),
        boxShadow: const <BoxShadow>[
          BoxShadow(
            color: Color(0x66000000),
            blurRadius: 12,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 12, 12, 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            _AvatarHud(profile: profile),
            const SizedBox(height: 12),
            SizedBox(
              height: avatarHeight,
              width: double.infinity,
              child: Stack(
                alignment: Alignment.center,
                fit: StackFit.expand,
                children: <Widget>[
                  _optionalLayer(
                    resolver.spritePath(ItemCategory.background),
                    fit: BoxFit.cover,
                  ),
                  _spriteLayer(resolver.bodyAssetPath),
                  _optionalLayer(resolver.spritePath(ItemCategory.outfit)),
                  _optionalLayer(resolver.spritePath(ItemCategory.accessory)),
                  _optionalLayer(resolver.spritePath(ItemCategory.weapon)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _optionalLayer(String? assetPath, {BoxFit fit = BoxFit.contain}) {
    if (assetPath == null) {
      return const SizedBox.shrink();
    }
    return _spriteLayer(assetPath, fit: fit);
  }

  Widget _spriteLayer(String assetPath, {BoxFit fit = BoxFit.contain}) {
    return Image.asset(
      assetPath,
      fit: fit,
      filterQuality: FilterQuality.none,
      errorBuilder: (
        BuildContext context,
        Object error,
        StackTrace? stackTrace,
      ) {
        return const SizedBox.shrink();
      },
    );
  }
}

class _AvatarHud extends StatelessWidget {
  const _AvatarHud({required this.profile});

  final UserProfile profile;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFF3D2A16),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: const Color(0xFFC9A227)),
              ),
              child: Text(
                'Nv. ${profile.level}',
                style: const TextStyle(
                  color: Color(0xFFF3E6C2),
                  fontWeight: FontWeight.w700,
                  fontSize: 12,
                ),
              ),
            ),
            const Spacer(),
            Text(
              '${profile.coins} moedas',
              style: const TextStyle(
                color: Color(0xFFE8C547),
                fontWeight: FontWeight.w600,
                fontSize: 12,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        _AnimatedStatBar(
          label: 'Vida',
          valueText: '${profile.currentHp}/${profile.maxHp}',
          progress: profile.hpProgress.clamp(0.0, 1.0),
          fill: const Color(0xFFC0392B),
          track: const Color(0xFF4A1C18),
        ),
        const SizedBox(height: 8),
        _AnimatedStatBar(
          label: 'Experiência',
          valueText: '${profile.currentXp}/${profile.maxXp}',
          progress: profile.xpProgress.clamp(0.0, 1.0),
          fill: const Color(0xFF2E86C1),
          track: const Color(0xFF1A3A52),
        ),
      ],
    );
  }
}

class _AnimatedStatBar extends StatelessWidget {
  const _AnimatedStatBar({
    required this.label,
    required this.valueText,
    required this.progress,
    required this.fill,
    required this.track,
  });

  final String label;
  final String valueText;
  final double progress;
  final Color fill;
  final Color track;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          children: <Widget>[
            Text(
              label,
              style: const TextStyle(
                color: Color(0xFFE8D5B5),
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
            ),
            const Spacer(),
            Text(
              valueText,
              style: const TextStyle(
                color: Color(0xFFD7C4A3),
                fontSize: 11,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        TweenAnimationBuilder<double>(
          tween: Tween<double>(begin: 0, end: progress),
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeOutCubic,
          builder: (BuildContext context, double value, Widget? child) {
            return ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: SizedBox(
                height: 10,
                child: Stack(
                  fit: StackFit.expand,
                  children: <Widget>[
                    ColoredBox(color: track),
                    FractionallySizedBox(
                      alignment: Alignment.centerLeft,
                      widthFactor: value,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: <Color>[
                              fill,
                              Color.lerp(fill, Colors.white, 0.18)!,
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
