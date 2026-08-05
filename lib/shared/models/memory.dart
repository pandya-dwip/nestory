import 'package:flutter/foundation.dart';

/// A single memory, backed 1:1 by a `memories` row (+ its `memory_photos`).
@immutable
class Memory {
  const Memory({
    required this.id,
    required this.title,
    required this.description,
    required this.date,
    required this.photoUrls,
    required this.tags,
    this.isFavorite = false,
    this.isDemo = false,
  });

  final int id;
  final String title;
  final String description;
  final DateTime date;

  /// Local file paths (or, for generated demo placeholders, also local
  /// files) — never a reference to the original picked/camera path.
  final List<String> photoUrls;
  final List<String> tags;
  final bool isFavorite;
  final bool isDemo;

  String get coverUrl => photoUrls.first;
  int get photoCount => photoUrls.length;

  Memory copyWith({
    int? id,
    String? title,
    String? description,
    DateTime? date,
    List<String>? photoUrls,
    List<String>? tags,
    bool? isFavorite,
    bool? isDemo,
  }) {
    return Memory(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      date: date ?? this.date,
      photoUrls: photoUrls ?? this.photoUrls,
      tags: tags ?? this.tags,
      isFavorite: isFavorite ?? this.isFavorite,
      isDemo: isDemo ?? this.isDemo,
    );
  }

  bool matchesQuery(String query) {
    final q = query.toLowerCase();
    if (q.isEmpty) return true;
    return title.toLowerCase().contains(q) ||
        description.toLowerCase().contains(q) ||
        tags.any((tag) => tag.toLowerCase().contains(q));
  }
}
