// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'calendar_accounts_dao.dart';

// ignore_for_file: type=lint
mixin _$CalendarAccountsDaoMixin on DatabaseAccessor<CalendarDatabase> {
  $CalendarAccountsTable get calendarAccounts =>
      attachedDatabase.calendarAccounts;
  CalendarAccountsDaoManager get managers => CalendarAccountsDaoManager(this);
}

class CalendarAccountsDaoManager {
  final _$CalendarAccountsDaoMixin _db;
  CalendarAccountsDaoManager(this._db);
  $$CalendarAccountsTableTableManager get calendarAccounts =>
      $$CalendarAccountsTableTableManager(
        _db.attachedDatabase,
        _db.calendarAccounts,
      );
}
