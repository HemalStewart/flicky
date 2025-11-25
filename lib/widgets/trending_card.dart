import 'package:flutter/material.dart';

import '../models/media_item.dart';
import '../theme/app_colors.dart';
import 'tap_scale.dart';

class TrendingCard extends StatelessWidget {
  const TrendingCard({super.key, required this.item, this.onTap});

  final MediaItem item;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return TapScale(
      onTap: onTap,
      child: Container(
        width: 250,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: const Color.fromRGBO(255, 255, 255, 0.15)),
          color: Theme.of(context).cardColor.withValues(alpha: 0.35),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 16,
              offset: Offset(0, 10),
            ),
          ],
        ),
        child: Stack(
          children: [
            Positioned.fill(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(18),
                child: Hero(
                  tag: 'trending-${item.imageUrl}-${item.title}',
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(18),
                    child: Image.network(
                      item.imageUrl,
                      fit: BoxFit.cover,
                      loadingBuilder: (context, child, progress) {
                        if (progress == null) return child;
                        return Container(color: Theme.of(context).cardColor);
                      },
                      errorBuilder: (context, error, stackTrace) => Container(
                        color: Theme.of(context).cardColor,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(18),
                  gradient: const LinearGradient(
                    colors: [Colors.transparent, Color(0xCC0F1117)],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    stops: [0.55, 1],
                  ),
                ),
              ),
            ),
            Positioned(
              left: 12,
              bottom: 12,
              right: 12,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      _Chip(text: item.year),
                      const SizedBox(width: 6),
                      _Chip(text: item.duration),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    item.title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    item.category,
                    style: TextStyle(
                      color: AppColors.muted,
                      fontWeight: FontWeight.w500,
                    ),
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

class _Chip extends StatelessWidget {
  const _Chip({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: const Color.fromRGBO(0, 0, 0, 0.55),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
