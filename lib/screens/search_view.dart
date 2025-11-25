import 'package:flutter/material.dart';

import '../data/sample_data.dart';
import '../models/media_item.dart';
import '../theme/app_colors.dart';
import '../widgets/grid_poster.dart';
import '../routes/fade_slide_route.dart';
import 'movie_detail_page.dart';
import 'tv_series_detail_page.dart';

class SearchView extends StatefulWidget {
  const SearchView({super.key});

  @override
  State<SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  late List<MediaItem> _items;
  String _query = '';

  @override
  void initState() {
    super.initState();
    _items = [...trendingItems, ...movieItems, ...seriesItems];
  }

  void _openDetail(BuildContext context, MediaItem item) {
    Navigator.push(
      context,
      FadeSlideRoute(
        page: item.isSeries
            ? TvSeriesDetailPage(
                item: item,
                heroTag: 'grid-${item.imageUrl}-${item.title}',
              )
            : MovieDetailPage(
                item: item,
                heroTag: 'grid-${item.imageUrl}-${item.title}',
              ),
      ),
    );
  }

  List<MediaItem> get _filtered {
    if (_query.isEmpty) return _items;
    final q = _query.toLowerCase();
    return _items
        .where(
          (item) =>
              item.title.toLowerCase().contains(q) ||
              item.category.toLowerCase().contains(q),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12, 8, 12, 0),
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
                    'Search',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(
                    color: Theme.of(context).dividerColor.withValues(alpha: 0.2),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(Icons.search,
                        color: Theme.of(context).iconTheme.color),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextField(
                        onChanged: (v) => setState(() => _query = v),
                        decoration: InputDecoration(
                          hintText: 'Search movies or series',
                          border: InputBorder.none,
                          hintStyle: TextStyle(
                            color: AppColors.muted.withValues(alpha: 0.8),
                          ),
                        ),
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                    Icon(Icons.tune, color: Theme.of(context).iconTheme.color),
                  ],
                ),
              ),
              const SizedBox(height: 14),
              Expanded(
                child: GridView.builder(
                  padding: const EdgeInsets.only(bottom: 12),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 14,
                    crossAxisSpacing: 12,
                    childAspectRatio: 0.65,
                  ),
                  itemCount: _filtered.length,
                  itemBuilder: (context, index) {
                    final item = _filtered[index];
                    return GridPoster(
                      item: item,
                      highlight: false,
                      onTap: () => _openDetail(context, item),
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
