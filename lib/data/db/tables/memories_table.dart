import 'package:drift/drift.dart';

/// One row per memory. [coverPhotoId] is a soft (non-FK-enforced) pointer
/// into [MemoryPhotos] — kept as a plain column rather than a
/// `.references()` constraint because [MemoryPhotos] itself references
/// back to this table; a hard two-way foreign key would create a
/// dependency cycle that complicates cascade deletes for no real benefit.
/// The app layer keeps it in sync (always the photo at `displayOrder == 0`).
@DataClassName('MemoryEntity')
class Memories extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get title => text().withLength(min: 1, max: 200)();

  TextColumn get description => text().withDefault(const Constant(''))();

  DateTimeColumn get memoryDate => dateTime()();

  IntColumn get coverPhotoId => integer().nullable()();

  BoolColumn get isFavorite => boolean().withDefault(const Constant(false))();

  BoolColumn get isDemo => boolean().withDefault(const Constant(false))();

  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
}
