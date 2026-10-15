import 'package:drift/drift.dart';

import '../calendar_database.dart';
import '../tables/sync_conflicts_table.dart';

part 'sync_conflicts_dao.g.dart';

@DriftAccessor(tables: [SyncConflicts])
class SyncConflictsDao extends DatabaseAccessor<CalendarDatabase>
    with _$SyncConflictsDaoMixin {
  SyncConflictsDao(super.db);

  Future<List<SyncConflictEntity>> getAllConflicts() {
    return (select(
      syncConflicts,
    )..orderBy([(c) => OrderingTerm.desc(c.resolvedAt)])).get();
  }

  Future<List<SyncConflictEntity>> getActiveConflicts() {
    return (select(syncConflicts)
          ..where((c) => c.isDismissed.equals(false))
          ..orderBy([(c) => OrderingTerm.desc(c.resolvedAt)]))
        .get();
  }

  Future<int> insertConflict(SyncConflictsCompanion entry) {
    return into(syncConflicts).insert(entry);
  }

  Future<void> dismissConflict(int id) {
    return (update(syncConflicts)..where((c) => c.id.equals(id))).write(
      const SyncConflictsCompanion(isDismissed: Value(true)),
    );
  }

  Future<int> clearAll() {
    return delete(syncConflicts).go();
  }
}
