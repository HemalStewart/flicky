import 'package:flutter/material.dart';

import '../widgets/flicky_nav_bar.dart';
import 'home_view.dart';
import 'menu_view.dart';
import 'saved_view.dart';
import 'search_view.dart';

class FlickyShell extends StatefulWidget {
  const FlickyShell({super.key, this.initialIndex = 0});

  final int initialIndex;

  @override
  State<FlickyShell> createState() => _FlickyShellState();
}

class _FlickyShellState extends State<FlickyShell> {
  late int tabIndex;

  @override
  void initState() {
    super.initState();
    tabIndex = widget.initialIndex;
  }

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
          onChanged: (value) => setState(() => tabIndex = value),
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
