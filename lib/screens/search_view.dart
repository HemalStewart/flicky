import 'package:flutter/material.dart';

import '../data/content_api.dart';
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
  List<MediaItem> _items = const [];
  String _query = '';
  bool _loading = false;
  String? _error;
  int _searchToken = 0;

  @override
  void initState() {
    super.initState();
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
                        onChanged: _handleSearch,
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
              if (_loading)
                const LinearProgressIndicator(minHeight: 2),
              if (_error != null) ...[
                const SizedBox(height: 6),
                Text(
                  _error!,
                  style: TextStyle(color: AppColors.muted, fontSize: 12),
                ),
              ],
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

  void _handleSearch(String value) {
    setState(() {
      _query = value;
      _error = null;
    });

    if (value.trim().isEmpty) {
      setState(() {
        _items = const [];
        _loading = false;
      });
      return;
    }

    final token = ++_searchToken;
    setState(() => _loading = true);
    ContentApi()
        .search(value.trim())
        .then((results) {
      if (!mounted || token != _searchToken) return;
      setState(() {
        _items = results;
      });
    }).catchError((_) {
      if (!mounted || token != _searchToken) return;
      setState(() {
        _items = const [];
        _error = 'Search failed. Try again.';
      });
    }).whenComplete(() {
      if (!mounted || token != _searchToken) return;
      setState(() => _loading = false);
    });
  }
}
