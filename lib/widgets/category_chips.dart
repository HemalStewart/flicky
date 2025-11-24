import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

class CategoryChips extends StatelessWidget {
  const CategoryChips({
    super.key,
    this.active = 'Action',
    required this.onSelect,
  });

  final String active;
  final ValueChanged<String> onSelect;

  static const categories = [
    'Action',
    'Adventure',
    'Comedy',
    'Drama',
    'Sci-Fi',
    'Horror',
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 46,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        separatorBuilder: (_, i) => const SizedBox(width: 10),
        itemBuilder: (context, index) {
          final c = categories[index];
          final isActive = c == active;
          return GestureDetector(
            onTap: () => onSelect(c),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
              decoration: BoxDecoration(
                color: isActive ? AppColors.accent : AppColors.surface,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Text(
                c,
                style: TextStyle(
                  color: isActive ? Colors.white : AppColors.muted,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
