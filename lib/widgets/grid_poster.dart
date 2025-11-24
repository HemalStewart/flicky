import 'package:flutter/material.dart';

import '../models/media_item.dart';
import '../theme/app_colors.dart';

class GridPoster extends StatelessWidget {
  const GridPoster({
    super.key,
    required this.item,
    this.highlight = false,
    this.onTap,
  });

  final MediaItem item;
  final bool highlight;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          border: highlight
              ? Border.all(color: AppColors.accent, width: 1)
              : Border.all(color: Colors.transparent, width: 0),
          color: AppColors.surface,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: SizedBox.expand(
                  child: Hero(
                    tag: 'grid-${item.imageUrl}-${item.title}',
                    child: Image.network(
                      item.imageUrl,
                      fit: BoxFit.cover,
                      alignment: Alignment.center,
                      errorBuilder: (context, error, stackTrace) =>
                          Container(color: AppColors.surface),
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 6),
              child: Text(
                item.title,
                style: Theme.of(
                  context,
                ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 8),
              child: Row(
                children: [
                  Text(
                    item.year,
                    style: TextStyle(color: AppColors.muted, fontSize: 12),
                  ),
                  const Spacer(),
                  Text(
                    item.duration,
                    style: TextStyle(color: AppColors.muted, fontSize: 12),
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
