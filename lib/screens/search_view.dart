import 'package:flutter/material.dart';

import '../data/sample_data.dart';
import '../models/media_item.dart';
import '../theme/app_colors.dart';
import '../widgets/grid_poster.dart';
import '../widgets/search_bar_field.dart';
import 'movie_detail_page.dart';

class SearchView extends StatelessWidget {
  const SearchView({super.key});

  void _openDetail(BuildContext context, MediaItem item) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => MovieDetailPage(item: item)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final items = [...trendingItems, ...movieItems, ...seriesItems];
    return Scaffold(
      backgroundColor: AppColors.background,
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
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
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
              const SearchBarField(hint: 'Search'),
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
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    final item = items[index % items.length];
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
