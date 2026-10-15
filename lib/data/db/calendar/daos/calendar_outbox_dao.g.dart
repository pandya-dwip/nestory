// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'calendar_outbox_dao.dart';

// ignore_for_file: type=lint
mixin _$CalendarOutboxDaoMixin on DatabaseAccessor<CalendarDatabase> {
  $CalendarOutboxTable get calendarOutbox => attachedDatabase.calendarOutbox;
  CalendarOutboxDaoManager get managers => CalendarOutboxDaoManager(this);
}

class CalendarOutboxDaoManager {
  final _$CalendarOutboxDaoMixin _db;
  CalendarOutboxDaoManager(this._db);
  $$CalendarOutboxTableTableManager get calendarOutbox =>
      $$CalendarOutboxTableTableManager(
        _db.attachedDatabase,
        _db.calendarOutbox,
      );
}
