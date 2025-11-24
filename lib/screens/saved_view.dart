import 'package:flutter/material.dart';

import '../data/sample_data.dart';
import '../models/media_item.dart';
import '../theme/app_colors.dart';
import '../widgets/saved_card.dart';
import 'movie_detail_page.dart';

class SavedView extends StatelessWidget {
  const SavedView({super.key});

  void _openDetail(BuildContext context, MediaItem item) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => MovieDetailPage(item: item)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final savedItems = List<MediaItem>.generate(
      5,
      (index) => movieItems[index % movieItems.length],
    );

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
                child: ListView.separated(
                  itemCount: savedItems.length,
                  separatorBuilder: (_, i) => const SizedBox(height: 14),
                  itemBuilder: (context, index) {
                    final item = savedItems[index];
                    return SavedCard(
                      item: item,
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
