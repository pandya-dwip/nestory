// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'calendar_database.dart';

// ignore_for_file: type=lint
class $CalendarAccountsTable extends CalendarAccounts
    with TableInfo<$CalendarAccountsTable, CalendarAccountEntity> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CalendarAccountsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _emailMeta = const VerificationMeta('email');
  @override
  late final GeneratedColumn<String> email = GeneratedColumn<String>(
    'email',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _displayNameMeta = const VerificationMeta(
    'displayName',
  );
  @override
  late final GeneratedColumn<String> displayName = GeneratedColumn<String>(
    'display_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _photoUrlMeta = const VerificationMeta(
    'photoUrl',
  );
  @override
  late final GeneratedColumn<String> photoUrl = GeneratedColumn<String>(
    'photo_url',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _needsReauthMeta = const VerificationMeta(
    'needsReauth',
  );
  @override
  late final GeneratedColumn<bool> needsReauth = GeneratedColumn<bool>(
    'needs_reauth',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("needs_reauth" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _lastSyncTimeMeta = const VerificationMeta(
    'lastSyncTime',
  );
  @override
  late final GeneratedColumn<DateTime> lastSyncTime = GeneratedColumn<DateTime>(
    'last_sync_time',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    email,
    displayName,
    photoUrl,
    needsReauth,
    lastSyncTime,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'calendar_accounts';
  @override
  VerificationContext validateIntegrity(
    Insertable<CalendarAccountEntity> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('email')) {
      context.handle(
        _emailMeta,
        email.isAcceptableOrUnknown(data['email']!, _emailMeta),
      );
    } else if (isInserting) {
      context.missing(_emailMeta);
    }
    if (data.containsKey('display_name')) {
      context.handle(
        _displayNameMeta,
        displayName.isAcceptableOrUnknown(
          data['display_name']!,
          _displayNameMeta,
        ),
      );
    }
    if (data.containsKey('photo_url')) {
      context.handle(
        _photoUrlMeta,
        photoUrl.isAcceptableOrUnknown(data['photo_url']!, _photoUrlMeta),
      );
    }
    if (data.containsKey('needs_reauth')) {
      context.handle(
        _needsReauthMeta,
        needsReauth.isAcceptableOrUnknown(
          data['needs_reauth']!,
          _needsReauthMeta,
        ),
      );
    }
    if (data.containsKey('last_sync_time')) {
      context.handle(
        _lastSyncTimeMeta,
        lastSyncTime.isAcceptableOrUnknown(
          data['last_sync_time']!,
          _lastSyncTimeMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CalendarAccountEntity map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CalendarAccountEntity(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      email: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}email'],
      )!,
      displayName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}display_name'],
      )!,
      photoUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}photo_url'],
      ),
      needsReauth: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}needs_reauth'],
      )!,
      lastSyncTime: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_sync_time'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $CalendarAccountsTable createAlias(String alias) {
    return $CalendarAccountsTable(attachedDatabase, alias);
  }
}

