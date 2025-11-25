import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

class SearchBarField extends StatelessWidget {
  const SearchBarField({super.key, required this.hint, this.onTapFilter});

  final String hint;
  final VoidCallback? onTapFilter;

  @override
  Widget build(BuildContext context) {
    final iconColor = Theme.of(context).iconTheme.color ?? Colors.white;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: Theme.of(context).dividerColor.withValues(alpha: 0.2),
        ),
      ),
      child: Row(
        children: [
          const SizedBox(width: 4),
          Icon(Icons.search, color: iconColor),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              hint,
              style: TextStyle(
                color: AppColors.muted,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          GestureDetector(
            onTap: onTapFilter,
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Theme.of(context)
                    .colorScheme
                    .onSurface
                    .withValues(alpha: 0.08),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.tune, color: iconColor),
            ),
          ),
        ],
      ),
    );
  }
}
