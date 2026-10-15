// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'calendars_meta_dao.dart';

// ignore_for_file: type=lint
mixin _$CalendarsMetaDaoMixin on DatabaseAccessor<CalendarDatabase> {
  $CalendarAccountsTable get calendarAccounts =>
      attachedDatabase.calendarAccounts;
  $CalendarsMetaTable get calendarsMeta => attachedDatabase.calendarsMeta;
  CalendarsMetaDaoManager get managers => CalendarsMetaDaoManager(this);
}

class CalendarsMetaDaoManager {
  final _$CalendarsMetaDaoMixin _db;
  CalendarsMetaDaoManager(this._db);
  $$CalendarAccountsTableTableManager get calendarAccounts =>
      $$CalendarAccountsTableTableManager(
        _db.attachedDatabase,
        _db.calendarAccounts,
      );
  $$CalendarsMetaTableTableManager get calendarsMeta =>
      $$CalendarsMetaTableTableManager(_db.attachedDatabase, _db.calendarsMeta);
}
