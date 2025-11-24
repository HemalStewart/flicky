import 'package:flutter/material.dart';

import '../data/saved_repository.dart';
import '../models/media_item.dart';
import '../theme/app_colors.dart';
import '../widgets/saved_card.dart';
import 'movie_detail_page.dart';
import 'tv_series_detail_page.dart';
import '../routes/fade_slide_route.dart';

class SavedView extends StatelessWidget {
  const SavedView({super.key});

  void _openDetail(BuildContext context, MediaItem item) {
    Navigator.push(
      context,
      FadeSlideRoute(
        page: item.isSeries
            ? TvSeriesDetailPage(
                item: item,
                heroTag: 'saved-${item.imageUrl}-${item.title}',
              )
            : MovieDetailPage(
                item: item,
                heroTag: 'saved-${item.imageUrl}-${item.title}',
              ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final savedItems = SavedRepository.saved;
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(14, 12, 14, 0),
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
                    'My Saved',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Expanded(
                child: ValueListenableBuilder<List<MediaItem>>(
                  valueListenable: savedItems,
                  builder: (context, items, _) {
                    if (items.isEmpty) {
                      return Center(
                        child: Text(
                          'No saved items yet',
                          style: TextStyle(color: AppColors.muted),
                        ),
                      );
                    }
                    return ListView.separated(
                      itemCount: items.length,
                      separatorBuilder: (_, i) => const SizedBox(height: 14),
                      itemBuilder: (context, index) {
                        final item = items[index];
                        return SavedCard(
                          item: item,
                          onTap: () => _openDetail(context, item),
                        );
                      },
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
