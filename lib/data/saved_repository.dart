import 'package:flutter/foundation.dart';

import '../models/media_item.dart';

class SavedRepository {
  static final ValueNotifier<List<MediaItem>> saved =
      ValueNotifier<List<MediaItem>>([]);

  static bool isSaved(MediaItem item) =>
      saved.value.any((m) => m.title == item.title);

  static void toggle(MediaItem item) {
    final list = List<MediaItem>.from(saved.value);
    if (isSaved(item)) {
      list.removeWhere((m) => m.title == item.title);
    } else {
      list.add(item);
    }
    saved.value = list;
  }
}
