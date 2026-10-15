import 'package:drift/drift.dart';

import '../calendar_database.dart';
import '../tables/calendar_accounts_table.dart';

part 'calendar_accounts_dao.g.dart';

@DriftAccessor(tables: [CalendarAccounts])
class CalendarAccountsDao extends DatabaseAccessor<CalendarDatabase>
    with _$CalendarAccountsDaoMixin {
  CalendarAccountsDao(super.db);

  Future<CalendarAccountEntity?> getPrimaryAccount() {
    return (select(calendarAccounts)..limit(1)).getSingleOrNull();
  }

  Future<void> upsertAccount({
    required String email,
    required String displayName,
    String? photoUrl,
  }) async {
    final existing = await (select(
      calendarAccounts,
    )..where((a) => a.email.equals(email))).getSingleOrNull();
    if (existing == null) {
      await into(calendarAccounts).insert(
        CalendarAccountsCompanion.insert(
          email: email,
          displayName: Value(displayName),
          photoUrl: Value(photoUrl),
        ),
      );
    } else {
      await (update(
        calendarAccounts,
      )..where((a) => a.email.equals(email))).write(
        CalendarAccountsCompanion(
          displayName: Value(displayName),
          photoUrl: Value(photoUrl),
          needsReauth: const Value(false),
          updatedAt: Value(DateTime.now()),
        ),
      );
    }
  }

  Future<void> setNeedsReauth(String email, bool needsReauth) {
    return (update(
      calendarAccounts,
    )..where((a) => a.email.equals(email))).write(
      CalendarAccountsCompanion(
        needsReauth: Value(needsReauth),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  Future<void> updateLastSyncTime(String email, DateTime time) {
    return (update(
      calendarAccounts,
    )..where((a) => a.email.equals(email))).write(
      CalendarAccountsCompanion(
        lastSyncTime: Value(time),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  Future<int> deleteAccount(String email) {
    return (delete(calendarAccounts)..where((a) => a.email.equals(email))).go();
  }

  Future<int> deleteAllAccounts() {
    return delete(calendarAccounts).go();
  }
}
