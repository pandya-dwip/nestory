import 'package:drift/drift.dart';

import 'memories_table.dart';

/// Photos belonging to a memory (max 5, enforced in the repository layer).
/// [localPath] is the full-quality copy in app storage; [thumbnailPath] is
/// a pre-generated small copy for fast list/grid rendering. Both are file
/// paths only — never image bytes.
@DataClassName('MemoryPhoto')
class MemoryPhotos extends Table {
  IntColumn get id => integer().autoIncrement()();

  IntColumn get memoryId =>
      integer().references(Memories, #id, onDelete: KeyAction.cascade)();

  TextColumn get localPath => text()();

  TextColumn get thumbnailPath => text()();

  IntColumn get displayOrder => integer().withDefault(const Constant(0))();

  /// How this photo should be fitted when displayed: `fill`, `fit`,
  /// `landscapePriority`, or `portraitPriority` (see `PhotoDisplayMode`).
  /// A per-photo choice, not a global one.
  TextColumn get displayMode => text().withDefault(const Constant('fill'))();

  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}
