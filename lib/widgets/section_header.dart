import 'package:flutter/material.dart';

class SectionHeader extends StatelessWidget {
  const SectionHeader({super.key, required this.title, this.actionIcon});

  final String title;
  final IconData? actionIcon;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          title,
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
        ),
        const Spacer(),
        if (actionIcon != null)
          Icon(actionIcon, color: Theme.of(context).iconTheme.color),
      ],
    );
  }
}