class CalendarAccountEntity extends DataClass
    implements Insertable<CalendarAccountEntity> {
  final int id;
  final String email;
  final String displayName;
  final String? photoUrl;
  final bool needsReauth;
  final DateTime? lastSyncTime;
  final DateTime createdAt;
  final DateTime updatedAt;
  const CalendarAccountEntity({
    required this.id,
    required this.email,
    required this.displayName,
    this.photoUrl,
    required this.needsReauth,
    this.lastSyncTime,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['email'] = Variable<String>(email);
    map['display_name'] = Variable<String>(displayName);
    if (!nullToAbsent || photoUrl != null) {
      map['photo_url'] = Variable<String>(photoUrl);
    }
    map['needs_reauth'] = Variable<bool>(needsReauth);
    if (!nullToAbsent || lastSyncTime != null) {
      map['last_sync_time'] = Variable<DateTime>(lastSyncTime);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  CalendarAccountsCompanion toCompanion(bool nullToAbsent) {
    return CalendarAccountsCompanion(
      id: Value(id),
      email: Value(email),
      displayName: Value(displayName),
      photoUrl: photoUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(photoUrl),
      needsReauth: Value(needsReauth),
      lastSyncTime: lastSyncTime == null && nullToAbsent
          ? const Value.absent()
          : Value(lastSyncTime),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory CalendarAccountEntity.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CalendarAccountEntity(
      id: serializer.fromJson<int>(json['id']),
      email: serializer.fromJson<String>(json['email']),
      displayName: serializer.fromJson<String>(json['displayName']),
      photoUrl: serializer.fromJson<String?>(json['photoUrl']),
      needsReauth: serializer.fromJson<bool>(json['needsReauth']),
      lastSyncTime: serializer.fromJson<DateTime?>(json['lastSyncTime']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'email': serializer.toJson<String>(email),
      'displayName': serializer.toJson<String>(displayName),
      'photoUrl': serializer.toJson<String?>(photoUrl),
      'needsReauth': serializer.toJson<bool>(needsReauth),
      'lastSyncTime': serializer.toJson<DateTime?>(lastSyncTime),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  CalendarAccountEntity copyWith({
    int? id,
    String? email,
    String? displayName,
    Value<String?> photoUrl = const Value.absent(),
    bool? needsReauth,
    Value<DateTime?> lastSyncTime = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => CalendarAccountEntity(
    id: id ?? this.id,
    email: email ?? this.email,
    displayName: displayName ?? this.displayName,
    photoUrl: photoUrl.present ? photoUrl.value : this.photoUrl,
    needsReauth: needsReauth ?? this.needsReauth,
    lastSyncTime: lastSyncTime.present ? lastSyncTime.value : this.lastSyncTime,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  CalendarAccountEntity copyWithCompanion(CalendarAccountsCompanion data) {
    return CalendarAccountEntity(
      id: data.id.present ? data.id.value : this.id,
      email: data.email.present ? data.email.value : this.email,
      displayName: data.displayName.present
          ? data.displayName.value
          : this.displayName,
      photoUrl: data.photoUrl.present ? data.photoUrl.value : this.photoUrl,
      needsReauth: data.needsReauth.present
          ? data.needsReauth.value
          : this.needsReauth,
      lastSyncTime: data.lastSyncTime.present
          ? data.lastSyncTime.value
          : this.lastSyncTime,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CalendarAccountEntity(')
          ..write('id: $id, ')
          ..write('email: $email, ')
          ..write('displayName: $displayName, ')
          ..write('photoUrl: $photoUrl, ')
          ..write('needsReauth: $needsReauth, ')
          ..write('lastSyncTime: $lastSyncTime, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    email,
    displayName,
    photoUrl,
    needsReauth,
    lastSyncTime,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CalendarAccountEntity &&
          other.id == this.id &&
          other.email == this.email &&
          other.displayName == this.displayName &&
          other.photoUrl == this.photoUrl &&
          other.needsReauth == this.needsReauth &&
          other.lastSyncTime == this.lastSyncTime &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class CalendarAccountsCompanion extends UpdateCompanion<CalendarAccountEntity> {
  final Value<int> id;
  final Value<String> email;
  final Value<String> displayName;
  final Value<String?> photoUrl;
  final Value<bool> needsReauth;
  final Value<DateTime?> lastSyncTime;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const CalendarAccountsCompanion({
    this.id = const Value.absent(),
    this.email = const Value.absent(),
    this.displayName = const Value.absent(),
    this.photoUrl = const Value.absent(),
    this.needsReauth = const Value.absent(),
    this.lastSyncTime = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  CalendarAccountsCompanion.insert({
    this.id = const Value.absent(),
    required String email,
    this.displayName = const Value.absent(),
    this.photoUrl = const Value.absent(),
    this.needsReauth = const Value.absent(),
    this.lastSyncTime = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  }) : email = Value(email);
  static Insertable<CalendarAccountEntity> custom({
    Expression<int>? id,
    Expression<String>? email,
    Expression<String>? displayName,
    Expression<String>? photoUrl,
    Expression<bool>? needsReauth,
    Expression<DateTime>? lastSyncTime,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (email != null) 'email': email,
      if (displayName != null) 'display_name': displayName,
      if (photoUrl != null) 'photo_url': photoUrl,
      if (needsReauth != null) 'needs_reauth': needsReauth,
      if (lastSyncTime != null) 'last_sync_time': lastSyncTime,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  CalendarAccountsCompanion copyWith({
    Value<int>? id,
    Value<String>? email,
    Value<String>? displayName,
    Value<String?>? photoUrl,
    Value<bool>? needsReauth,
    Value<DateTime?>? lastSyncTime,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
  }) {
    return CalendarAccountsCompanion(
      id: id ?? this.id,
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
      photoUrl: photoUrl ?? this.photoUrl,
      needsReauth: needsReauth ?? this.needsReauth,
      lastSyncTime: lastSyncTime ?? this.lastSyncTime,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (email.present) {
      map['email'] = Variable<String>(email.value);
    }
    if (displayName.present) {
      map['display_name'] = Variable<String>(displayName.value);
    }
    if (photoUrl.present) {
      map['photo_url'] = Variable<String>(photoUrl.value);
    }
    if (needsReauth.present) {
      map['needs_reauth'] = Variable<bool>(needsReauth.value);
    }
    if (lastSyncTime.present) {
      map['last_sync_time'] = Variable<DateTime>(lastSyncTime.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CalendarAccountsCompanion(')
          ..write('id: $id, ')
          ..write('email: $email, ')
          ..write('displayName: $displayName, ')
          ..write('photoUrl: $photoUrl, ')
          ..write('needsReauth: $needsReauth, ')
          ..write('lastSyncTime: $lastSyncTime, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $CalendarsMetaTable extends CalendarsMeta
    with TableInfo<$CalendarsMetaTable, CalendarMetaEntity> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CalendarsMetaTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _accountEmailMeta = const VerificationMeta(
    'accountEmail',
  );
  @override
  late final GeneratedColumn<String> accountEmail = GeneratedColumn<String>(
    'account_email',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES calendar_accounts (email) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _googleCalendarIdMeta = const VerificationMeta(
    'googleCalendarId',
  );
  @override
  late final GeneratedColumn<String> googleCalendarId = GeneratedColumn<String>(
    'google_calendar_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _summaryMeta = const VerificationMeta(
    'summary',
  );
  @override
  late final GeneratedColumn<String> summary = GeneratedColumn<String>(
    'summary',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _colorHexMeta = const VerificationMeta(
    'colorHex',
  );
  @override
  late final GeneratedColumn<String> colorHex = GeneratedColumn<String>(
    'color_hex',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isPrimaryMeta = const VerificationMeta(
    'isPrimary',
  );
  @override
  late final GeneratedColumn<bool> isPrimary = GeneratedColumn<bool>(
    'is_primary',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_primary" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _isSelectedMeta = const VerificationMeta(
    'isSelected',
  );
  @override
  late final GeneratedColumn<bool> isSelected = GeneratedColumn<bool>(
    'is_selected',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_selected" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _syncTokenMeta = const VerificationMeta(
    'syncToken',
  );
  @override
  late final GeneratedColumn<String> syncToken = GeneratedColumn<String>(
    'sync_token',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _accessRoleMeta = const VerificationMeta(
    'accessRole',
  );
  @override
  late final GeneratedColumn<String> accessRole = GeneratedColumn<String>(
    'access_role',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('owner'),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    accountEmail,
    googleCalendarId,
    summary,
    description,
    colorHex,
    isPrimary,
    isSelected,
    syncToken,
    accessRole,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'calendars_meta';
  @override
  VerificationContext validateIntegrity(
    Insertable<CalendarMetaEntity> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('account_email')) {
      context.handle(
        _accountEmailMeta,
        accountEmail.isAcceptableOrUnknown(
          data['account_email']!,
          _accountEmailMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_accountEmailMeta);
    }
    if (data.containsKey('google_calendar_id')) {
      context.handle(
        _googleCalendarIdMeta,
        googleCalendarId.isAcceptableOrUnknown(
          data['google_calendar_id']!,
          _googleCalendarIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_googleCalendarIdMeta);
    }
    if (data.containsKey('summary')) {
      context.handle(
        _summaryMeta,
        summary.isAcceptableOrUnknown(data['summary']!, _summaryMeta),
      );
    } else if (isInserting) {
      context.missing(_summaryMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    }
    if (data.containsKey('color_hex')) {
      context.handle(
        _colorHexMeta,
        colorHex.isAcceptableOrUnknown(data['color_hex']!, _colorHexMeta),
      );
    }
    if (data.containsKey('is_primary')) {
      context.handle(
        _isPrimaryMeta,
        isPrimary.isAcceptableOrUnknown(data['is_primary']!, _isPrimaryMeta),
      );
    }
    if (data.containsKey('is_selected')) {
      context.handle(
        _isSelectedMeta,
        isSelected.isAcceptableOrUnknown(data['is_selected']!, _isSelectedMeta),
      );
    }
    if (data.containsKey('sync_token')) {
      context.handle(
        _syncTokenMeta,
        syncToken.isAcceptableOrUnknown(data['sync_token']!, _syncTokenMeta),
      );
    }
    if (data.containsKey('access_role')) {
      context.handle(
        _accessRoleMeta,
        accessRole.isAcceptableOrUnknown(data['access_role']!, _accessRoleMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {accountEmail, googleCalendarId},
  ];
  @override
  CalendarMetaEntity map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CalendarMetaEntity(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      accountEmail: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}account_email'],
      )!,
      googleCalendarId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}google_calendar_id'],
      )!,
      summary: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}summary'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      )!,
      colorHex: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}color_hex'],
      ),
      isPrimary: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_primary'],
      )!,
      isSelected: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_selected'],
      )!,
      syncToken: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sync_token'],
      ),
      accessRole: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}access_role'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $CalendarsMetaTable createAlias(String alias) {
    return $CalendarsMetaTable(attachedDatabase, alias);
  }
}

class CalendarMetaEntity extends DataClass
    implements Insertable<CalendarMetaEntity> {
  final int id;
  final String accountEmail;
  final String googleCalendarId;
  final String summary;
  final String description;
  final String? colorHex;
  final bool isPrimary;
  final bool isSelected;
  final String? syncToken;
  final String accessRole;
  final DateTime createdAt;
  final DateTime updatedAt;
  const CalendarMetaEntity({
    required this.id,
    required this.accountEmail,
    required this.googleCalendarId,
    required this.summary,
    required this.description,
    this.colorHex,
    required this.isPrimary,
    required this.isSelected,
    this.syncToken,
    required this.accessRole,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['account_email'] = Variable<String>(accountEmail);
    map['google_calendar_id'] = Variable<String>(googleCalendarId);
    map['summary'] = Variable<String>(summary);
    map['description'] = Variable<String>(description);
    if (!nullToAbsent || colorHex != null) {
      map['color_hex'] = Variable<String>(colorHex);
    }
    map['is_primary'] = Variable<bool>(isPrimary);
    map['is_selected'] = Variable<bool>(isSelected);
    if (!nullToAbsent || syncToken != null) {
      map['sync_token'] = Variable<String>(syncToken);
    }
    map['access_role'] = Variable<String>(accessRole);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  CalendarsMetaCompanion toCompanion(bool nullToAbsent) {
    return CalendarsMetaCompanion(
      id: Value(id),
      accountEmail: Value(accountEmail),
      googleCalendarId: Value(googleCalendarId),
      summary: Value(summary),
      description: Value(description),
      colorHex: colorHex == null && nullToAbsent
          ? const Value.absent()
          : Value(colorHex),
      isPrimary: Value(isPrimary),
      isSelected: Value(isSelected),
      syncToken: syncToken == null && nullToAbsent
          ? const Value.absent()
          : Value(syncToken),
      accessRole: Value(accessRole),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory CalendarMetaEntity.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CalendarMetaEntity(
      id: serializer.fromJson<int>(json['id']),
      accountEmail: serializer.fromJson<String>(json['accountEmail']),
      googleCalendarId: serializer.fromJson<String>(json['googleCalendarId']),
      summary: serializer.fromJson<String>(json['summary']),
      description: serializer.fromJson<String>(json['description']),
      colorHex: serializer.fromJson<String?>(json['colorHex']),
      isPrimary: serializer.fromJson<bool>(json['isPrimary']),
      isSelected: serializer.fromJson<bool>(json['isSelected']),
      syncToken: serializer.fromJson<String?>(json['syncToken']),
      accessRole: serializer.fromJson<String>(json['accessRole']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'accountEmail': serializer.toJson<String>(accountEmail),
      'googleCalendarId': serializer.toJson<String>(googleCalendarId),
      'summary': serializer.toJson<String>(summary),
      'description': serializer.toJson<String>(description),
      'colorHex': serializer.toJson<String?>(colorHex),
      'isPrimary': serializer.toJson<bool>(isPrimary),
      'isSelected': serializer.toJson<bool>(isSelected),
      'syncToken': serializer.toJson<String?>(syncToken),
      'accessRole': serializer.toJson<String>(accessRole),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  CalendarMetaEntity copyWith({
    int? id,
    String? accountEmail,
    String? googleCalendarId,
    String? summary,
    String? description,
    Value<String?> colorHex = const Value.absent(),
    bool? isPrimary,
    bool? isSelected,
    Value<String?> syncToken = const Value.absent(),
    String? accessRole,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => CalendarMetaEntity(
    id: id ?? this.id,
    accountEmail: accountEmail ?? this.accountEmail,
    googleCalendarId: googleCalendarId ?? this.googleCalendarId,
    summary: summary ?? this.summary,
    description: description ?? this.description,
    colorHex: colorHex.present ? colorHex.value : this.colorHex,
    isPrimary: isPrimary ?? this.isPrimary,
    isSelected: isSelected ?? this.isSelected,
    syncToken: syncToken.present ? syncToken.value : this.syncToken,
    accessRole: accessRole ?? this.accessRole,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  CalendarMetaEntity copyWithCompanion(CalendarsMetaCompanion data) {
    return CalendarMetaEntity(
      id: data.id.present ? data.id.value : this.id,
      accountEmail: data.accountEmail.present
          ? data.accountEmail.value
          : this.accountEmail,
      googleCalendarId: data.googleCalendarId.present
          ? data.googleCalendarId.value
          : this.googleCalendarId,
      summary: data.summary.present ? data.summary.value : this.summary,
      description: data.description.present
          ? data.description.value
          : this.description,
      colorHex: data.colorHex.present ? data.colorHex.value : this.colorHex,
      isPrimary: data.isPrimary.present ? data.isPrimary.value : this.isPrimary,
      isSelected: data.isSelected.present
          ? data.isSelected.value
          : this.isSelected,
      syncToken: data.syncToken.present ? data.syncToken.value : this.syncToken,
      accessRole: data.accessRole.present
          ? data.accessRole.value
          : this.accessRole,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CalendarMetaEntity(')
          ..write('id: $id, ')
          ..write('accountEmail: $accountEmail, ')
          ..write('googleCalendarId: $googleCalendarId, ')
          ..write('summary: $summary, ')
          ..write('description: $description, ')
          ..write('colorHex: $colorHex, ')
          ..write('isPrimary: $isPrimary, ')
          ..write('isSelected: $isSelected, ')
          ..write('syncToken: $syncToken, ')
          ..write('accessRole: $accessRole, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    accountEmail,
    googleCalendarId,
    summary,
    description,
    colorHex,
    isPrimary,
    isSelected,
    syncToken,
    accessRole,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CalendarMetaEntity &&
          other.id == this.id &&
          other.accountEmail == this.accountEmail &&
          other.googleCalendarId == this.googleCalendarId &&
          other.summary == this.summary &&
          other.description == this.description &&
          other.colorHex == this.colorHex &&
          other.isPrimary == this.isPrimary &&
          other.isSelected == this.isSelected &&
          other.syncToken == this.syncToken &&
          other.accessRole == this.accessRole &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class CalendarsMetaCompanion extends UpdateCompanion<CalendarMetaEntity> {
  final Value<int> id;
  final Value<String> accountEmail;
  final Value<String> googleCalendarId;
  final Value<String> summary;
  final Value<String> description;
  final Value<String?> colorHex;
  final Value<bool> isPrimary;
  final Value<bool> isSelected;
  final Value<String?> syncToken;
  final Value<String> accessRole;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const CalendarsMetaCompanion({
    this.id = const Value.absent(),
    this.accountEmail = const Value.absent(),
    this.googleCalendarId = const Value.absent(),
    this.summary = const Value.absent(),
    this.description = const Value.absent(),
    this.colorHex = const Value.absent(),
    this.isPrimary = const Value.absent(),
    this.isSelected = const Value.absent(),
    this.syncToken = const Value.absent(),
    this.accessRole = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  CalendarsMetaCompanion.insert({
    this.id = const Value.absent(),
    required String accountEmail,
    required String googleCalendarId,
    required String summary,
    this.description = const Value.absent(),
    this.colorHex = const Value.absent(),
    this.isPrimary = const Value.absent(),
    this.isSelected = const Value.absent(),
    this.syncToken = const Value.absent(),
    this.accessRole = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  }) : accountEmail = Value(accountEmail),
       googleCalendarId = Value(googleCalendarId),
       summary = Value(summary);
  static Insertable<CalendarMetaEntity> custom({
    Expression<int>? id,
    Expression<String>? accountEmail,
    Expression<String>? googleCalendarId,
    Expression<String>? summary,
    Expression<String>? description,
    Expression<String>? colorHex,
    Expression<bool>? isPrimary,
    Expression<bool>? isSelected,
    Expression<String>? syncToken,
    Expression<String>? accessRole,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (accountEmail != null) 'account_email': accountEmail,
      if (googleCalendarId != null) 'google_calendar_id': googleCalendarId,
      if (summary != null) 'summary': summary,
      if (description != null) 'description': description,
      if (colorHex != null) 'color_hex': colorHex,
      if (isPrimary != null) 'is_primary': isPrimary,
      if (isSelected != null) 'is_selected': isSelected,
      if (syncToken != null) 'sync_token': syncToken,
      if (accessRole != null) 'access_role': accessRole,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  CalendarsMetaCompanion copyWith({
    Value<int>? id,
    Value<String>? accountEmail,
    Value<String>? googleCalendarId,
    Value<String>? summary,
    Value<String>? description,
    Value<String?>? colorHex,
    Value<bool>? isPrimary,
    Value<bool>? isSelected,
    Value<String?>? syncToken,
    Value<String>? accessRole,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
  }) {
    return CalendarsMetaCompanion(
      id: id ?? this.id,
      accountEmail: accountEmail ?? this.accountEmail,
      googleCalendarId: googleCalendarId ?? this.googleCalendarId,
      summary: summary ?? this.summary,
      description: description ?? this.description,
      colorHex: colorHex ?? this.colorHex,
      isPrimary: isPrimary ?? this.isPrimary,
      isSelected: isSelected ?? this.isSelected,
      syncToken: syncToken ?? this.syncToken,
      accessRole: accessRole ?? this.accessRole,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (accountEmail.present) {
      map['account_email'] = Variable<String>(accountEmail.value);
    }
    if (googleCalendarId.present) {
      map['google_calendar_id'] = Variable<String>(googleCalendarId.value);
    }
    if (summary.present) {
      map['summary'] = Variable<String>(summary.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (colorHex.present) {
      map['color_hex'] = Variable<String>(colorHex.value);
    }
    if (isPrimary.present) {
      map['is_primary'] = Variable<bool>(isPrimary.value);
    }
    if (isSelected.present) {
      map['is_selected'] = Variable<bool>(isSelected.value);
    }
    if (syncToken.present) {
      map['sync_token'] = Variable<String>(syncToken.value);
    }
    if (accessRole.present) {
      map['access_role'] = Variable<String>(accessRole.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CalendarsMetaCompanion(')
          ..write('id: $id, ')
          ..write('accountEmail: $accountEmail, ')
          ..write('googleCalendarId: $googleCalendarId, ')
          ..write('summary: $summary, ')
          ..write('description: $description, ')
          ..write('colorHex: $colorHex, ')
          ..write('isPrimary: $isPrimary, ')
          ..write('isSelected: $isSelected, ')
          ..write('syncToken: $syncToken, ')
          ..write('accessRole: $accessRole, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $CalendarEventsTable extends CalendarEvents
    with TableInfo<$CalendarEventsTable, CalendarEventEntity> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CalendarEventsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _googleEventIdMeta = const VerificationMeta(
    'googleEventId',
  );
  @override
  late final GeneratedColumn<String> googleEventId = GeneratedColumn<String>(
    'google_event_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _googleCalendarIdMeta = const VerificationMeta(
    'googleCalendarId',
  );
  @override
  late final GeneratedColumn<String> googleCalendarId = GeneratedColumn<String>(
    'google_calendar_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 500,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _locationMeta = const VerificationMeta(
    'location',
  );
  @override
  late final GeneratedColumn<String> location = GeneratedColumn<String>(
    'location',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _isAllDayMeta = const VerificationMeta(
    'isAllDay',
  );
  @override
  late final GeneratedColumn<bool> isAllDay = GeneratedColumn<bool>(
    'is_all_day',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_all_day" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _startDateMeta = const VerificationMeta(
    'startDate',
  );
  @override
  late final GeneratedColumn<String> startDate = GeneratedColumn<String>(
    'start_date',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _endDateMeta = const VerificationMeta(
    'endDate',
  );
  @override
  late final GeneratedColumn<String> endDate = GeneratedColumn<String>(
    'end_date',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _startDateTimeMeta = const VerificationMeta(
    'startDateTime',
  );
  @override
  late final GeneratedColumn<DateTime> startDateTime =
      GeneratedColumn<DateTime>(
        'start_date_time',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _endDateTimeMeta = const VerificationMeta(
    'endDateTime',
  );
  @override
  late final GeneratedColumn<DateTime> endDateTime = GeneratedColumn<DateTime>(
    'end_date_time',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _timeZoneMeta = const VerificationMeta(
    'timeZone',
  );
  @override
  late final GeneratedColumn<String> timeZone = GeneratedColumn<String>(
    'time_zone',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('UTC'),
  );
  static const VerificationMeta _recurrenceRuleMeta = const VerificationMeta(
    'recurrenceRule',
  );
  @override
  late final GeneratedColumn<String> recurrenceRule = GeneratedColumn<String>(
    'recurrence_rule',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _recurringEventIdMeta = const VerificationMeta(
    'recurringEventId',
  );
  @override
  late final GeneratedColumn<String> recurringEventId = GeneratedColumn<String>(
    'recurring_event_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _syncStatusMeta = const VerificationMeta(
    'syncStatus',
  );
  @override
  late final GeneratedColumn<String> syncStatus = GeneratedColumn<String>(
    'sync_status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('synced'),
  );
  static const VerificationMeta _remoteETagMeta = const VerificationMeta(
    'remoteETag',
  );
  @override
  late final GeneratedColumn<String> remoteETag = GeneratedColumn<String>(
    'remote_e_tag',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _clientMutationIdMeta = const VerificationMeta(
    'clientMutationId',
  );
  @override
  late final GeneratedColumn<String> clientMutationId = GeneratedColumn<String>(
    'client_mutation_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _lastErrorMeta = const VerificationMeta(
    'lastError',
  );
  @override
  late final GeneratedColumn<String> lastError = GeneratedColumn<String>(
    'last_error',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _lastModifiedMeta = const VerificationMeta(
    'lastModified',
  );
  @override
  late final GeneratedColumn<DateTime> lastModified = GeneratedColumn<DateTime>(
    'last_modified',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    googleEventId,
    googleCalendarId,
    title,
    description,
    location,
    isAllDay,
    startDate,
    endDate,
    startDateTime,
    endDateTime,
    timeZone,
    recurrenceRule,
    recurringEventId,
    syncStatus,
    remoteETag,
    clientMutationId,
    lastError,
    lastModified,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'calendar_events';
  @override
  VerificationContext validateIntegrity(
    Insertable<CalendarEventEntity> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('google_event_id')) {
      context.handle(
        _googleEventIdMeta,
        googleEventId.isAcceptableOrUnknown(
          data['google_event_id']!,
          _googleEventIdMeta,
        ),
      );
    }
    if (data.containsKey('google_calendar_id')) {
      context.handle(
        _googleCalendarIdMeta,
        googleCalendarId.isAcceptableOrUnknown(
          data['google_calendar_id']!,
          _googleCalendarIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_googleCalendarIdMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    }
    if (data.containsKey('location')) {
      context.handle(
        _locationMeta,
        location.isAcceptableOrUnknown(data['location']!, _locationMeta),
      );
    }
    if (data.containsKey('is_all_day')) {
      context.handle(
        _isAllDayMeta,
        isAllDay.isAcceptableOrUnknown(data['is_all_day']!, _isAllDayMeta),
      );
    }
    if (data.containsKey('start_date')) {
      context.handle(
        _startDateMeta,
        startDate.isAcceptableOrUnknown(data['start_date']!, _startDateMeta),
      );
    }
    if (data.containsKey('end_date')) {
      context.handle(
        _endDateMeta,
        endDate.isAcceptableOrUnknown(data['end_date']!, _endDateMeta),
      );
    }
    if (data.containsKey('start_date_time')) {
      context.handle(
        _startDateTimeMeta,
        startDateTime.isAcceptableOrUnknown(
          data['start_date_time']!,
          _startDateTimeMeta,
        ),
      );
    }
    if (data.containsKey('end_date_time')) {
      context.handle(
        _endDateTimeMeta,
        endDateTime.isAcceptableOrUnknown(
          data['end_date_time']!,
          _endDateTimeMeta,
        ),
      );
    }
    if (data.containsKey('time_zone')) {
      context.handle(
        _timeZoneMeta,
        timeZone.isAcceptableOrUnknown(data['time_zone']!, _timeZoneMeta),
      );
    }
    if (data.containsKey('recurrence_rule')) {
      context.handle(
        _recurrenceRuleMeta,
        recurrenceRule.isAcceptableOrUnknown(
          data['recurrence_rule']!,
          _recurrenceRuleMeta,
        ),
      );
    }
    if (data.containsKey('recurring_event_id')) {
      context.handle(
        _recurringEventIdMeta,
        recurringEventId.isAcceptableOrUnknown(
          data['recurring_event_id']!,
          _recurringEventIdMeta,
        ),
      );
    }
    if (data.containsKey('sync_status')) {
      context.handle(
        _syncStatusMeta,
        syncStatus.isAcceptableOrUnknown(data['sync_status']!, _syncStatusMeta),
      );
    }
    if (data.containsKey('remote_e_tag')) {
      context.handle(
        _remoteETagMeta,
        remoteETag.isAcceptableOrUnknown(
          data['remote_e_tag']!,
          _remoteETagMeta,
        ),
      );
    }
    if (data.containsKey('client_mutation_id')) {
      context.handle(
        _clientMutationIdMeta,
        clientMutationId.isAcceptableOrUnknown(
          data['client_mutation_id']!,
          _clientMutationIdMeta,
        ),
      );
    }
    if (data.containsKey('last_error')) {
      context.handle(
        _lastErrorMeta,
        lastError.isAcceptableOrUnknown(data['last_error']!, _lastErrorMeta),
      );
    }
    if (data.containsKey('last_modified')) {
      context.handle(
        _lastModifiedMeta,
        lastModified.isAcceptableOrUnknown(
          data['last_modified']!,
          _lastModifiedMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CalendarEventEntity map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CalendarEventEntity(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      googleEventId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}google_event_id'],
      ),
      googleCalendarId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}google_calendar_id'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      )!,
      location: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}location'],
      )!,
      isAllDay: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_all_day'],
      )!,
      startDate: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}start_date'],
      ),
      endDate: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}end_date'],
      ),
      startDateTime: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}start_date_time'],
      ),
      endDateTime: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}end_date_time'],
      ),
      timeZone: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}time_zone'],
      )!,
      recurrenceRule: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}recurrence_rule'],
      ),
      recurringEventId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}recurring_event_id'],
      ),
      syncStatus: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sync_status'],
      )!,
      remoteETag: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}remote_e_tag'],
      ),
      clientMutationId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}client_mutation_id'],
      ),
      lastError: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}last_error'],
      ),
      lastModified: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_modified'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $CalendarEventsTable createAlias(String alias) {
    return $CalendarEventsTable(attachedDatabase, alias);
  }
}

class CalendarEventEntity extends DataClass
    implements Insertable<CalendarEventEntity> {
  final int id;
  final String? googleEventId;
  final String googleCalendarId;
  final String title;
  final String description;
  final String location;

  /// Flag indicating whether this is an all-day event or timed event.
  final bool isAllDay;

  /// Date-only start date in `YYYY-MM-DD` format for all-day events.
  final String? startDate;

  /// Date-only exclusive end date in `YYYY-MM-DD` format for all-day events
  /// conforming strictly to Google Calendar's half-open `[startDate, endDate)` interval.
  final String? endDate;

  /// Instant start for timed events in UTC.
  final DateTime? startDateTime;

  /// Instant end for timed events in UTC.
  final DateTime? endDateTime;

  /// Original time zone string (e.g. 'Asia/Kolkata', 'America/New_York').
  final String timeZone;
  final String? recurrenceRule;
  final String? recurringEventId;

  /// Sync state: 'synced', 'pendingCreate', 'pendingUpdate', 'pendingDelete', 'failed'
  final String syncStatus;
  final String? remoteETag;

  /// Client-generated UUID tracking the local mutation ownership.
  final String? clientMutationId;
  final String? lastError;
  final DateTime lastModified;
  final DateTime createdAt;
  const CalendarEventEntity({
    required this.id,
    this.googleEventId,
    required this.googleCalendarId,
    required this.title,
    required this.description,
    required this.location,
    required this.isAllDay,
    this.startDate,
    this.endDate,
    this.startDateTime,
    this.endDateTime,
    required this.timeZone,
    this.recurrenceRule,
    this.recurringEventId,
    required this.syncStatus,
    this.remoteETag,
    this.clientMutationId,
    this.lastError,
    required this.lastModified,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    if (!nullToAbsent || googleEventId != null) {
      map['google_event_id'] = Variable<String>(googleEventId);
    }
    map['google_calendar_id'] = Variable<String>(googleCalendarId);
    map['title'] = Variable<String>(title);
    map['description'] = Variable<String>(description);
    map['location'] = Variable<String>(location);
    map['is_all_day'] = Variable<bool>(isAllDay);
    if (!nullToAbsent || startDate != null) {
      map['start_date'] = Variable<String>(startDate);
    }
    if (!nullToAbsent || endDate != null) {
      map['end_date'] = Variable<String>(endDate);
    }
    if (!nullToAbsent || startDateTime != null) {
      map['start_date_time'] = Variable<DateTime>(startDateTime);
    }
    if (!nullToAbsent || endDateTime != null) {
      map['end_date_time'] = Variable<DateTime>(endDateTime);
    }
    map['time_zone'] = Variable<String>(timeZone);
    if (!nullToAbsent || recurrenceRule != null) {
      map['recurrence_rule'] = Variable<String>(recurrenceRule);
    }
    if (!nullToAbsent || recurringEventId != null) {
      map['recurring_event_id'] = Variable<String>(recurringEventId);
    }
    map['sync_status'] = Variable<String>(syncStatus);
    if (!nullToAbsent || remoteETag != null) {
      map['remote_e_tag'] = Variable<String>(remoteETag);
    }
    if (!nullToAbsent || clientMutationId != null) {
      map['client_mutation_id'] = Variable<String>(clientMutationId);
    }
    if (!nullToAbsent || lastError != null) {
      map['last_error'] = Variable<String>(lastError);
    }
    map['last_modified'] = Variable<DateTime>(lastModified);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  CalendarEventsCompanion toCompanion(bool nullToAbsent) {
    return CalendarEventsCompanion(
      id: Value(id),
      googleEventId: googleEventId == null && nullToAbsent
          ? const Value.absent()
          : Value(googleEventId),
      googleCalendarId: Value(googleCalendarId),
      title: Value(title),
      description: Value(description),
      location: Value(location),
      isAllDay: Value(isAllDay),
      startDate: startDate == null && nullToAbsent
          ? const Value.absent()
          : Value(startDate),
      endDate: endDate == null && nullToAbsent
          ? const Value.absent()
          : Value(endDate),
      startDateTime: startDateTime == null && nullToAbsent
          ? const Value.absent()
          : Value(startDateTime),
      endDateTime: endDateTime == null && nullToAbsent
          ? const Value.absent()
          : Value(endDateTime),
      timeZone: Value(timeZone),
      recurrenceRule: recurrenceRule == null && nullToAbsent
          ? const Value.absent()
          : Value(recurrenceRule),
      recurringEventId: recurringEventId == null && nullToAbsent
          ? const Value.absent()
          : Value(recurringEventId),
      syncStatus: Value(syncStatus),
      remoteETag: remoteETag == null && nullToAbsent
          ? const Value.absent()
          : Value(remoteETag),
      clientMutationId: clientMutationId == null && nullToAbsent
          ? const Value.absent()
          : Value(clientMutationId),
      lastError: lastError == null && nullToAbsent
          ? const Value.absent()
          : Value(lastError),
      lastModified: Value(lastModified),
      createdAt: Value(createdAt),
    );
  }

  factory CalendarEventEntity.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CalendarEventEntity(
      id: serializer.fromJson<int>(json['id']),
      googleEventId: serializer.fromJson<String?>(json['googleEventId']),
      googleCalendarId: serializer.fromJson<String>(json['googleCalendarId']),
      title: serializer.fromJson<String>(json['title']),
      description: serializer.fromJson<String>(json['description']),
      location: serializer.fromJson<String>(json['location']),
      isAllDay: serializer.fromJson<bool>(json['isAllDay']),
      startDate: serializer.fromJson<String?>(json['startDate']),
      endDate: serializer.fromJson<String?>(json['endDate']),
      startDateTime: serializer.fromJson<DateTime?>(json['startDateTime']),
      endDateTime: serializer.fromJson<DateTime?>(json['endDateTime']),
      timeZone: serializer.fromJson<String>(json['timeZone']),
      recurrenceRule: serializer.fromJson<String?>(json['recurrenceRule']),
      recurringEventId: serializer.fromJson<String?>(json['recurringEventId']),
      syncStatus: serializer.fromJson<String>(json['syncStatus']),
      remoteETag: serializer.fromJson<String?>(json['remoteETag']),
      clientMutationId: serializer.fromJson<String?>(json['clientMutationId']),
      lastError: serializer.fromJson<String?>(json['lastError']),
      lastModified: serializer.fromJson<DateTime>(json['lastModified']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'googleEventId': serializer.toJson<String?>(googleEventId),
      'googleCalendarId': serializer.toJson<String>(googleCalendarId),
      'title': serializer.toJson<String>(title),
      'description': serializer.toJson<String>(description),
      'location': serializer.toJson<String>(location),
      'isAllDay': serializer.toJson<bool>(isAllDay),
      'startDate': serializer.toJson<String?>(startDate),
      'endDate': serializer.toJson<String?>(endDate),
      'startDateTime': serializer.toJson<DateTime?>(startDateTime),
      'endDateTime': serializer.toJson<DateTime?>(endDateTime),
      'timeZone': serializer.toJson<String>(timeZone),
      'recurrenceRule': serializer.toJson<String?>(recurrenceRule),
      'recurringEventId': serializer.toJson<String?>(recurringEventId),
      'syncStatus': serializer.toJson<String>(syncStatus),
      'remoteETag': serializer.toJson<String?>(remoteETag),
      'clientMutationId': serializer.toJson<String?>(clientMutationId),
      'lastError': serializer.toJson<String?>(lastError),
      'lastModified': serializer.toJson<DateTime>(lastModified),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  CalendarEventEntity copyWith({
    int? id,
    Value<String?> googleEventId = const Value.absent(),
    String? googleCalendarId,
    String? title,
    String? description,
    String? location,
    bool? isAllDay,
    Value<String?> startDate = const Value.absent(),
    Value<String?> endDate = const Value.absent(),
    Value<DateTime?> startDateTime = const Value.absent(),
    Value<DateTime?> endDateTime = const Value.absent(),
    String? timeZone,
    Value<String?> recurrenceRule = const Value.absent(),
    Value<String?> recurringEventId = const Value.absent(),
    String? syncStatus,
    Value<String?> remoteETag = const Value.absent(),
    Value<String?> clientMutationId = const Value.absent(),
    Value<String?> lastError = const Value.absent(),
    DateTime? lastModified,
    DateTime? createdAt,
  }) => CalendarEventEntity(
    id: id ?? this.id,
    googleEventId: googleEventId.present
        ? googleEventId.value
        : this.googleEventId,
    googleCalendarId: googleCalendarId ?? this.googleCalendarId,
    title: title ?? this.title,
    description: description ?? this.description,
    location: location ?? this.location,
    isAllDay: isAllDay ?? this.isAllDay,
    startDate: startDate.present ? startDate.value : this.startDate,
    endDate: endDate.present ? endDate.value : this.endDate,
    startDateTime: startDateTime.present
        ? startDateTime.value
        : this.startDateTime,
    endDateTime: endDateTime.present ? endDateTime.value : this.endDateTime,
    timeZone: timeZone ?? this.timeZone,
    recurrenceRule: recurrenceRule.present
        ? recurrenceRule.value
        : this.recurrenceRule,
    recurringEventId: recurringEventId.present
        ? recurringEventId.value
        : this.recurringEventId,
    syncStatus: syncStatus ?? this.syncStatus,
    remoteETag: remoteETag.present ? remoteETag.value : this.remoteETag,
    clientMutationId: clientMutationId.present
        ? clientMutationId.value
        : this.clientMutationId,
    lastError: lastError.present ? lastError.value : this.lastError,
    lastModified: lastModified ?? this.lastModified,
    createdAt: createdAt ?? this.createdAt,
  );
  CalendarEventEntity copyWithCompanion(CalendarEventsCompanion data) {
    return CalendarEventEntity(
      id: data.id.present ? data.id.value : this.id,
      googleEventId: data.googleEventId.present
          ? data.googleEventId.value
          : this.googleEventId,
      googleCalendarId: data.googleCalendarId.present
          ? data.googleCalendarId.value
          : this.googleCalendarId,
      title: data.title.present ? data.title.value : this.title,
      description: data.description.present
          ? data.description.value
          : this.description,
      location: data.location.present ? data.location.value : this.location,
      isAllDay: data.isAllDay.present ? data.isAllDay.value : this.isAllDay,
      startDate: data.startDate.present ? data.startDate.value : this.startDate,
      endDate: data.endDate.present ? data.endDate.value : this.endDate,
      startDateTime: data.startDateTime.present
          ? data.startDateTime.value
          : this.startDateTime,
      endDateTime: data.endDateTime.present
          ? data.endDateTime.value
          : this.endDateTime,
      timeZone: data.timeZone.present ? data.timeZone.value : this.timeZone,
      recurrenceRule: data.recurrenceRule.present
          ? data.recurrenceRule.value
          : this.recurrenceRule,
      recurringEventId: data.recurringEventId.present
          ? data.recurringEventId.value
          : this.recurringEventId,
      syncStatus: data.syncStatus.present
          ? data.syncStatus.value
          : this.syncStatus,
      remoteETag: data.remoteETag.present
          ? data.remoteETag.value
          : this.remoteETag,
      clientMutationId: data.clientMutationId.present
          ? data.clientMutationId.value
          : this.clientMutationId,
      lastError: data.lastError.present ? data.lastError.value : this.lastError,
      lastModified: data.lastModified.present
          ? data.lastModified.value
          : this.lastModified,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CalendarEventEntity(')
          ..write('id: $id, ')
          ..write('googleEventId: $googleEventId, ')
          ..write('googleCalendarId: $googleCalendarId, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('location: $location, ')
          ..write('isAllDay: $isAllDay, ')
          ..write('startDate: $startDate, ')
          ..write('endDate: $endDate, ')
          ..write('startDateTime: $startDateTime, ')
          ..write('endDateTime: $endDateTime, ')
          ..write('timeZone: $timeZone, ')
          ..write('recurrenceRule: $recurrenceRule, ')
          ..write('recurringEventId: $recurringEventId, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('remoteETag: $remoteETag, ')
          ..write('clientMutationId: $clientMutationId, ')
          ..write('lastError: $lastError, ')
          ..write('lastModified: $lastModified, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    googleEventId,
    googleCalendarId,
    title,
    description,
    location,
    isAllDay,
    startDate,
    endDate,
    startDateTime,
    endDateTime,
    timeZone,
    recurrenceRule,
    recurringEventId,
    syncStatus,
    remoteETag,
    clientMutationId,
    lastError,
    lastModified,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CalendarEventEntity &&
          other.id == this.id &&
          other.googleEventId == this.googleEventId &&
          other.googleCalendarId == this.googleCalendarId &&
          other.title == this.title &&
          other.description == this.description &&
          other.location == this.location &&
          other.isAllDay == this.isAllDay &&
          other.startDate == this.startDate &&
          other.endDate == this.endDate &&
          other.startDateTime == this.startDateTime &&
          other.endDateTime == this.endDateTime &&
          other.timeZone == this.timeZone &&
          other.recurrenceRule == this.recurrenceRule &&
          other.recurringEventId == this.recurringEventId &&
          other.syncStatus == this.syncStatus &&
          other.remoteETag == this.remoteETag &&
          other.clientMutationId == this.clientMutationId &&
          other.lastError == this.lastError &&
          other.lastModified == this.lastModified &&
          other.createdAt == this.createdAt);
}

class CalendarEventsCompanion extends UpdateCompanion<CalendarEventEntity> {
  final Value<int> id;
  final Value<String?> googleEventId;
  final Value<String> googleCalendarId;
  final Value<String> title;
  final Value<String> description;
  final Value<String> location;
  final Value<bool> isAllDay;
  final Value<String?> startDate;
  final Value<String?> endDate;
  final Value<DateTime?> startDateTime;
  final Value<DateTime?> endDateTime;
  final Value<String> timeZone;
  final Value<String?> recurrenceRule;
  final Value<String?> recurringEventId;
  final Value<String> syncStatus;
  final Value<String?> remoteETag;
  final Value<String?> clientMutationId;
  final Value<String?> lastError;
  final Value<DateTime> lastModified;
  final Value<DateTime> createdAt;
  const CalendarEventsCompanion({
    this.id = const Value.absent(),
    this.googleEventId = const Value.absent(),
    this.googleCalendarId = const Value.absent(),
    this.title = const Value.absent(),
    this.description = const Value.absent(),
    this.location = const Value.absent(),
    this.isAllDay = const Value.absent(),
    this.startDate = const Value.absent(),
    this.endDate = const Value.absent(),
    this.startDateTime = const Value.absent(),
    this.endDateTime = const Value.absent(),
    this.timeZone = const Value.absent(),
    this.recurrenceRule = const Value.absent(),
    this.recurringEventId = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.remoteETag = const Value.absent(),
    this.clientMutationId = const Value.absent(),
    this.lastError = const Value.absent(),
    this.lastModified = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  CalendarEventsCompanion.insert({
    this.id = const Value.absent(),
    this.googleEventId = const Value.absent(),
    required String googleCalendarId,
    required String title,
    this.description = const Value.absent(),
    this.location = const Value.absent(),
    this.isAllDay = const Value.absent(),
    this.startDate = const Value.absent(),
    this.endDate = const Value.absent(),
    this.startDateTime = const Value.absent(),
    this.endDateTime = const Value.absent(),
    this.timeZone = const Value.absent(),
    this.recurrenceRule = const Value.absent(),
    this.recurringEventId = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.remoteETag = const Value.absent(),
    this.clientMutationId = const Value.absent(),
    this.lastError = const Value.absent(),
    this.lastModified = const Value.absent(),
    this.createdAt = const Value.absent(),
  }) : googleCalendarId = Value(googleCalendarId),
       title = Value(title);
  static Insertable<CalendarEventEntity> custom({
    Expression<int>? id,
    Expression<String>? googleEventId,
    Expression<String>? googleCalendarId,
    Expression<String>? title,
    Expression<String>? description,
    Expression<String>? location,
    Expression<bool>? isAllDay,
    Expression<String>? startDate,
    Expression<String>? endDate,
    Expression<DateTime>? startDateTime,
    Expression<DateTime>? endDateTime,
    Expression<String>? timeZone,
    Expression<String>? recurrenceRule,
    Expression<String>? recurringEventId,
    Expression<String>? syncStatus,
    Expression<String>? remoteETag,
    Expression<String>? clientMutationId,
    Expression<String>? lastError,
    Expression<DateTime>? lastModified,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (googleEventId != null) 'google_event_id': googleEventId,
      if (googleCalendarId != null) 'google_calendar_id': googleCalendarId,
      if (title != null) 'title': title,
      if (description != null) 'description': description,
      if (location != null) 'location': location,
      if (isAllDay != null) 'is_all_day': isAllDay,
      if (startDate != null) 'start_date': startDate,
      if (endDate != null) 'end_date': endDate,
      if (startDateTime != null) 'start_date_time': startDateTime,
      if (endDateTime != null) 'end_date_time': endDateTime,
      if (timeZone != null) 'time_zone': timeZone,
      if (recurrenceRule != null) 'recurrence_rule': recurrenceRule,
      if (recurringEventId != null) 'recurring_event_id': recurringEventId,
      if (syncStatus != null) 'sync_status': syncStatus,
      if (remoteETag != null) 'remote_e_tag': remoteETag,
      if (clientMutationId != null) 'client_mutation_id': clientMutationId,
      if (lastError != null) 'last_error': lastError,
      if (lastModified != null) 'last_modified': lastModified,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  CalendarEventsCompanion copyWith({
    Value<int>? id,
    Value<String?>? googleEventId,
    Value<String>? googleCalendarId,
    Value<String>? title,
    Value<String>? description,
    Value<String>? location,
    Value<bool>? isAllDay,
    Value<String?>? startDate,
    Value<String?>? endDate,
    Value<DateTime?>? startDateTime,
    Value<DateTime?>? endDateTime,
    Value<String>? timeZone,
    Value<String?>? recurrenceRule,
    Value<String?>? recurringEventId,
    Value<String>? syncStatus,
    Value<String?>? remoteETag,
    Value<String?>? clientMutationId,
    Value<String?>? lastError,
    Value<DateTime>? lastModified,
    Value<DateTime>? createdAt,
  }) {
    return CalendarEventsCompanion(
      id: id ?? this.id,
      googleEventId: googleEventId ?? this.googleEventId,
      googleCalendarId: googleCalendarId ?? this.googleCalendarId,
      title: title ?? this.title,
      description: description ?? this.description,
      location: location ?? this.location,
      isAllDay: isAllDay ?? this.isAllDay,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      startDateTime: startDateTime ?? this.startDateTime,
      endDateTime: endDateTime ?? this.endDateTime,
      timeZone: timeZone ?? this.timeZone,
      recurrenceRule: recurrenceRule ?? this.recurrenceRule,
      recurringEventId: recurringEventId ?? this.recurringEventId,
      syncStatus: syncStatus ?? this.syncStatus,
      remoteETag: remoteETag ?? this.remoteETag,
      clientMutationId: clientMutationId ?? this.clientMutationId,
      lastError: lastError ?? this.lastError,
      lastModified: lastModified ?? this.lastModified,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (googleEventId.present) {
      map['google_event_id'] = Variable<String>(googleEventId.value);
    }
    if (googleCalendarId.present) {
      map['google_calendar_id'] = Variable<String>(googleCalendarId.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (location.present) {
      map['location'] = Variable<String>(location.value);
    }
    if (isAllDay.present) {
      map['is_all_day'] = Variable<bool>(isAllDay.value);
    }
    if (startDate.present) {
      map['start_date'] = Variable<String>(startDate.value);
    }
    if (endDate.present) {
      map['end_date'] = Variable<String>(endDate.value);
    }
    if (startDateTime.present) {
      map['start_date_time'] = Variable<DateTime>(startDateTime.value);
    }
    if (endDateTime.present) {
      map['end_date_time'] = Variable<DateTime>(endDateTime.value);
    }
    if (timeZone.present) {
      map['time_zone'] = Variable<String>(timeZone.value);
    }
    if (recurrenceRule.present) {
      map['recurrence_rule'] = Variable<String>(recurrenceRule.value);
    }
    if (recurringEventId.present) {
      map['recurring_event_id'] = Variable<String>(recurringEventId.value);
    }
    if (syncStatus.present) {
      map['sync_status'] = Variable<String>(syncStatus.value);
    }
    if (remoteETag.present) {
      map['remote_e_tag'] = Variable<String>(remoteETag.value);
    }
    if (clientMutationId.present) {
      map['client_mutation_id'] = Variable<String>(clientMutationId.value);
    }
    if (lastError.present) {
      map['last_error'] = Variable<String>(lastError.value);
    }
    if (lastModified.present) {
      map['last_modified'] = Variable<DateTime>(lastModified.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CalendarEventsCompanion(')
          ..write('id: $id, ')
          ..write('googleEventId: $googleEventId, ')
          ..write('googleCalendarId: $googleCalendarId, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('location: $location, ')
          ..write('isAllDay: $isAllDay, ')
          ..write('startDate: $startDate, ')
          ..write('endDate: $endDate, ')
          ..write('startDateTime: $startDateTime, ')
          ..write('endDateTime: $endDateTime, ')
          ..write('timeZone: $timeZone, ')
          ..write('recurrenceRule: $recurrenceRule, ')
          ..write('recurringEventId: $recurringEventId, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('remoteETag: $remoteETag, ')
          ..write('clientMutationId: $clientMutationId, ')
          ..write('lastError: $lastError, ')
          ..write('lastModified: $lastModified, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $CalendarOutboxTable extends CalendarOutbox
    with TableInfo<$CalendarOutboxTable, CalendarOutboxEntity> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CalendarOutboxTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _clientMutationIdMeta = const VerificationMeta(
    'clientMutationId',
  );
  @override
  late final GeneratedColumn<String> clientMutationId = GeneratedColumn<String>(
    'client_mutation_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _actionTypeMeta = const VerificationMeta(
    'actionType',
  );
  @override
  late final GeneratedColumn<String> actionType = GeneratedColumn<String>(
    'action_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _localEventIdMeta = const VerificationMeta(
    'localEventId',
  );
  @override
  late final GeneratedColumn<int> localEventId = GeneratedColumn<int>(
    'local_event_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _googleEventIdMeta = const VerificationMeta(
    'googleEventId',
  );
  @override
  late final GeneratedColumn<String> googleEventId = GeneratedColumn<String>(
    'google_event_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _googleCalendarIdMeta = const VerificationMeta(
    'googleCalendarId',
  );
  @override
  late final GeneratedColumn<String> googleCalendarId = GeneratedColumn<String>(
    'google_calendar_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _payloadJsonMeta = const VerificationMeta(
    'payloadJson',
  );
  @override
  late final GeneratedColumn<String> payloadJson = GeneratedColumn<String>(
    'payload_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _remoteETagMeta = const VerificationMeta(
    'remoteETag',
  );
  @override
  late final GeneratedColumn<String> remoteETag = GeneratedColumn<String>(
    'remote_e_tag',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _retryCountMeta = const VerificationMeta(
    'retryCount',
  );
  @override
  late final GeneratedColumn<int> retryCount = GeneratedColumn<int>(
    'retry_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _lastErrorMeta = const VerificationMeta(
    'lastError',
  );
  @override
  late final GeneratedColumn<String> lastError = GeneratedColumn<String>(
    'last_error',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    clientMutationId,
    actionType,
    localEventId,
    googleEventId,
    googleCalendarId,
    payloadJson,
    remoteETag,
    retryCount,
    lastError,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'calendar_outbox';
  @override
  VerificationContext validateIntegrity(
    Insertable<CalendarOutboxEntity> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('client_mutation_id')) {
      context.handle(
        _clientMutationIdMeta,
        clientMutationId.isAcceptableOrUnknown(
          data['client_mutation_id']!,
          _clientMutationIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_clientMutationIdMeta);
    }
    if (data.containsKey('action_type')) {
      context.handle(
        _actionTypeMeta,
        actionType.isAcceptableOrUnknown(data['action_type']!, _actionTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_actionTypeMeta);
    }
    if (data.containsKey('local_event_id')) {
      context.handle(
        _localEventIdMeta,
        localEventId.isAcceptableOrUnknown(
          data['local_event_id']!,
          _localEventIdMeta,
        ),
      );
    }
    if (data.containsKey('google_event_id')) {
      context.handle(
        _googleEventIdMeta,
        googleEventId.isAcceptableOrUnknown(
          data['google_event_id']!,
          _googleEventIdMeta,
        ),
      );
    }
    if (data.containsKey('google_calendar_id')) {
      context.handle(
        _googleCalendarIdMeta,
        googleCalendarId.isAcceptableOrUnknown(
          data['google_calendar_id']!,
          _googleCalendarIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_googleCalendarIdMeta);
    }
    if (data.containsKey('payload_json')) {
      context.handle(
        _payloadJsonMeta,
        payloadJson.isAcceptableOrUnknown(
          data['payload_json']!,
          _payloadJsonMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_payloadJsonMeta);
    }
    if (data.containsKey('remote_e_tag')) {
      context.handle(
        _remoteETagMeta,
        remoteETag.isAcceptableOrUnknown(
          data['remote_e_tag']!,
          _remoteETagMeta,
        ),
      );
    }
    if (data.containsKey('retry_count')) {
      context.handle(
        _retryCountMeta,
        retryCount.isAcceptableOrUnknown(data['retry_count']!, _retryCountMeta),
      );
    }
    if (data.containsKey('last_error')) {
      context.handle(
        _lastErrorMeta,
        lastError.isAcceptableOrUnknown(data['last_error']!, _lastErrorMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CalendarOutboxEntity map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CalendarOutboxEntity(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      clientMutationId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}client_mutation_id'],
      )!,
      actionType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}action_type'],
      )!,
      localEventId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}local_event_id'],
      ),
      googleEventId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}google_event_id'],
      ),
      googleCalendarId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}google_calendar_id'],
      )!,
      payloadJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}payload_json'],
      )!,
      remoteETag: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}remote_e_tag'],
      ),
      retryCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}retry_count'],
      )!,
      lastError: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}last_error'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $CalendarOutboxTable createAlias(String alias) {
    return $CalendarOutboxTable(attachedDatabase, alias);
  }
}

class CalendarOutboxEntity extends DataClass
    implements Insertable<CalendarOutboxEntity> {
  final int id;

  /// Idempotent action identifier (UUID v4).
  final String clientMutationId;

  /// 'create', 'update', or 'delete'
  final String actionType;

  /// Local SQLite ID in CalendarEvents (if created locally).
  final int? localEventId;

  /// Remote Google Event ID (known for updates/deletes, or assigned client ID for creates).
  final String? googleEventId;

  /// Target Google Calendar ID.
  final String googleCalendarId;

  /// Serialized event payload in JSON.
  final String payloadJson;

  /// Remote ETag for concurrency check on updates.
  final String? remoteETag;
  final int retryCount;
  final String? lastError;
  final DateTime createdAt;
  final DateTime updatedAt;
  const CalendarOutboxEntity({
    required this.id,
    required this.clientMutationId,
    required this.actionType,
    this.localEventId,
    this.googleEventId,
    required this.googleCalendarId,
    required this.payloadJson,
    this.remoteETag,
    required this.retryCount,
    this.lastError,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['client_mutation_id'] = Variable<String>(clientMutationId);
    map['action_type'] = Variable<String>(actionType);
    if (!nullToAbsent || localEventId != null) {
      map['local_event_id'] = Variable<int>(localEventId);
    }
    if (!nullToAbsent || googleEventId != null) {
      map['google_event_id'] = Variable<String>(googleEventId);
    }
    map['google_calendar_id'] = Variable<String>(googleCalendarId);
    map['payload_json'] = Variable<String>(payloadJson);
    if (!nullToAbsent || remoteETag != null) {
      map['remote_e_tag'] = Variable<String>(remoteETag);
    }
    map['retry_count'] = Variable<int>(retryCount);
    if (!nullToAbsent || lastError != null) {
      map['last_error'] = Variable<String>(lastError);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  CalendarOutboxCompanion toCompanion(bool nullToAbsent) {
    return CalendarOutboxCompanion(
      id: Value(id),
      clientMutationId: Value(clientMutationId),
      actionType: Value(actionType),
      localEventId: localEventId == null && nullToAbsent
          ? const Value.absent()
          : Value(localEventId),
      googleEventId: googleEventId == null && nullToAbsent
          ? const Value.absent()
          : Value(googleEventId),
      googleCalendarId: Value(googleCalendarId),
      payloadJson: Value(payloadJson),
      remoteETag: remoteETag == null && nullToAbsent
          ? const Value.absent()
          : Value(remoteETag),
      retryCount: Value(retryCount),
      lastError: lastError == null && nullToAbsent
          ? const Value.absent()
          : Value(lastError),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory CalendarOutboxEntity.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CalendarOutboxEntity(
      id: serializer.fromJson<int>(json['id']),
      clientMutationId: serializer.fromJson<String>(json['clientMutationId']),
      actionType: serializer.fromJson<String>(json['actionType']),
      localEventId: serializer.fromJson<int?>(json['localEventId']),
      googleEventId: serializer.fromJson<String?>(json['googleEventId']),
      googleCalendarId: serializer.fromJson<String>(json['googleCalendarId']),
      payloadJson: serializer.fromJson<String>(json['payloadJson']),
      remoteETag: serializer.fromJson<String?>(json['remoteETag']),
      retryCount: serializer.fromJson<int>(json['retryCount']),
      lastError: serializer.fromJson<String?>(json['lastError']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'clientMutationId': serializer.toJson<String>(clientMutationId),
      'actionType': serializer.toJson<String>(actionType),
      'localEventId': serializer.toJson<int?>(localEventId),
      'googleEventId': serializer.toJson<String?>(googleEventId),
      'googleCalendarId': serializer.toJson<String>(googleCalendarId),
      'payloadJson': serializer.toJson<String>(payloadJson),
      'remoteETag': serializer.toJson<String?>(remoteETag),
      'retryCount': serializer.toJson<int>(retryCount),
      'lastError': serializer.toJson<String?>(lastError),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  CalendarOutboxEntity copyWith({
    int? id,
    String? clientMutationId,
    String? actionType,
    Value<int?> localEventId = const Value.absent(),
    Value<String?> googleEventId = const Value.absent(),
    String? googleCalendarId,
    String? payloadJson,
    Value<String?> remoteETag = const Value.absent(),
    int? retryCount,
    Value<String?> lastError = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => CalendarOutboxEntity(
    id: id ?? this.id,
    clientMutationId: clientMutationId ?? this.clientMutationId,
    actionType: actionType ?? this.actionType,
    localEventId: localEventId.present ? localEventId.value : this.localEventId,
    googleEventId: googleEventId.present
        ? googleEventId.value
        : this.googleEventId,
    googleCalendarId: googleCalendarId ?? this.googleCalendarId,
    payloadJson: payloadJson ?? this.payloadJson,
    remoteETag: remoteETag.present ? remoteETag.value : this.remoteETag,
    retryCount: retryCount ?? this.retryCount,
    lastError: lastError.present ? lastError.value : this.lastError,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  CalendarOutboxEntity copyWithCompanion(CalendarOutboxCompanion data) {
    return CalendarOutboxEntity(
      id: data.id.present ? data.id.value : this.id,
      clientMutationId: data.clientMutationId.present
          ? data.clientMutationId.value
          : this.clientMutationId,
      actionType: data.actionType.present
          ? data.actionType.value
          : this.actionType,
      localEventId: data.localEventId.present
          ? data.localEventId.value
          : this.localEventId,
      googleEventId: data.googleEventId.present
          ? data.googleEventId.value
          : this.googleEventId,
      googleCalendarId: data.googleCalendarId.present
          ? data.googleCalendarId.value
          : this.googleCalendarId,
      payloadJson: data.payloadJson.present
          ? data.payloadJson.value
          : this.payloadJson,
      remoteETag: data.remoteETag.present
          ? data.remoteETag.value
          : this.remoteETag,
      retryCount: data.retryCount.present
          ? data.retryCount.value
          : this.retryCount,
      lastError: data.lastError.present ? data.lastError.value : this.lastError,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CalendarOutboxEntity(')
          ..write('id: $id, ')
          ..write('clientMutationId: $clientMutationId, ')
          ..write('actionType: $actionType, ')
          ..write('localEventId: $localEventId, ')
          ..write('googleEventId: $googleEventId, ')
          ..write('googleCalendarId: $googleCalendarId, ')
          ..write('payloadJson: $payloadJson, ')
          ..write('remoteETag: $remoteETag, ')
          ..write('retryCount: $retryCount, ')
          ..write('lastError: $lastError, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    clientMutationId,
    actionType,
    localEventId,
    googleEventId,
    googleCalendarId,
    payloadJson,
    remoteETag,
    retryCount,
    lastError,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CalendarOutboxEntity &&
          other.id == this.id &&
          other.clientMutationId == this.clientMutationId &&
          other.actionType == this.actionType &&
          other.localEventId == this.localEventId &&
          other.googleEventId == this.googleEventId &&
          other.googleCalendarId == this.googleCalendarId &&
          other.payloadJson == this.payloadJson &&
          other.remoteETag == this.remoteETag &&
          other.retryCount == this.retryCount &&
          other.lastError == this.lastError &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class CalendarOutboxCompanion extends UpdateCompanion<CalendarOutboxEntity> {
  final Value<int> id;
  final Value<String> clientMutationId;
  final Value<String> actionType;
  final Value<int?> localEventId;
  final Value<String?> googleEventId;
  final Value<String> googleCalendarId;
  final Value<String> payloadJson;
  final Value<String?> remoteETag;
  final Value<int> retryCount;
  final Value<String?> lastError;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const CalendarOutboxCompanion({
    this.id = const Value.absent(),
    this.clientMutationId = const Value.absent(),
    this.actionType = const Value.absent(),
    this.localEventId = const Value.absent(),
    this.googleEventId = const Value.absent(),
    this.googleCalendarId = const Value.absent(),
    this.payloadJson = const Value.absent(),
    this.remoteETag = const Value.absent(),
    this.retryCount = const Value.absent(),
    this.lastError = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  CalendarOutboxCompanion.insert({
    this.id = const Value.absent(),
    required String clientMutationId,
    required String actionType,
    this.localEventId = const Value.absent(),
    this.googleEventId = const Value.absent(),
    required String googleCalendarId,
    required String payloadJson,
    this.remoteETag = const Value.absent(),
    this.retryCount = const Value.absent(),
    this.lastError = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  }) : clientMutationId = Value(clientMutationId),
       actionType = Value(actionType),
       googleCalendarId = Value(googleCalendarId),
       payloadJson = Value(payloadJson);
  static Insertable<CalendarOutboxEntity> custom({
    Expression<int>? id,
    Expression<String>? clientMutationId,
    Expression<String>? actionType,
    Expression<int>? localEventId,
    Expression<String>? googleEventId,
    Expression<String>? googleCalendarId,
    Expression<String>? payloadJson,
    Expression<String>? remoteETag,
    Expression<int>? retryCount,
    Expression<String>? lastError,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (clientMutationId != null) 'client_mutation_id': clientMutationId,
      if (actionType != null) 'action_type': actionType,
      if (localEventId != null) 'local_event_id': localEventId,
      if (googleEventId != null) 'google_event_id': googleEventId,
      if (googleCalendarId != null) 'google_calendar_id': googleCalendarId,
      if (payloadJson != null) 'payload_json': payloadJson,
      if (remoteETag != null) 'remote_e_tag': remoteETag,
      if (retryCount != null) 'retry_count': retryCount,
      if (lastError != null) 'last_error': lastError,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  CalendarOutboxCompanion copyWith({
    Value<int>? id,
    Value<String>? clientMutationId,
    Value<String>? actionType,
    Value<int?>? localEventId,
    Value<String?>? googleEventId,
    Value<String>? googleCalendarId,
    Value<String>? payloadJson,
    Value<String?>? remoteETag,
    Value<int>? retryCount,
    Value<String?>? lastError,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
  }) {
    return CalendarOutboxCompanion(
      id: id ?? this.id,
      clientMutationId: clientMutationId ?? this.clientMutationId,
      actionType: actionType ?? this.actionType,
      localEventId: localEventId ?? this.localEventId,
      googleEventId: googleEventId ?? this.googleEventId,
      googleCalendarId: googleCalendarId ?? this.googleCalendarId,
      payloadJson: payloadJson ?? this.payloadJson,
      remoteETag: remoteETag ?? this.remoteETag,
      retryCount: retryCount ?? this.retryCount,
      lastError: lastError ?? this.lastError,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (clientMutationId.present) {
      map['client_mutation_id'] = Variable<String>(clientMutationId.value);
    }
    if (actionType.present) {
      map['action_type'] = Variable<String>(actionType.value);
    }
    if (localEventId.present) {
      map['local_event_id'] = Variable<int>(localEventId.value);
    }
    if (googleEventId.present) {
      map['google_event_id'] = Variable<String>(googleEventId.value);
    }
    if (googleCalendarId.present) {
      map['google_calendar_id'] = Variable<String>(googleCalendarId.value);
    }
    if (payloadJson.present) {
      map['payload_json'] = Variable<String>(payloadJson.value);
    }
    if (remoteETag.present) {
      map['remote_e_tag'] = Variable<String>(remoteETag.value);
    }
    if (retryCount.present) {
      map['retry_count'] = Variable<int>(retryCount.value);
    }
    if (lastError.present) {
      map['last_error'] = Variable<String>(lastError.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CalendarOutboxCompanion(')
          ..write('id: $id, ')
          ..write('clientMutationId: $clientMutationId, ')
          ..write('actionType: $actionType, ')
          ..write('localEventId: $localEventId, ')
          ..write('googleEventId: $googleEventId, ')
          ..write('googleCalendarId: $googleCalendarId, ')
          ..write('payloadJson: $payloadJson, ')
          ..write('remoteETag: $remoteETag, ')
          ..write('retryCount: $retryCount, ')
          ..write('lastError: $lastError, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $SyncConflictsTable extends SyncConflicts
    with TableInfo<$SyncConflictsTable, SyncConflictEntity> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SyncConflictsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _googleEventIdMeta = const VerificationMeta(
    'googleEventId',
  );
  @override
  late final GeneratedColumn<String> googleEventId = GeneratedColumn<String>(
    'google_event_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _googleCalendarIdMeta = const VerificationMeta(
    'googleCalendarId',
  );
  @override
  late final GeneratedColumn<String> googleCalendarId = GeneratedColumn<String>(
    'google_calendar_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _eventTitleMeta = const VerificationMeta(
    'eventTitle',
  );
  @override
  late final GeneratedColumn<String> eventTitle = GeneratedColumn<String>(
    'event_title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _localPayloadJsonMeta = const VerificationMeta(
    'localPayloadJson',
  );
  @override
  late final GeneratedColumn<String> localPayloadJson = GeneratedColumn<String>(
    'local_payload_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _remotePayloadJsonMeta = const VerificationMeta(
    'remotePayloadJson',
  );
  @override
  late final GeneratedColumn<String> remotePayloadJson =
      GeneratedColumn<String>(
        'remote_payload_json',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _conflictReasonMeta = const VerificationMeta(
    'conflictReason',
  );
  @override
  late final GeneratedColumn<String> conflictReason = GeneratedColumn<String>(
    'conflict_reason',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('Remote event was modified while offline'),
  );
  static const VerificationMeta _resolvedAtMeta = const VerificationMeta(
    'resolvedAt',
  );
  @override
  late final GeneratedColumn<DateTime> resolvedAt = GeneratedColumn<DateTime>(
    'resolved_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _isDismissedMeta = const VerificationMeta(
    'isDismissed',
  );
  @override
  late final GeneratedColumn<bool> isDismissed = GeneratedColumn<bool>(
    'is_dismissed',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_dismissed" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    googleEventId,
    googleCalendarId,
    eventTitle,
    localPayloadJson,
    remotePayloadJson,
    conflictReason,
    resolvedAt,
    isDismissed,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sync_conflicts';
  @override
  VerificationContext validateIntegrity(
    Insertable<SyncConflictEntity> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('google_event_id')) {
      context.handle(
        _googleEventIdMeta,
        googleEventId.isAcceptableOrUnknown(
          data['google_event_id']!,
          _googleEventIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_googleEventIdMeta);
    }
    if (data.containsKey('google_calendar_id')) {
      context.handle(
        _googleCalendarIdMeta,
        googleCalendarId.isAcceptableOrUnknown(
          data['google_calendar_id']!,
          _googleCalendarIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_googleCalendarIdMeta);
    }
    if (data.containsKey('event_title')) {
      context.handle(
        _eventTitleMeta,
        eventTitle.isAcceptableOrUnknown(data['event_title']!, _eventTitleMeta),
      );
    } else if (isInserting) {
      context.missing(_eventTitleMeta);
    }
    if (data.containsKey('local_payload_json')) {
      context.handle(
        _localPayloadJsonMeta,
        localPayloadJson.isAcceptableOrUnknown(
          data['local_payload_json']!,
          _localPayloadJsonMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_localPayloadJsonMeta);
    }
    if (data.containsKey('remote_payload_json')) {
      context.handle(
        _remotePayloadJsonMeta,
        remotePayloadJson.isAcceptableOrUnknown(
          data['remote_payload_json']!,
          _remotePayloadJsonMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_remotePayloadJsonMeta);
    }
    if (data.containsKey('conflict_reason')) {
      context.handle(
        _conflictReasonMeta,
        conflictReason.isAcceptableOrUnknown(
          data['conflict_reason']!,
          _conflictReasonMeta,
        ),
      );
    }
    if (data.containsKey('resolved_at')) {
      context.handle(
        _resolvedAtMeta,
        resolvedAt.isAcceptableOrUnknown(data['resolved_at']!, _resolvedAtMeta),
      );
    }
    if (data.containsKey('is_dismissed')) {
      context.handle(
        _isDismissedMeta,
        isDismissed.isAcceptableOrUnknown(
          data['is_dismissed']!,
          _isDismissedMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SyncConflictEntity map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SyncConflictEntity(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      googleEventId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}google_event_id'],
      )!,
      googleCalendarId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}google_calendar_id'],
      )!,
      eventTitle: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}event_title'],
      )!,
      localPayloadJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}local_payload_json'],
      )!,
      remotePayloadJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}remote_payload_json'],
      )!,
      conflictReason: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}conflict_reason'],
      )!,
      resolvedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}resolved_at'],
      )!,
      isDismissed: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_dismissed'],
      )!,
    );
  }

  @override
  $SyncConflictsTable createAlias(String alias) {
    return $SyncConflictsTable(attachedDatabase, alias);
  }
}

class SyncConflictEntity extends DataClass
    implements Insertable<SyncConflictEntity> {
  final int id;
  final String googleEventId;
  final String googleCalendarId;
  final String eventTitle;

  /// The rejected offline user edit payload in JSON.
  final String localPayloadJson;

  /// The authoritative server version kept in JSON.
  final String remotePayloadJson;
  final String conflictReason;
  final DateTime resolvedAt;
  final bool isDismissed;
  const SyncConflictEntity({
    required this.id,
    required this.googleEventId,
    required this.googleCalendarId,
    required this.eventTitle,
    required this.localPayloadJson,
    required this.remotePayloadJson,
    required this.conflictReason,
    required this.resolvedAt,
    required this.isDismissed,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['google_event_id'] = Variable<String>(googleEventId);
    map['google_calendar_id'] = Variable<String>(googleCalendarId);
    map['event_title'] = Variable<String>(eventTitle);
    map['local_payload_json'] = Variable<String>(localPayloadJson);
    map['remote_payload_json'] = Variable<String>(remotePayloadJson);
    map['conflict_reason'] = Variable<String>(conflictReason);
    map['resolved_at'] = Variable<DateTime>(resolvedAt);
    map['is_dismissed'] = Variable<bool>(isDismissed);
    return map;
  }

  SyncConflictsCompanion toCompanion(bool nullToAbsent) {
    return SyncConflictsCompanion(
      id: Value(id),
      googleEventId: Value(googleEventId),
      googleCalendarId: Value(googleCalendarId),
      eventTitle: Value(eventTitle),
      localPayloadJson: Value(localPayloadJson),
      remotePayloadJson: Value(remotePayloadJson),
      conflictReason: Value(conflictReason),
      resolvedAt: Value(resolvedAt),
      isDismissed: Value(isDismissed),
    );
  }

  factory SyncConflictEntity.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SyncConflictEntity(
      id: serializer.fromJson<int>(json['id']),
      googleEventId: serializer.fromJson<String>(json['googleEventId']),
      googleCalendarId: serializer.fromJson<String>(json['googleCalendarId']),
      eventTitle: serializer.fromJson<String>(json['eventTitle']),
      localPayloadJson: serializer.fromJson<String>(json['localPayloadJson']),
      remotePayloadJson: serializer.fromJson<String>(json['remotePayloadJson']),
      conflictReason: serializer.fromJson<String>(json['conflictReason']),
      resolvedAt: serializer.fromJson<DateTime>(json['resolvedAt']),
      isDismissed: serializer.fromJson<bool>(json['isDismissed']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'googleEventId': serializer.toJson<String>(googleEventId),
      'googleCalendarId': serializer.toJson<String>(googleCalendarId),
      'eventTitle': serializer.toJson<String>(eventTitle),
      'localPayloadJson': serializer.toJson<String>(localPayloadJson),
      'remotePayloadJson': serializer.toJson<String>(remotePayloadJson),
      'conflictReason': serializer.toJson<String>(conflictReason),
      'resolvedAt': serializer.toJson<DateTime>(resolvedAt),
      'isDismissed': serializer.toJson<bool>(isDismissed),
    };
  }

  SyncConflictEntity copyWith({
    int? id,
    String? googleEventId,
    String? googleCalendarId,
    String? eventTitle,
    String? localPayloadJson,
    String? remotePayloadJson,
    String? conflictReason,
    DateTime? resolvedAt,
    bool? isDismissed,
  }) => SyncConflictEntity(
    id: id ?? this.id,
    googleEventId: googleEventId ?? this.googleEventId,
    googleCalendarId: googleCalendarId ?? this.googleCalendarId,
    eventTitle: eventTitle ?? this.eventTitle,
    localPayloadJson: localPayloadJson ?? this.localPayloadJson,
    remotePayloadJson: remotePayloadJson ?? this.remotePayloadJson,
    conflictReason: conflictReason ?? this.conflictReason,
    resolvedAt: resolvedAt ?? this.resolvedAt,
    isDismissed: isDismissed ?? this.isDismissed,
  );
  SyncConflictEntity copyWithCompanion(SyncConflictsCompanion data) {
    return SyncConflictEntity(
      id: data.id.present ? data.id.value : this.id,
      googleEventId: data.googleEventId.present
          ? data.googleEventId.value
          : this.googleEventId,
      googleCalendarId: data.googleCalendarId.present
          ? data.googleCalendarId.value
          : this.googleCalendarId,
      eventTitle: data.eventTitle.present
          ? data.eventTitle.value
          : this.eventTitle,
      localPayloadJson: data.localPayloadJson.present
          ? data.localPayloadJson.value
          : this.localPayloadJson,
      remotePayloadJson: data.remotePayloadJson.present
          ? data.remotePayloadJson.value
          : this.remotePayloadJson,
      conflictReason: data.conflictReason.present
          ? data.conflictReason.value
          : this.conflictReason,
      resolvedAt: data.resolvedAt.present
          ? data.resolvedAt.value
          : this.resolvedAt,
      isDismissed: data.isDismissed.present
          ? data.isDismissed.value
          : this.isDismissed,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SyncConflictEntity(')
          ..write('id: $id, ')
          ..write('googleEventId: $googleEventId, ')
          ..write('googleCalendarId: $googleCalendarId, ')
          ..write('eventTitle: $eventTitle, ')
          ..write('localPayloadJson: $localPayloadJson, ')
          ..write('remotePayloadJson: $remotePayloadJson, ')
          ..write('conflictReason: $conflictReason, ')
          ..write('resolvedAt: $resolvedAt, ')
          ..write('isDismissed: $isDismissed')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    googleEventId,
    googleCalendarId,
    eventTitle,
    localPayloadJson,
    remotePayloadJson,
    conflictReason,
    resolvedAt,
    isDismissed,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SyncConflictEntity &&
          other.id == this.id &&
          other.googleEventId == this.googleEventId &&
          other.googleCalendarId == this.googleCalendarId &&
          other.eventTitle == this.eventTitle &&
          other.localPayloadJson == this.localPayloadJson &&
          other.remotePayloadJson == this.remotePayloadJson &&
          other.conflictReason == this.conflictReason &&
          other.resolvedAt == this.resolvedAt &&
          other.isDismissed == this.isDismissed);
}

class SyncConflictsCompanion extends UpdateCompanion<SyncConflictEntity> {
  final Value<int> id;
  final Value<String> googleEventId;
  final Value<String> googleCalendarId;
  final Value<String> eventTitle;
  final Value<String> localPayloadJson;
  final Value<String> remotePayloadJson;
  final Value<String> conflictReason;
  final Value<DateTime> resolvedAt;
  final Value<bool> isDismissed;
  const SyncConflictsCompanion({
    this.id = const Value.absent(),
    this.googleEventId = const Value.absent(),
    this.googleCalendarId = const Value.absent(),
    this.eventTitle = const Value.absent(),
    this.localPayloadJson = const Value.absent(),
    this.remotePayloadJson = const Value.absent(),
    this.conflictReason = const Value.absent(),
    this.resolvedAt = const Value.absent(),
    this.isDismissed = const Value.absent(),
  });
  SyncConflictsCompanion.insert({
    this.id = const Value.absent(),
    required String googleEventId,
    required String googleCalendarId,
    required String eventTitle,
    required String localPayloadJson,
    required String remotePayloadJson,
    this.conflictReason = const Value.absent(),
    this.resolvedAt = const Value.absent(),
    this.isDismissed = const Value.absent(),
  }) : googleEventId = Value(googleEventId),
       googleCalendarId = Value(googleCalendarId),
       eventTitle = Value(eventTitle),
       localPayloadJson = Value(localPayloadJson),
       remotePayloadJson = Value(remotePayloadJson);
  static Insertable<SyncConflictEntity> custom({
    Expression<int>? id,
    Expression<String>? googleEventId,
    Expression<String>? googleCalendarId,
    Expression<String>? eventTitle,
    Expression<String>? localPayloadJson,
    Expression<String>? remotePayloadJson,
    Expression<String>? conflictReason,
    Expression<DateTime>? resolvedAt,
    Expression<bool>? isDismissed,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (googleEventId != null) 'google_event_id': googleEventId,
      if (googleCalendarId != null) 'google_calendar_id': googleCalendarId,
      if (eventTitle != null) 'event_title': eventTitle,
      if (localPayloadJson != null) 'local_payload_json': localPayloadJson,
      if (remotePayloadJson != null) 'remote_payload_json': remotePayloadJson,
      if (conflictReason != null) 'conflict_reason': conflictReason,
      if (resolvedAt != null) 'resolved_at': resolvedAt,
      if (isDismissed != null) 'is_dismissed': isDismissed,
    });
  }

  SyncConflictsCompanion copyWith({
    Value<int>? id,
    Value<String>? googleEventId,
    Value<String>? googleCalendarId,
    Value<String>? eventTitle,
    Value<String>? localPayloadJson,
    Value<String>? remotePayloadJson,
    Value<String>? conflictReason,
    Value<DateTime>? resolvedAt,
    Value<bool>? isDismissed,
  }) {
    return SyncConflictsCompanion(
      id: id ?? this.id,
      googleEventId: googleEventId ?? this.googleEventId,
      googleCalendarId: googleCalendarId ?? this.googleCalendarId,
      eventTitle: eventTitle ?? this.eventTitle,
      localPayloadJson: localPayloadJson ?? this.localPayloadJson,
      remotePayloadJson: remotePayloadJson ?? this.remotePayloadJson,
      conflictReason: conflictReason ?? this.conflictReason,
      resolvedAt: resolvedAt ?? this.resolvedAt,
      isDismissed: isDismissed ?? this.isDismissed,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (googleEventId.present) {
      map['google_event_id'] = Variable<String>(googleEventId.value);
    }
    if (googleCalendarId.present) {
      map['google_calendar_id'] = Variable<String>(googleCalendarId.value);
    }
    if (eventTitle.present) {
      map['event_title'] = Variable<String>(eventTitle.value);
    }
    if (localPayloadJson.present) {
      map['local_payload_json'] = Variable<String>(localPayloadJson.value);
    }
    if (remotePayloadJson.present) {
      map['remote_payload_json'] = Variable<String>(remotePayloadJson.value);
    }
    if (conflictReason.present) {
      map['conflict_reason'] = Variable<String>(conflictReason.value);
    }
    if (resolvedAt.present) {
      map['resolved_at'] = Variable<DateTime>(resolvedAt.value);
    }
    if (isDismissed.present) {
      map['is_dismissed'] = Variable<bool>(isDismissed.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SyncConflictsCompanion(')
          ..write('id: $id, ')
          ..write('googleEventId: $googleEventId, ')
          ..write('googleCalendarId: $googleCalendarId, ')
          ..write('eventTitle: $eventTitle, ')
          ..write('localPayloadJson: $localPayloadJson, ')
          ..write('remotePayloadJson: $remotePayloadJson, ')
          ..write('conflictReason: $conflictReason, ')
          ..write('resolvedAt: $resolvedAt, ')
          ..write('isDismissed: $isDismissed')
          ..write(')'))
        .toString();
  }
}

abstract class _$CalendarDatabase extends GeneratedDatabase {
  _$CalendarDatabase(QueryExecutor e) : super(e);
  $CalendarDatabaseManager get managers => $CalendarDatabaseManager(this);
  late final $CalendarAccountsTable calendarAccounts = $CalendarAccountsTable(
    this,
  );
  late final $CalendarsMetaTable calendarsMeta = $CalendarsMetaTable(this);
  late final $CalendarEventsTable calendarEvents = $CalendarEventsTable(this);
  late final $CalendarOutboxTable calendarOutbox = $CalendarOutboxTable(this);
  late final $SyncConflictsTable syncConflicts = $SyncConflictsTable(this);
  late final CalendarAccountsDao calendarAccountsDao = CalendarAccountsDao(
    this as CalendarDatabase,
  );
  late final CalendarsMetaDao calendarsMetaDao = CalendarsMetaDao(
    this as CalendarDatabase,
  );
  late final CalendarEventsDao calendarEventsDao = CalendarEventsDao(
    this as CalendarDatabase,
  );
  late final CalendarOutboxDao calendarOutboxDao = CalendarOutboxDao(
    this as CalendarDatabase,
  );
  late final SyncConflictsDao syncConflictsDao = SyncConflictsDao(
    this as CalendarDatabase,
  );
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    calendarAccounts,
    calendarsMeta,
    calendarEvents,
    calendarOutbox,
    syncConflicts,
  ];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules([
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'calendar_accounts',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('calendars_meta', kind: UpdateKind.delete)],
    ),
  ]);
}

typedef $$CalendarAccountsTableCreateCompanionBuilder =
    CalendarAccountsCompanion Function({
      Value<int> id,
      required String email,
      Value<String> displayName,
      Value<String?> photoUrl,
      Value<bool> needsReauth,
      Value<DateTime?> lastSyncTime,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
    });
typedef $$CalendarAccountsTableUpdateCompanionBuilder =
    CalendarAccountsCompanion Function({
      Value<int> id,
      Value<String> email,
      Value<String> displayName,
      Value<String?> photoUrl,
      Value<bool> needsReauth,
      Value<DateTime?> lastSyncTime,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
    });

final class $$CalendarAccountsTableReferences
    extends
        BaseReferences<
          _$CalendarDatabase,
          $CalendarAccountsTable,
          CalendarAccountEntity
        > {
  $$CalendarAccountsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static MultiTypedResultKey<$CalendarsMetaTable, List<CalendarMetaEntity>>
  _calendarsMetaRefsTable(_$CalendarDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.calendarsMeta,
        aliasName: 'calendar_accounts__email__calendars_meta__account_email',
      );

  $$CalendarsMetaTableProcessedTableManager get calendarsMetaRefs {
    final manager = $$CalendarsMetaTableTableManager($_db, $_db.calendarsMeta)
        .filter(
          (f) => f.accountEmail.email.sqlEquals($_itemColumn<String>('email')!),
        );

    final cache = $_typedResult.readTableOrNull(_calendarsMetaRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$CalendarAccountsTableFilterComposer
    extends Composer<_$CalendarDatabase, $CalendarAccountsTable> {
  $$CalendarAccountsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get email => $composableBuilder(
    column: $table.email,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get displayName => $composableBuilder(
    column: $table.displayName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get photoUrl => $composableBuilder(
    column: $table.photoUrl,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get needsReauth => $composableBuilder(
    column: $table.needsReauth,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastSyncTime => $composableBuilder(
    column: $table.lastSyncTime,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> calendarsMetaRefs(
    Expression<bool> Function($$CalendarsMetaTableFilterComposer f) f,
  ) {
    final $$CalendarsMetaTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.email,
      referencedTable: $db.calendarsMeta,
      getReferencedColumn: (t) => t.accountEmail,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CalendarsMetaTableFilterComposer(
            $db: $db,
            $table: $db.calendarsMeta,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$CalendarAccountsTableOrderingComposer
    extends Composer<_$CalendarDatabase, $CalendarAccountsTable> {
  $$CalendarAccountsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get email => $composableBuilder(
    column: $table.email,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get displayName => $composableBuilder(
    column: $table.displayName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get photoUrl => $composableBuilder(
    column: $table.photoUrl,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get needsReauth => $composableBuilder(
    column: $table.needsReauth,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastSyncTime => $composableBuilder(
    column: $table.lastSyncTime,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CalendarAccountsTableAnnotationComposer
    extends Composer<_$CalendarDatabase, $CalendarAccountsTable> {
  $$CalendarAccountsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get email =>
      $composableBuilder(column: $table.email, builder: (column) => column);

  GeneratedColumn<String> get displayName => $composableBuilder(
    column: $table.displayName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get photoUrl =>
      $composableBuilder(column: $table.photoUrl, builder: (column) => column);

  GeneratedColumn<bool> get needsReauth => $composableBuilder(
    column: $table.needsReauth,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get lastSyncTime => $composableBuilder(
    column: $table.lastSyncTime,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  Expression<T> calendarsMetaRefs<T extends Object>(
    Expression<T> Function($$CalendarsMetaTableAnnotationComposer a) f,
  ) {
    final $$CalendarsMetaTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.email,
      referencedTable: $db.calendarsMeta,
      getReferencedColumn: (t) => t.accountEmail,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CalendarsMetaTableAnnotationComposer(
            $db: $db,
            $table: $db.calendarsMeta,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$CalendarAccountsTableTableManager
    extends
        RootTableManager<
          _$CalendarDatabase,
          $CalendarAccountsTable,
          CalendarAccountEntity,
          $$CalendarAccountsTableFilterComposer,
          $$CalendarAccountsTableOrderingComposer,
          $$CalendarAccountsTableAnnotationComposer,
          $$CalendarAccountsTableCreateCompanionBuilder,
          $$CalendarAccountsTableUpdateCompanionBuilder,
          (CalendarAccountEntity, $$CalendarAccountsTableReferences),
          CalendarAccountEntity,
          PrefetchHooks Function({bool calendarsMetaRefs})
        > {
  $$CalendarAccountsTableTableManager(
    _$CalendarDatabase db,
    $CalendarAccountsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CalendarAccountsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CalendarAccountsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CalendarAccountsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> email = const Value.absent(),
                Value<String> displayName = const Value.absent(),
                Value<String?> photoUrl = const Value.absent(),
                Value<bool> needsReauth = const Value.absent(),
                Value<DateTime?> lastSyncTime = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => CalendarAccountsCompanion(
                id: id,
                email: email,
                displayName: displayName,
                photoUrl: photoUrl,
                needsReauth: needsReauth,
                lastSyncTime: lastSyncTime,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String email,
                Value<String> displayName = const Value.absent(),
                Value<String?> photoUrl = const Value.absent(),
                Value<bool> needsReauth = const Value.absent(),
                Value<DateTime?> lastSyncTime = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => CalendarAccountsCompanion.insert(
                id: id,
                email: email,
                displayName: displayName,
                photoUrl: photoUrl,
                needsReauth: needsReauth,
                lastSyncTime: lastSyncTime,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$CalendarAccountsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({calendarsMetaRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (calendarsMetaRefs) db.calendarsMeta,
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (calendarsMetaRefs)
                    await $_getPrefetchedData<
                      CalendarAccountEntity,
                      $CalendarAccountsTable,
                      CalendarMetaEntity
                    >(
                      currentTable: table,
                      referencedTable: $$CalendarAccountsTableReferences
                          ._calendarsMetaRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$CalendarAccountsTableReferences(
                            db,
                            table,
                            p0,
                          ).calendarsMetaRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where(
                            (e) => e.accountEmail == item.email,
                          ),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$CalendarAccountsTableProcessedTableManager =
    ProcessedTableManager<
      _$CalendarDatabase,
      $CalendarAccountsTable,
      CalendarAccountEntity,
      $$CalendarAccountsTableFilterComposer,
      $$CalendarAccountsTableOrderingComposer,
      $$CalendarAccountsTableAnnotationComposer,
      $$CalendarAccountsTableCreateCompanionBuilder,
      $$CalendarAccountsTableUpdateCompanionBuilder,
      (CalendarAccountEntity, $$CalendarAccountsTableReferences),
      CalendarAccountEntity,
      PrefetchHooks Function({bool calendarsMetaRefs})
    >;
typedef $$CalendarsMetaTableCreateCompanionBuilder =
    CalendarsMetaCompanion Function({
      Value<int> id,
      required String accountEmail,
      required String googleCalendarId,
      required String summary,
      Value<String> description,
      Value<String?> colorHex,
      Value<bool> isPrimary,
      Value<bool> isSelected,
      Value<String?> syncToken,
      Value<String> accessRole,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
    });
typedef $$CalendarsMetaTableUpdateCompanionBuilder =
    CalendarsMetaCompanion Function({
      Value<int> id,
      Value<String> accountEmail,
      Value<String> googleCalendarId,
      Value<String> summary,
      Value<String> description,
      Value<String?> colorHex,
      Value<bool> isPrimary,
      Value<bool> isSelected,
      Value<String?> syncToken,
      Value<String> accessRole,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
    });

final class $$CalendarsMetaTableReferences
    extends
        BaseReferences<
          _$CalendarDatabase,
          $CalendarsMetaTable,
          CalendarMetaEntity
        > {
  $$CalendarsMetaTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $CalendarAccountsTable _accountEmailTable(_$CalendarDatabase db) => db
      .calendarAccounts
      .createAlias('calendars_meta__account_email__calendar_accounts__email');

  $$CalendarAccountsTableProcessedTableManager get accountEmail {
    final $_column = $_itemColumn<String>('account_email')!;

    final manager = $$CalendarAccountsTableTableManager(
      $_db,
      $_db.calendarAccounts,
    ).filter((f) => f.email.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_accountEmailTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$CalendarsMetaTableFilterComposer
    extends Composer<_$CalendarDatabase, $CalendarsMetaTable> {
  $$CalendarsMetaTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get googleCalendarId => $composableBuilder(
    column: $table.googleCalendarId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get summary => $composableBuilder(
    column: $table.summary,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get colorHex => $composableBuilder(
    column: $table.colorHex,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isPrimary => $composableBuilder(
    column: $table.isPrimary,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isSelected => $composableBuilder(
    column: $table.isSelected,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get syncToken => $composableBuilder(
    column: $table.syncToken,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get accessRole => $composableBuilder(
    column: $table.accessRole,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$CalendarAccountsTableFilterComposer get accountEmail {
    final $$CalendarAccountsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.accountEmail,
      referencedTable: $db.calendarAccounts,
      getReferencedColumn: (t) => t.email,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CalendarAccountsTableFilterComposer(
            $db: $db,
            $table: $db.calendarAccounts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CalendarsMetaTableOrderingComposer
    extends Composer<_$CalendarDatabase, $CalendarsMetaTable> {
  $$CalendarsMetaTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get googleCalendarId => $composableBuilder(
    column: $table.googleCalendarId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get summary => $composableBuilder(
    column: $table.summary,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get colorHex => $composableBuilder(
    column: $table.colorHex,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isPrimary => $composableBuilder(
    column: $table.isPrimary,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isSelected => $composableBuilder(
    column: $table.isSelected,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get syncToken => $composableBuilder(
    column: $table.syncToken,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get accessRole => $composableBuilder(
    column: $table.accessRole,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$CalendarAccountsTableOrderingComposer get accountEmail {
    final $$CalendarAccountsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.accountEmail,
      referencedTable: $db.calendarAccounts,
      getReferencedColumn: (t) => t.email,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CalendarAccountsTableOrderingComposer(
            $db: $db,
            $table: $db.calendarAccounts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CalendarsMetaTableAnnotationComposer
    extends Composer<_$CalendarDatabase, $CalendarsMetaTable> {
  $$CalendarsMetaTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get googleCalendarId => $composableBuilder(
    column: $table.googleCalendarId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get summary =>
      $composableBuilder(column: $table.summary, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<String> get colorHex =>
      $composableBuilder(column: $table.colorHex, builder: (column) => column);

  GeneratedColumn<bool> get isPrimary =>
      $composableBuilder(column: $table.isPrimary, builder: (column) => column);

  GeneratedColumn<bool> get isSelected => $composableBuilder(
    column: $table.isSelected,
    builder: (column) => column,
  );

  GeneratedColumn<String> get syncToken =>
      $composableBuilder(column: $table.syncToken, builder: (column) => column);

  GeneratedColumn<String> get accessRole => $composableBuilder(
    column: $table.accessRole,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $$CalendarAccountsTableAnnotationComposer get accountEmail {
    final $$CalendarAccountsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.accountEmail,
      referencedTable: $db.calendarAccounts,
      getReferencedColumn: (t) => t.email,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CalendarAccountsTableAnnotationComposer(
            $db: $db,
            $table: $db.calendarAccounts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CalendarsMetaTableTableManager
    extends
        RootTableManager<
          _$CalendarDatabase,
          $CalendarsMetaTable,
          CalendarMetaEntity,
          $$CalendarsMetaTableFilterComposer,
          $$CalendarsMetaTableOrderingComposer,
          $$CalendarsMetaTableAnnotationComposer,
          $$CalendarsMetaTableCreateCompanionBuilder,
          $$CalendarsMetaTableUpdateCompanionBuilder,
          (CalendarMetaEntity, $$CalendarsMetaTableReferences),
          CalendarMetaEntity,
          PrefetchHooks Function({bool accountEmail})
        > {
  $$CalendarsMetaTableTableManager(
    _$CalendarDatabase db,
    $CalendarsMetaTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CalendarsMetaTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CalendarsMetaTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CalendarsMetaTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> accountEmail = const Value.absent(),
                Value<String> googleCalendarId = const Value.absent(),
                Value<String> summary = const Value.absent(),
                Value<String> description = const Value.absent(),
                Value<String?> colorHex = const Value.absent(),
                Value<bool> isPrimary = const Value.absent(),
                Value<bool> isSelected = const Value.absent(),
                Value<String?> syncToken = const Value.absent(),
                Value<String> accessRole = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => CalendarsMetaCompanion(
                id: id,
                accountEmail: accountEmail,
                googleCalendarId: googleCalendarId,
                summary: summary,
                description: description,
                colorHex: colorHex,
                isPrimary: isPrimary,
                isSelected: isSelected,
                syncToken: syncToken,
                accessRole: accessRole,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String accountEmail,
                required String googleCalendarId,
                required String summary,
                Value<String> description = const Value.absent(),
                Value<String?> colorHex = const Value.absent(),
                Value<bool> isPrimary = const Value.absent(),
                Value<bool> isSelected = const Value.absent(),
                Value<String?> syncToken = const Value.absent(),
                Value<String> accessRole = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => CalendarsMetaCompanion.insert(
                id: id,
                accountEmail: accountEmail,
                googleCalendarId: googleCalendarId,
                summary: summary,
                description: description,
                colorHex: colorHex,
                isPrimary: isPrimary,
                isSelected: isSelected,
                syncToken: syncToken,
                accessRole: accessRole,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$CalendarsMetaTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({accountEmail = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (accountEmail) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.accountEmail,
                                referencedTable: $$CalendarsMetaTableReferences
                                    ._accountEmailTable(db),
                                referencedColumn: $$CalendarsMetaTableReferences
                                    ._accountEmailTable(db)
                                    .email,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$CalendarsMetaTableProcessedTableManager =
    ProcessedTableManager<
      _$CalendarDatabase,
      $CalendarsMetaTable,
      CalendarMetaEntity,
      $$CalendarsMetaTableFilterComposer,
      $$CalendarsMetaTableOrderingComposer,
      $$CalendarsMetaTableAnnotationComposer,
      $$CalendarsMetaTableCreateCompanionBuilder,
      $$CalendarsMetaTableUpdateCompanionBuilder,
      (CalendarMetaEntity, $$CalendarsMetaTableReferences),
      CalendarMetaEntity,
      PrefetchHooks Function({bool accountEmail})
    >;
typedef $$CalendarEventsTableCreateCompanionBuilder =
    CalendarEventsCompanion Function({
      Value<int> id,
      Value<String?> googleEventId,
      required String googleCalendarId,
      required String title,
      Value<String> description,
      Value<String> location,
      Value<bool> isAllDay,
      Value<String?> startDate,
      Value<String?> endDate,
      Value<DateTime?> startDateTime,
      Value<DateTime?> endDateTime,
      Value<String> timeZone,
      Value<String?> recurrenceRule,
      Value<String?> recurringEventId,
      Value<String> syncStatus,
      Value<String?> remoteETag,
      Value<String?> clientMutationId,
      Value<String?> lastError,
      Value<DateTime> lastModified,
      Value<DateTime> createdAt,
    });
typedef $$CalendarEventsTableUpdateCompanionBuilder =
    CalendarEventsCompanion Function({
      Value<int> id,
      Value<String?> googleEventId,
      Value<String> googleCalendarId,
      Value<String> title,
      Value<String> description,
      Value<String> location,
      Value<bool> isAllDay,
      Value<String?> startDate,
      Value<String?> endDate,
      Value<DateTime?> startDateTime,
      Value<DateTime?> endDateTime,
      Value<String> timeZone,
      Value<String?> recurrenceRule,
      Value<String?> recurringEventId,
      Value<String> syncStatus,
      Value<String?> remoteETag,
      Value<String?> clientMutationId,
      Value<String?> lastError,
      Value<DateTime> lastModified,
      Value<DateTime> createdAt,
    });

class $$CalendarEventsTableFilterComposer
    extends Composer<_$CalendarDatabase, $CalendarEventsTable> {
  $$CalendarEventsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get googleEventId => $composableBuilder(
    column: $table.googleEventId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get googleCalendarId => $composableBuilder(
    column: $table.googleCalendarId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get location => $composableBuilder(
    column: $table.location,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isAllDay => $composableBuilder(
    column: $table.isAllDay,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get startDate => $composableBuilder(
    column: $table.startDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get endDate => $composableBuilder(
    column: $table.endDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get startDateTime => $composableBuilder(
    column: $table.startDateTime,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get endDateTime => $composableBuilder(
    column: $table.endDateTime,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get timeZone => $composableBuilder(
    column: $table.timeZone,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get recurrenceRule => $composableBuilder(
    column: $table.recurrenceRule,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get recurringEventId => $composableBuilder(
    column: $table.recurringEventId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get remoteETag => $composableBuilder(
    column: $table.remoteETag,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get clientMutationId => $composableBuilder(
    column: $table.clientMutationId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get lastError => $composableBuilder(
    column: $table.lastError,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastModified => $composableBuilder(
    column: $table.lastModified,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$CalendarEventsTableOrderingComposer
    extends Composer<_$CalendarDatabase, $CalendarEventsTable> {
  $$CalendarEventsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get googleEventId => $composableBuilder(
    column: $table.googleEventId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get googleCalendarId => $composableBuilder(
    column: $table.googleCalendarId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get location => $composableBuilder(
    column: $table.location,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isAllDay => $composableBuilder(
    column: $table.isAllDay,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get startDate => $composableBuilder(
    column: $table.startDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get endDate => $composableBuilder(
    column: $table.endDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get startDateTime => $composableBuilder(
    column: $table.startDateTime,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get endDateTime => $composableBuilder(
    column: $table.endDateTime,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get timeZone => $composableBuilder(
    column: $table.timeZone,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get recurrenceRule => $composableBuilder(
    column: $table.recurrenceRule,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get recurringEventId => $composableBuilder(
    column: $table.recurringEventId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get remoteETag => $composableBuilder(
    column: $table.remoteETag,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get clientMutationId => $composableBuilder(
    column: $table.clientMutationId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get lastError => $composableBuilder(
    column: $table.lastError,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastModified => $composableBuilder(
    column: $table.lastModified,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CalendarEventsTableAnnotationComposer
    extends Composer<_$CalendarDatabase, $CalendarEventsTable> {
  $$CalendarEventsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get googleEventId => $composableBuilder(
    column: $table.googleEventId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get googleCalendarId => $composableBuilder(
    column: $table.googleCalendarId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<String> get location =>
      $composableBuilder(column: $table.location, builder: (column) => column);

  GeneratedColumn<bool> get isAllDay =>
      $composableBuilder(column: $table.isAllDay, builder: (column) => column);

  GeneratedColumn<String> get startDate =>
      $composableBuilder(column: $table.startDate, builder: (column) => column);

  GeneratedColumn<String> get endDate =>
      $composableBuilder(column: $table.endDate, builder: (column) => column);

  GeneratedColumn<DateTime> get startDateTime => $composableBuilder(
    column: $table.startDateTime,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get endDateTime => $composableBuilder(
    column: $table.endDateTime,
    builder: (column) => column,
  );

  GeneratedColumn<String> get timeZone =>
      $composableBuilder(column: $table.timeZone, builder: (column) => column);

  GeneratedColumn<String> get recurrenceRule => $composableBuilder(
    column: $table.recurrenceRule,
    builder: (column) => column,
  );

  GeneratedColumn<String> get recurringEventId => $composableBuilder(
    column: $table.recurringEventId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => column,
  );

  GeneratedColumn<String> get remoteETag => $composableBuilder(
    column: $table.remoteETag,
    builder: (column) => column,
  );

  GeneratedColumn<String> get clientMutationId => $composableBuilder(
    column: $table.clientMutationId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get lastError =>
      $composableBuilder(column: $table.lastError, builder: (column) => column);

  GeneratedColumn<DateTime> get lastModified => $composableBuilder(
    column: $table.lastModified,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$CalendarEventsTableTableManager
    extends
        RootTableManager<
          _$CalendarDatabase,
          $CalendarEventsTable,
          CalendarEventEntity,
          $$CalendarEventsTableFilterComposer,
          $$CalendarEventsTableOrderingComposer,
          $$CalendarEventsTableAnnotationComposer,
          $$CalendarEventsTableCreateCompanionBuilder,
          $$CalendarEventsTableUpdateCompanionBuilder,
          (
            CalendarEventEntity,
            BaseReferences<
              _$CalendarDatabase,
              $CalendarEventsTable,
              CalendarEventEntity
            >,
          ),
          CalendarEventEntity,
          PrefetchHooks Function()
        > {
  $$CalendarEventsTableTableManager(
    _$CalendarDatabase db,
    $CalendarEventsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CalendarEventsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CalendarEventsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CalendarEventsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String?> googleEventId = const Value.absent(),
                Value<String> googleCalendarId = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String> description = const Value.absent(),
                Value<String> location = const Value.absent(),
                Value<bool> isAllDay = const Value.absent(),
                Value<String?> startDate = const Value.absent(),
                Value<String?> endDate = const Value.absent(),
                Value<DateTime?> startDateTime = const Value.absent(),
                Value<DateTime?> endDateTime = const Value.absent(),
                Value<String> timeZone = const Value.absent(),
                Value<String?> recurrenceRule = const Value.absent(),
                Value<String?> recurringEventId = const Value.absent(),
                Value<String> syncStatus = const Value.absent(),
                Value<String?> remoteETag = const Value.absent(),
                Value<String?> clientMutationId = const Value.absent(),
                Value<String?> lastError = const Value.absent(),
                Value<DateTime> lastModified = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => CalendarEventsCompanion(
                id: id,
                googleEventId: googleEventId,
                googleCalendarId: googleCalendarId,
                title: title,
                description: description,
                location: location,
                isAllDay: isAllDay,
                startDate: startDate,
                endDate: endDate,
                startDateTime: startDateTime,
                endDateTime: endDateTime,
                timeZone: timeZone,
                recurrenceRule: recurrenceRule,
                recurringEventId: recurringEventId,
                syncStatus: syncStatus,
                remoteETag: remoteETag,
                clientMutationId: clientMutationId,
                lastError: lastError,
                lastModified: lastModified,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String?> googleEventId = const Value.absent(),
                required String googleCalendarId,
                required String title,
                Value<String> description = const Value.absent(),
                Value<String> location = const Value.absent(),
                Value<bool> isAllDay = const Value.absent(),
                Value<String?> startDate = const Value.absent(),
                Value<String?> endDate = const Value.absent(),
                Value<DateTime?> startDateTime = const Value.absent(),
                Value<DateTime?> endDateTime = const Value.absent(),
                Value<String> timeZone = const Value.absent(),
                Value<String?> recurrenceRule = const Value.absent(),
                Value<String?> recurringEventId = const Value.absent(),
                Value<String> syncStatus = const Value.absent(),
                Value<String?> remoteETag = const Value.absent(),
                Value<String?> clientMutationId = const Value.absent(),
                Value<String?> lastError = const Value.absent(),
                Value<DateTime> lastModified = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => CalendarEventsCompanion.insert(
                id: id,
                googleEventId: googleEventId,
                googleCalendarId: googleCalendarId,
                title: title,
                description: description,
                location: location,
                isAllDay: isAllDay,
                startDate: startDate,
                endDate: endDate,
                startDateTime: startDateTime,
                endDateTime: endDateTime,
                timeZone: timeZone,
                recurrenceRule: recurrenceRule,
                recurringEventId: recurringEventId,
                syncStatus: syncStatus,
                remoteETag: remoteETag,
                clientMutationId: clientMutationId,
                lastError: lastError,
                lastModified: lastModified,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$CalendarEventsTableProcessedTableManager =
    ProcessedTableManager<
      _$CalendarDatabase,
      $CalendarEventsTable,
      CalendarEventEntity,
      $$CalendarEventsTableFilterComposer,
      $$CalendarEventsTableOrderingComposer,
      $$CalendarEventsTableAnnotationComposer,
      $$CalendarEventsTableCreateCompanionBuilder,
      $$CalendarEventsTableUpdateCompanionBuilder,
      (
        CalendarEventEntity,
        BaseReferences<
          _$CalendarDatabase,
          $CalendarEventsTable,
          CalendarEventEntity
        >,
      ),
      CalendarEventEntity,
      PrefetchHooks Function()
    >;
typedef $$CalendarOutboxTableCreateCompanionBuilder =
    CalendarOutboxCompanion Function({
      Value<int> id,
      required String clientMutationId,
      required String actionType,
      Value<int?> localEventId,
      Value<String?> googleEventId,
      required String googleCalendarId,
      required String payloadJson,
      Value<String?> remoteETag,
      Value<int> retryCount,
      Value<String?> lastError,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
    });
typedef $$CalendarOutboxTableUpdateCompanionBuilder =
    CalendarOutboxCompanion Function({
      Value<int> id,
      Value<String> clientMutationId,
      Value<String> actionType,
      Value<int?> localEventId,
      Value<String?> googleEventId,
      Value<String> googleCalendarId,
      Value<String> payloadJson,
      Value<String?> remoteETag,
      Value<int> retryCount,
      Value<String?> lastError,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
    });

class $$CalendarOutboxTableFilterComposer
    extends Composer<_$CalendarDatabase, $CalendarOutboxTable> {
  $$CalendarOutboxTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get clientMutationId => $composableBuilder(
    column: $table.clientMutationId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get actionType => $composableBuilder(
    column: $table.actionType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get localEventId => $composableBuilder(
    column: $table.localEventId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get googleEventId => $composableBuilder(
    column: $table.googleEventId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get googleCalendarId => $composableBuilder(
    column: $table.googleCalendarId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get payloadJson => $composableBuilder(
    column: $table.payloadJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get remoteETag => $composableBuilder(
    column: $table.remoteETag,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get retryCount => $composableBuilder(
    column: $table.retryCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get lastError => $composableBuilder(
    column: $table.lastError,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$CalendarOutboxTableOrderingComposer
    extends Composer<_$CalendarDatabase, $CalendarOutboxTable> {
  $$CalendarOutboxTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get clientMutationId => $composableBuilder(
    column: $table.clientMutationId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get actionType => $composableBuilder(
    column: $table.actionType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get localEventId => $composableBuilder(
    column: $table.localEventId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get googleEventId => $composableBuilder(
    column: $table.googleEventId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get googleCalendarId => $composableBuilder(
    column: $table.googleCalendarId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get payloadJson => $composableBuilder(
    column: $table.payloadJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get remoteETag => $composableBuilder(
    column: $table.remoteETag,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get retryCount => $composableBuilder(
    column: $table.retryCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get lastError => $composableBuilder(
    column: $table.lastError,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CalendarOutboxTableAnnotationComposer
    extends Composer<_$CalendarDatabase, $CalendarOutboxTable> {
  $$CalendarOutboxTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get clientMutationId => $composableBuilder(
    column: $table.clientMutationId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get actionType => $composableBuilder(
    column: $table.actionType,
    builder: (column) => column,
  );

  GeneratedColumn<int> get localEventId => $composableBuilder(
    column: $table.localEventId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get googleEventId => $composableBuilder(
    column: $table.googleEventId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get googleCalendarId => $composableBuilder(
    column: $table.googleCalendarId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get payloadJson => $composableBuilder(
    column: $table.payloadJson,
    builder: (column) => column,
  );

  GeneratedColumn<String> get remoteETag => $composableBuilder(
    column: $table.remoteETag,
    builder: (column) => column,
  );

  GeneratedColumn<int> get retryCount => $composableBuilder(
    column: $table.retryCount,
    builder: (column) => column,
  );

  GeneratedColumn<String> get lastError =>
      $composableBuilder(column: $table.lastError, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$CalendarOutboxTableTableManager
    extends
        RootTableManager<
          _$CalendarDatabase,
          $CalendarOutboxTable,
          CalendarOutboxEntity,
          $$CalendarOutboxTableFilterComposer,
          $$CalendarOutboxTableOrderingComposer,
          $$CalendarOutboxTableAnnotationComposer,
          $$CalendarOutboxTableCreateCompanionBuilder,
          $$CalendarOutboxTableUpdateCompanionBuilder,
          (
            CalendarOutboxEntity,
            BaseReferences<
              _$CalendarDatabase,
              $CalendarOutboxTable,
              CalendarOutboxEntity
            >,
          ),
          CalendarOutboxEntity,
          PrefetchHooks Function()
        > {
  $$CalendarOutboxTableTableManager(
    _$CalendarDatabase db,
    $CalendarOutboxTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CalendarOutboxTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CalendarOutboxTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CalendarOutboxTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> clientMutationId = const Value.absent(),
                Value<String> actionType = const Value.absent(),
                Value<int?> localEventId = const Value.absent(),
                Value<String?> googleEventId = const Value.absent(),
                Value<String> googleCalendarId = const Value.absent(),
                Value<String> payloadJson = const Value.absent(),
                Value<String?> remoteETag = const Value.absent(),
                Value<int> retryCount = const Value.absent(),
                Value<String?> lastError = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => CalendarOutboxCompanion(
                id: id,
                clientMutationId: clientMutationId,
                actionType: actionType,
                localEventId: localEventId,
                googleEventId: googleEventId,
                googleCalendarId: googleCalendarId,
                payloadJson: payloadJson,
                remoteETag: remoteETag,
                retryCount: retryCount,
                lastError: lastError,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String clientMutationId,
                required String actionType,
                Value<int?> localEventId = const Value.absent(),
                Value<String?> googleEventId = const Value.absent(),
                required String googleCalendarId,
                required String payloadJson,
                Value<String?> remoteETag = const Value.absent(),
                Value<int> retryCount = const Value.absent(),
                Value<String?> lastError = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => CalendarOutboxCompanion.insert(
                id: id,
                clientMutationId: clientMutationId,
                actionType: actionType,
                localEventId: localEventId,
                googleEventId: googleEventId,
                googleCalendarId: googleCalendarId,
                payloadJson: payloadJson,
                remoteETag: remoteETag,
                retryCount: retryCount,
                lastError: lastError,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$CalendarOutboxTableProcessedTableManager =
    ProcessedTableManager<
      _$CalendarDatabase,
      $CalendarOutboxTable,
      CalendarOutboxEntity,
      $$CalendarOutboxTableFilterComposer,
      $$CalendarOutboxTableOrderingComposer,
      $$CalendarOutboxTableAnnotationComposer,
      $$CalendarOutboxTableCreateCompanionBuilder,
      $$CalendarOutboxTableUpdateCompanionBuilder,
      (
        CalendarOutboxEntity,
        BaseReferences<
          _$CalendarDatabase,
          $CalendarOutboxTable,
          CalendarOutboxEntity
        >,
      ),
      CalendarOutboxEntity,
      PrefetchHooks Function()
    >;
typedef $$SyncConflictsTableCreateCompanionBuilder =
    SyncConflictsCompanion Function({
      Value<int> id,
      required String googleEventId,
      required String googleCalendarId,
      required String eventTitle,
      required String localPayloadJson,
      required String remotePayloadJson,
      Value<String> conflictReason,
      Value<DateTime> resolvedAt,
      Value<bool> isDismissed,
    });
typedef $$SyncConflictsTableUpdateCompanionBuilder =
    SyncConflictsCompanion Function({
      Value<int> id,
      Value<String> googleEventId,
      Value<String> googleCalendarId,
      Value<String> eventTitle,
      Value<String> localPayloadJson,
      Value<String> remotePayloadJson,
      Value<String> conflictReason,
      Value<DateTime> resolvedAt,
      Value<bool> isDismissed,
    });

class $$SyncConflictsTableFilterComposer
    extends Composer<_$CalendarDatabase, $SyncConflictsTable> {
  $$SyncConflictsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get googleEventId => $composableBuilder(
    column: $table.googleEventId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get googleCalendarId => $composableBuilder(
    column: $table.googleCalendarId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get eventTitle => $composableBuilder(
    column: $table.eventTitle,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get localPayloadJson => $composableBuilder(
    column: $table.localPayloadJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get remotePayloadJson => $composableBuilder(
    column: $table.remotePayloadJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get conflictReason => $composableBuilder(
    column: $table.conflictReason,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get resolvedAt => $composableBuilder(
    column: $table.resolvedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isDismissed => $composableBuilder(
    column: $table.isDismissed,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SyncConflictsTableOrderingComposer
    extends Composer<_$CalendarDatabase, $SyncConflictsTable> {
  $$SyncConflictsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get googleEventId => $composableBuilder(
    column: $table.googleEventId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get googleCalendarId => $composableBuilder(
    column: $table.googleCalendarId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get eventTitle => $composableBuilder(
    column: $table.eventTitle,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get localPayloadJson => $composableBuilder(
    column: $table.localPayloadJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get remotePayloadJson => $composableBuilder(
    column: $table.remotePayloadJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get conflictReason => $composableBuilder(
    column: $table.conflictReason,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get resolvedAt => $composableBuilder(
    column: $table.resolvedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isDismissed => $composableBuilder(
    column: $table.isDismissed,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SyncConflictsTableAnnotationComposer
    extends Composer<_$CalendarDatabase, $SyncConflictsTable> {
  $$SyncConflictsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get googleEventId => $composableBuilder(
    column: $table.googleEventId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get googleCalendarId => $composableBuilder(
    column: $table.googleCalendarId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get eventTitle => $composableBuilder(
    column: $table.eventTitle,
    builder: (column) => column,
  );

  GeneratedColumn<String> get localPayloadJson => $composableBuilder(
    column: $table.localPayloadJson,
    builder: (column) => column,
  );

  GeneratedColumn<String> get remotePayloadJson => $composableBuilder(
    column: $table.remotePayloadJson,
    builder: (column) => column,
  );

  GeneratedColumn<String> get conflictReason => $composableBuilder(
    column: $table.conflictReason,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get resolvedAt => $composableBuilder(
    column: $table.resolvedAt,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isDismissed => $composableBuilder(
    column: $table.isDismissed,
    builder: (column) => column,
  );
}

class $$SyncConflictsTableTableManager
    extends
        RootTableManager<
          _$CalendarDatabase,
          $SyncConflictsTable,
          SyncConflictEntity,
          $$SyncConflictsTableFilterComposer,
          $$SyncConflictsTableOrderingComposer,
          $$SyncConflictsTableAnnotationComposer,
          $$SyncConflictsTableCreateCompanionBuilder,
          $$SyncConflictsTableUpdateCompanionBuilder,
          (
            SyncConflictEntity,
            BaseReferences<
              _$CalendarDatabase,
              $SyncConflictsTable,
              SyncConflictEntity
            >,
          ),
          SyncConflictEntity,
          PrefetchHooks Function()
        > {
  $$SyncConflictsTableTableManager(
    _$CalendarDatabase db,
    $SyncConflictsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SyncConflictsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SyncConflictsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SyncConflictsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> googleEventId = const Value.absent(),
                Value<String> googleCalendarId = const Value.absent(),
                Value<String> eventTitle = const Value.absent(),
                Value<String> localPayloadJson = const Value.absent(),
                Value<String> remotePayloadJson = const Value.absent(),
                Value<String> conflictReason = const Value.absent(),
                Value<DateTime> resolvedAt = const Value.absent(),
                Value<bool> isDismissed = const Value.absent(),
              }) => SyncConflictsCompanion(
                id: id,
                googleEventId: googleEventId,
                googleCalendarId: googleCalendarId,
                eventTitle: eventTitle,
                localPayloadJson: localPayloadJson,
                remotePayloadJson: remotePayloadJson,
                conflictReason: conflictReason,
                resolvedAt: resolvedAt,
                isDismissed: isDismissed,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String googleEventId,
                required String googleCalendarId,
                required String eventTitle,
                required String localPayloadJson,
                required String remotePayloadJson,
                Value<String> conflictReason = const Value.absent(),
                Value<DateTime> resolvedAt = const Value.absent(),
                Value<bool> isDismissed = const Value.absent(),
              }) => SyncConflictsCompanion.insert(
                id: id,
                googleEventId: googleEventId,
                googleCalendarId: googleCalendarId,
                eventTitle: eventTitle,
                localPayloadJson: localPayloadJson,
                remotePayloadJson: remotePayloadJson,
                conflictReason: conflictReason,
                resolvedAt: resolvedAt,
                isDismissed: isDismissed,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SyncConflictsTableProcessedTableManager =
    ProcessedTableManager<
      _$CalendarDatabase,
      $SyncConflictsTable,
      SyncConflictEntity,
      $$SyncConflictsTableFilterComposer,
      $$SyncConflictsTableOrderingComposer,
      $$SyncConflictsTableAnnotationComposer,
      $$SyncConflictsTableCreateCompanionBuilder,
      $$SyncConflictsTableUpdateCompanionBuilder,
      (
        SyncConflictEntity,
        BaseReferences<
          _$CalendarDatabase,
          $SyncConflictsTable,
          SyncConflictEntity
        >,
      ),
      SyncConflictEntity,
      PrefetchHooks Function()
    >;

class $CalendarDatabaseManager {
  final _$CalendarDatabase _db;
  $CalendarDatabaseManager(this._db);
  $$CalendarAccountsTableTableManager get calendarAccounts =>
      $$CalendarAccountsTableTableManager(_db, _db.calendarAccounts);
  $$CalendarsMetaTableTableManager get calendarsMeta =>
      $$CalendarsMetaTableTableManager(_db, _db.calendarsMeta);
  $$CalendarEventsTableTableManager get calendarEvents =>
      $$CalendarEventsTableTableManager(_db, _db.calendarEvents);
  $$CalendarOutboxTableTableManager get calendarOutbox =>
      $$CalendarOutboxTableTableManager(_db, _db.calendarOutbox);
  $$SyncConflictsTableTableManager get syncConflicts =>
      $$SyncConflictsTableTableManager(_db, _db.syncConflicts);
}
