import 'package:flutter/material.dart';

import '../widgets/flicky_nav_bar.dart';
import 'home_view.dart';
import 'menu_view.dart';
import 'saved_view.dart';
import 'search_view.dart';

class FlickyShell extends StatelessWidget {
  const FlickyShell({
    super.key,
    required this.tabIndex,
    required this.onTabChanged,
  });

  final int tabIndex;
  final ValueChanged<int> onTabChanged;

  @override
  Widget build(BuildContext context) {
    final pages = [
      const HomeView(),
      const SearchView(),
      const SavedView(),
      const MenuView(),
    ];

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: IndexedStack(
        index: tabIndex,
        children: pages
            .map((page) => SafeArea(bottom: false, child: page))
            .toList(),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: FlickyNavBar(
          currentIndex: tabIndex,
          onChanged: onTabChanged,
          items: const [
            FlickyNavItem(icon: Icons.home_outlined, label: 'Home'),
            FlickyNavItem(icon: Icons.search, label: 'Search'),
            FlickyNavItem(icon: Icons.bookmark_border, label: 'Saved'),
            FlickyNavItem(icon: Icons.menu_rounded, label: 'Menu'),
          ],
        ),
      ),
    );
  }
}
