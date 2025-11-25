import 'package:flutter/material.dart';

import '../widgets/staggered_fade_slide.dart';
import '../widgets/tap_scale.dart';

class MenuView extends StatelessWidget {
  const MenuView({super.key});

  @override
  Widget build(BuildContext context) {
    final items = [
      _MenuItem(Icons.article_outlined, 'Terms & Conditions'),
      _MenuItem(Icons.privacy_tip_outlined, 'Privacy Policy'),
      _MenuItem(Icons.shopping_bag_outlined, 'Buy Our Subscription'),
      _MenuItem(Icons.share_outlined, 'Share App'),
      _MenuItem(Icons.apps_outage_outlined, 'More App'),
      _MenuItem(Icons.star_border, 'Rate Us'),
      _MenuItem(Icons.mark_email_unread_outlined, 'UnSubscribe'),
    ];

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(14, 10, 14, 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.maybePop(context),
                    icon: Icon(
                      Icons.arrow_back,
                      color: Theme.of(context).iconTheme.color,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    'Menu',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Expanded(
                child: ListView.separated(
                  itemCount: items.length,
                  separatorBuilder: (_, i) => const SizedBox(height: 14),
                  itemBuilder: (context, index) {
                    final item = items[index];
                    return StaggeredFadeSlide(
                      delay: Duration(milliseconds: 80 * index),
                      child: _MenuTile(item: item),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MenuItem {
  _MenuItem(this.icon, this.title);
  final IconData icon;
  final String title;
}

class _MenuTile extends StatelessWidget {
  const _MenuTile({required this.item});

  final _MenuItem item;

  @override
  Widget build(BuildContext context) {
    return TapScale(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.white10),
        ),
        child: Row(
          children: [
            Icon(item.icon, color: Colors.white),
            const SizedBox(width: 14),
            Text(
              item.title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
            const Spacer(),
            const Icon(Icons.chevron_right, color: Colors.white54),
          ],
        ),
      ),
    );
  }
}
