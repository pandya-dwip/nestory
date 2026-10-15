import 'package:drift/drift.dart';

import '../calendar_database.dart';
import '../tables/calendar_outbox_table.dart';

part 'calendar_outbox_dao.g.dart';

@DriftAccessor(tables: [CalendarOutbox])
class CalendarOutboxDao extends DatabaseAccessor<CalendarDatabase>
    with _$CalendarOutboxDaoMixin {
  CalendarOutboxDao(super.db);

  Future<List<CalendarOutboxEntity>> getPendingMutations() {
    return (select(
      calendarOutbox,
    )..orderBy([(o) => OrderingTerm.asc(o.createdAt)])).get();
  }

  Future<CalendarOutboxEntity?> getByMutationId(String clientMutationId) {
    return (select(calendarOutbox)
          ..where((o) => o.clientMutationId.equals(clientMutationId)))
        .getSingleOrNull();
  }

  Future<int> enqueue(CalendarOutboxCompanion entry) {
    return into(calendarOutbox).insert(entry);
  }

  Future<int> remove(int id) {
    return (delete(calendarOutbox)..where((o) => o.id.equals(id))).go();
  }

  Future<int> removeByMutationId(String clientMutationId) {
    return (delete(
      calendarOutbox,
    )..where((o) => o.clientMutationId.equals(clientMutationId))).go();
  }

  Future<int> removeByGoogleEventId(String googleEventId) {
    return (delete(
      calendarOutbox,
    )..where((o) => o.googleEventId.equals(googleEventId))).go();
  }

  Future<void> recordFailure(int id, String error) async {
    final entry = await (select(
      calendarOutbox,
    )..where((o) => o.id.equals(id))).getSingleOrNull();
    final currentRetry = entry?.retryCount ?? 0;
    await (update(calendarOutbox)..where((o) => o.id.equals(id))).write(
      CalendarOutboxCompanion(
        retryCount: Value(currentRetry + 1),
        lastError: Value(error),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  Future<int> countPending() async {
    final count = countAll();
    final query = selectOnly(calendarOutbox)..addColumns([count]);
    final result = await query.map((row) => row.read(count)).getSingle();
    return result ?? 0;
  }

  Future<int> clearAll() {
    return delete(calendarOutbox).go();
  }
}
