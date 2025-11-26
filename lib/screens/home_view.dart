import 'package:flutter/material.dart';

import '../data/content_api.dart';
import '../models/media_item.dart';
import '../theme/app_colors.dart';
import '../widgets/category_chips.dart';
import '../widgets/poster_card.dart';
import '../widgets/section_header.dart';
import '../widgets/trending_card.dart';
import '../routes/fade_slide_route.dart';
import '../widgets/staggered_fade_slide.dart';
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
  bool _loading = true;
  String? _error;
  List<MediaItem> _trending = const [];
  List<MediaItem> _movies = const [];
  List<MediaItem> _series = const [];

  @override
  void initState() {
    super.initState();
    _loadHome();
  }

  Future<void> _loadHome() async {
    try {
      final payload = await ContentApi().fetchHome();
      setState(() {
        _trending = payload.trending;
        _movies = payload.movies;
        _series = payload.series;
        _error = null;
      });
    } catch (e) {
      setState(() => _error = 'Could not load latest content.');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  void _openDetail(BuildContext context, MediaItem item, String heroTag) {
    Navigator.push(
      context,
      FadeSlideRoute(
        page: item.isSeries
            ? TvSeriesDetailPage(item: item, heroTag: heroTag)
            : MovieDetailPage(item: item, heroTag: heroTag),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(18, 10, 18, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (_loading)
                      const LinearProgressIndicator(minHeight: 3),
                    if (_error != null) ...[
                      const SizedBox(height: 8),
                      Text(
                        _error!,
                        style: TextStyle(color: AppColors.muted, fontSize: 12),
                      ),
                    ],
                    StaggeredFadeSlide(
                      delay: const Duration(milliseconds: 80),
                      child: _HomeHeader(
                        onTapSearch: () => Navigator.push(
                          context,
                          FadeSlideRoute(page: const SearchView()),
                        ),
                      ),
                    ),
                    const SizedBox(height: 22),
                    StaggeredFadeSlide(
                      delay: const Duration(milliseconds: 140),
                      child: const SectionHeader(
                        title: 'Categories',
                        actionIcon: Icons.arrow_forward,
                      ),
                    ),
                    const SizedBox(height: 12),
                    StaggeredFadeSlide(
                      delay: const Duration(milliseconds: 200),
                      child: CategoryChips(
                        active: _activeCategory,
                        onSelect: (c) => setState(() => _activeCategory = c),
                      ),
                    ),
                    const SizedBox(height: 22),
                    StaggeredFadeSlide(
                      delay: const Duration(milliseconds: 260),
                      child: const SectionHeader(title: 'Trending Now'),
                    ),
                    const SizedBox(height: 14),
                    StaggeredFadeSlide(
                          delay: const Duration(milliseconds: 320),
                          child: SizedBox(
                            height: 360,
                            child: ListView.separated(
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (context, index) {
                                final item = _trending[index];
                                return TrendingCard(
                                  item: item,
                                  onTap: () => _openDetail(
                                    context,
                                    item,
                                    'trending-${item.imageUrl}-${item.title}',
                                  ),
                                );
                              },
                              separatorBuilder: (_, i) => const SizedBox(width: 14),
                              itemCount: _trending.length,
                            ),
                          ),
                        ),
                    const SizedBox(height: 22),
                    StaggeredFadeSlide(
                      delay: const Duration(milliseconds: 380),
                      child: const SectionHeader(
                        title: 'Movies',
                        actionIcon: Icons.arrow_forward,
                      ),
                    ),
                    const SizedBox(height: 12),
                    StaggeredFadeSlide(
                          delay: const Duration(milliseconds: 440),
                          child: SizedBox(
                            height: 240,
                            child: ListView.separated(
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (context, index) {
                                final item = _movies[index];
                                return PosterCard(
                                  item: item,
                                  onTap: () => _openDetail(
                                    context,
                                    item,
                                    'poster-${item.imageUrl}-${item.title}',
                                  ),
                                );
                              },
                              separatorBuilder: (_, i) => const SizedBox(width: 16),
                              itemCount: _movies.length,
                            ),
                          ),
                        ),
                    const SizedBox(height: 22),
                    StaggeredFadeSlide(
                      delay: const Duration(milliseconds: 500),
                      child: const SectionHeader(
                        title: 'Tv series',
                        actionIcon: Icons.arrow_forward,
                      ),
                    ),
                    const SizedBox(height: 12),
                    StaggeredFadeSlide(
                          delay: const Duration(milliseconds: 560),
                          child: SizedBox(
                            height: 220,
                            child: ListView.separated(
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (context, index) {
                                final item = _series[index];
                                return PosterCard(
                                  item: item,
                                  badge: item.category,
                                  onTap: () => _openDetail(
                                    context,
                                    item,
                                    'poster-${item.imageUrl}-${item.title}',
                                  ),
                                );
                              },
                              separatorBuilder: (_, i) => const SizedBox(width: 16),
                              itemCount: _series.length,
                            ),
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
            FadeSlideRoute(page: const ProfileView()),
          ),
          child: const Hero(
            tag: 'flicky-logo',
            child: Image(
              image: AssetImage('assets/images/logo.png'),
              width: 48,
              height: 48,
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
            color: Theme.of(context).cardColor,
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
            color: Theme.of(context).cardColor,
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.outline),
          ),
          child: const Icon(Icons.notifications_none, color: Colors.white),
        ),
      ],
    );
  }
}
