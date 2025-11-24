import 'package:flutter/material.dart';

import '../data/sample_data.dart';
import '../models/media_item.dart';
import '../theme/app_colors.dart';
import '../widgets/category_chips.dart';
import '../widgets/poster_card.dart';
import '../widgets/section_header.dart';
import '../widgets/trending_card.dart';
import 'movie_detail_page.dart';
import 'tv_series_detail_page.dart';
import 'profile_view.dart';
import 'search_view.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  String _activeCategory = 'Action';

  void _openDetail(BuildContext context, MediaItem item) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => item.isSeries
            ? TvSeriesDetailPage(item: item)
            : MovieDetailPage(item: item),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(18, 10, 18, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _HomeHeader(
                      onTapSearch: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const SearchView()),
                      ),
                    ),
                    const SizedBox(height: 22),
                    const SectionHeader(
                      title: 'Categories',
                      actionIcon: Icons.arrow_forward,
                    ),
                    const SizedBox(height: 12),
                    CategoryChips(
                      active: _activeCategory,
                      onSelect: (c) => setState(() => _activeCategory = c),
                    ),
                    const SizedBox(height: 22),
                    const SectionHeader(title: 'Trending Now'),
                    const SizedBox(height: 14),
                    SizedBox(
                      height: 360,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          final item = trendingItems[index];
                          return TrendingCard(
                            item: item,
                            onTap: () => _openDetail(context, item),
                          );
                        },
                        separatorBuilder: (_, i) => const SizedBox(width: 14),
                        itemCount: trendingItems.length,
                      ),
                    ),
                    const SizedBox(height: 22),
                    const SectionHeader(
                      title: 'Movies',
                      actionIcon: Icons.arrow_forward,
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      height: 240,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          final item = movieItems[index];
                          return PosterCard(
                            item: item,
                            onTap: () => _openDetail(context, item),
                          );
                        },
                        separatorBuilder: (_, i) => const SizedBox(width: 16),
                        itemCount: movieItems.length,
                      ),
                    ),
                    const SizedBox(height: 22),
                    const SectionHeader(
                      title: 'Tv series',
                      actionIcon: Icons.arrow_forward,
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      height: 220,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          final item = seriesItems[index];
                          return PosterCard(
                            item: item,
                            badge: item.category,
                            onTap: () => _openDetail(context, item),
                          );
                        },
                        separatorBuilder: (_, i) => const SizedBox(width: 16),
                        itemCount: seriesItems.length,
                      ),
                    ),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HomeHeader extends StatelessWidget {
  const _HomeHeader({required this.onTapSearch});

  final VoidCallback onTapSearch;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        GestureDetector(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const ProfileView()),
          ),
          child: Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: AppColors.surface,
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.outline),
            ),
            child: const CircleAvatar(
              radius: 18,
              backgroundImage: NetworkImage(
                'https://images.unsplash.com/photo-1508214751196-bcfd4ca60f91?auto=format&fit=crop&w=240&q=80',
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Hi Ruhan!',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
            ),
            Text(
              'Enjoy your time with Flicky',
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: AppColors.muted),
            ),
          ],
        ),
        const Spacer(),
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: AppColors.surface,
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.outline),
          ),
          child: GestureDetector(
            onTap: onTapSearch,
            child: const Icon(Icons.search, color: Colors.white),
          ),
        ),
        const SizedBox(width: 10),
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: AppColors.surface,
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.outline),
          ),
          child: const Icon(Icons.notifications_none, color: Colors.white),
        ),
      ],
    );
  }
}
