// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// **************************************************************************
// MoorGenerator
// **************************************************************************

// ignore_for_file: unnecessary_brace_in_string_interps, unnecessary_this
class TransferCard extends DataClass implements Insertable<TransferCard> {
  final int id;
  final Profile owner;
  final Payload payload;
  final Contact? contact;
  final SFile? file;
  final URLLink? url;
  final DateTime received;
  TransferCard(
      {required this.id,
      required this.owner,
      required this.payload,
      this.contact,
      this.file,
      this.url,
      required this.received});
  factory TransferCard.fromData(Map<String, dynamic> data, GeneratedDatabase db,
      {String? prefix}) {
    final effectivePrefix = prefix ?? '';
    return TransferCard(
      id: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}id'])!,
      owner: $TransferCardsTable.$converter0.mapToDart(const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}owner']))!,
      payload: $TransferCardsTable.$converter1.mapToDart(const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}payload']))!,
      contact: $TransferCardsTable.$converter2.mapToDart(const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}contact'])),
      file: $TransferCardsTable.$converter3.mapToDart(const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}file'])),
      url: $TransferCardsTable.$converter4.mapToDart(const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}url'])),
      received: const DateTimeType()
          .mapFromDatabaseResponse(data['${effectivePrefix}received'])!,
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    {
      final converter = $TransferCardsTable.$converter0;
      map['owner'] = Variable<String>(converter.mapToSql(owner)!);
    }
    {
      final converter = $TransferCardsTable.$converter1;
      map['payload'] = Variable<int>(converter.mapToSql(payload)!);
    }
    if (!nullToAbsent || contact != null) {
      final converter = $TransferCardsTable.$converter2;
      map['contact'] = Variable<String?>(converter.mapToSql(contact));
    }
    if (!nullToAbsent || file != null) {
      final converter = $TransferCardsTable.$converter3;
      map['file'] = Variable<String?>(converter.mapToSql(file));
    }
    if (!nullToAbsent || url != null) {
      final converter = $TransferCardsTable.$converter4;
      map['url'] = Variable<String?>(converter.mapToSql(url));
    }
    map['received'] = Variable<DateTime>(received);
    return map;
  }

  TransferCardsCompanion toCompanion(bool nullToAbsent) {
    return TransferCardsCompanion(
      id: Value(id),
      owner: Value(owner),
      payload: Value(payload),
      contact: contact == null && nullToAbsent
          ? const Value.absent()
          : Value(contact),
      file: file == null && nullToAbsent ? const Value.absent() : Value(file),
      url: url == null && nullToAbsent ? const Value.absent() : Value(url),
      received: Value(received),
    );
  }

  factory TransferCard.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return TransferCard(
      id: serializer.fromJson<int>(json['id']),
      owner: serializer.fromJson<Profile>(json['owner']),
      payload: serializer.fromJson<Payload>(json['payload']),
      contact: serializer.fromJson<Contact?>(json['contact']),
      file: serializer.fromJson<SFile?>(json['file']),
      url: serializer.fromJson<URLLink?>(json['url']),
      received: serializer.fromJson<DateTime>(json['received']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'owner': serializer.toJson<Profile>(owner),
      'payload': serializer.toJson<Payload>(payload),
      'contact': serializer.toJson<Contact?>(contact),
      'file': serializer.toJson<SFile?>(file),
      'url': serializer.toJson<URLLink?>(url),
      'received': serializer.toJson<DateTime>(received),
    };
  }

  TransferCard copyWith(
          {int? id,
          Profile? owner,
          Payload? payload,
          Contact? contact,
          SFile? file,
          URLLink? url,
          DateTime? received}) =>
      TransferCard(
        id: id ?? this.id,
        owner: owner ?? this.owner,
        payload: payload ?? this.payload,
        contact: contact ?? this.contact,
        file: file ?? this.file,
        url: url ?? this.url,
        received: received ?? this.received,
      );
  @override
  String toString() {
    return (StringBuffer('TransferCard(')
          ..write('id: $id, ')
          ..write('owner: $owner, ')
          ..write('payload: $payload, ')
          ..write('contact: $contact, ')
          ..write('file: $file, ')
          ..write('url: $url, ')
          ..write('received: $received')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => $mrjf($mrjc(
      id.hashCode,
      $mrjc(
          owner.hashCode,
          $mrjc(
              payload.hashCode,
              $mrjc(
                  contact.hashCode,
                  $mrjc(file.hashCode,
                      $mrjc(url.hashCode, received.hashCode)))))));
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TransferCard &&
          other.id == this.id &&
          other.owner == this.owner &&
          other.payload == this.payload &&
          other.contact == this.contact &&
          other.file == this.file &&
          other.url == this.url &&
          other.received == this.received);
}

class TransferCardsCompanion extends UpdateCompanion<TransferCard> {
  final Value<int> id;
  final Value<Profile> owner;
  final Value<Payload> payload;
  final Value<Contact?> contact;
  final Value<SFile?> file;
  final Value<URLLink?> url;
  final Value<DateTime> received;
  const TransferCardsCompanion({
    this.id = const Value.absent(),
    this.owner = const Value.absent(),
    this.payload = const Value.absent(),
    this.contact = const Value.absent(),
    this.file = const Value.absent(),
    this.url = const Value.absent(),
    this.received = const Value.absent(),
  });
  TransferCardsCompanion.insert({
    this.id = const Value.absent(),
    required Profile owner,
    required Payload payload,
    this.contact = const Value.absent(),
    this.file = const Value.absent(),
    this.url = const Value.absent(),
    required DateTime received,
  })  : owner = Value(owner),
        payload = Value(payload),
        received = Value(received);
  static Insertable<TransferCard> custom({
    Expression<int>? id,
    Expression<Profile>? owner,
    Expression<Payload>? payload,
    Expression<Contact?>? contact,
    Expression<SFile?>? file,
    Expression<URLLink?>? url,
    Expression<DateTime>? received,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (owner != null) 'owner': owner,
      if (payload != null) 'payload': payload,
      if (contact != null) 'contact': contact,
      if (file != null) 'file': file,
      if (url != null) 'url': url,
      if (received != null) 'received': received,
    });
  }

  TransferCardsCompanion copyWith(
      {Value<int>? id,
      Value<Profile>? owner,
      Value<Payload>? payload,
      Value<Contact?>? contact,
      Value<SFile?>? file,
      Value<URLLink?>? url,
      Value<DateTime>? received}) {
    return TransferCardsCompanion(
      id: id ?? this.id,
      owner: owner ?? this.owner,
      payload: payload ?? this.payload,
      contact: contact ?? this.contact,
      file: file ?? this.file,
      url: url ?? this.url,
      received: received ?? this.received,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (owner.present) {
      final converter = $TransferCardsTable.$converter0;
      map['owner'] = Variable<String>(converter.mapToSql(owner.value)!);
    }
    if (payload.present) {
      final converter = $TransferCardsTable.$converter1;
      map['payload'] = Variable<int>(converter.mapToSql(payload.value)!);
    }
    if (contact.present) {
      final converter = $TransferCardsTable.$converter2;
      map['contact'] = Variable<String?>(converter.mapToSql(contact.value));
    }
    if (file.present) {
      final converter = $TransferCardsTable.$converter3;
      map['file'] = Variable<String?>(converter.mapToSql(file.value));
    }
    if (url.present) {
      final converter = $TransferCardsTable.$converter4;
      map['url'] = Variable<String?>(converter.mapToSql(url.value));
    }
    if (received.present) {
      map['received'] = Variable<DateTime>(received.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TransferCardsCompanion(')
          ..write('id: $id, ')
          ..write('owner: $owner, ')
          ..write('payload: $payload, ')
          ..write('contact: $contact, ')
          ..write('file: $file, ')
          ..write('url: $url, ')
          ..write('received: $received')
          ..write(')'))
        .toString();
  }
}

class $TransferCardsTable extends TransferCards
    with TableInfo<$TransferCardsTable, TransferCard> {
  final GeneratedDatabase _db;
  final String? _alias;
  $TransferCardsTable(this._db, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  late final GeneratedColumn<int?> id = GeneratedColumn<int?>(
      'id', aliasedName, false,
      typeName: 'INTEGER',
      requiredDuringInsert: false,
      defaultConstraints: 'PRIMARY KEY AUTOINCREMENT');
  final VerificationMeta _ownerMeta = const VerificationMeta('owner');
  late final GeneratedColumnWithTypeConverter<Profile, String?> owner =
      GeneratedColumn<String?>('owner', aliasedName, false,
              typeName: 'TEXT', requiredDuringInsert: true)
          .withConverter<Profile>($TransferCardsTable.$converter0);
  final VerificationMeta _payloadMeta = const VerificationMeta('payload');
  late final GeneratedColumnWithTypeConverter<Payload, int?> payload =
      GeneratedColumn<int?>('payload', aliasedName, false,
              typeName: 'INTEGER', requiredDuringInsert: true)
          .withConverter<Payload>($TransferCardsTable.$converter1);
  final VerificationMeta _contactMeta = const VerificationMeta('contact');
  late final GeneratedColumnWithTypeConverter<Contact, String?> contact =
      GeneratedColumn<String?>('contact', aliasedName, true,
              typeName: 'TEXT', requiredDuringInsert: false)
          .withConverter<Contact>($TransferCardsTable.$converter2);
  final VerificationMeta _fileMeta = const VerificationMeta('file');
  late final GeneratedColumnWithTypeConverter<SFile, String?> file =
      GeneratedColumn<String?>('file', aliasedName, true,
              typeName: 'TEXT', requiredDuringInsert: false)
          .withConverter<SFile>($TransferCardsTable.$converter3);
  final VerificationMeta _urlMeta = const VerificationMeta('url');
  late final GeneratedColumnWithTypeConverter<URLLink, String?> url =
      GeneratedColumn<String?>('url', aliasedName, true,
              typeName: 'TEXT', requiredDuringInsert: false)
          .withConverter<URLLink>($TransferCardsTable.$converter4);
  final VerificationMeta _receivedMeta = const VerificationMeta('received');
  late final GeneratedColumn<DateTime?> received = GeneratedColumn<DateTime?>(
      'received', aliasedName, false,
      typeName: 'INTEGER', requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [id, owner, payload, contact, file, url, received];
  @override
  String get aliasedName => _alias ?? 'transfer_cards';
  @override
  String get actualTableName => 'transfer_cards';
  @override
  VerificationContext validateIntegrity(Insertable<TransferCard> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    context.handle(_ownerMeta, const VerificationResult.success());
    context.handle(_payloadMeta, const VerificationResult.success());
    context.handle(_contactMeta, const VerificationResult.success());
    context.handle(_fileMeta, const VerificationResult.success());
    context.handle(_urlMeta, const VerificationResult.success());
    if (data.containsKey('received')) {
      context.handle(_receivedMeta,
          received.isAcceptableOrUnknown(data['received']!, _receivedMeta));
    } else if (isInserting) {
      context.missing(_receivedMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TransferCard map(Map<String, dynamic> data, {String? tablePrefix}) {
    return TransferCard.fromData(data, _db,
        prefix: tablePrefix != null ? '$tablePrefix.' : null);
  }

  @override
  $TransferCardsTable createAlias(String alias) {
    return $TransferCardsTable(_db, alias);
  }

  static TypeConverter<Profile, String> $converter0 = const ProfileConverter();
  static TypeConverter<Payload, int> $converter1 = const PayloadConverter();
  static TypeConverter<Contact, String> $converter2 = const ContactConverter();
  static TypeConverter<SFile, String> $converter3 = const FileConverter();
  static TypeConverter<URLLink, String> $converter4 = const URLConverter();
}

class TransferActivity extends DataClass
    implements Insertable<TransferActivity> {
  final int id;
  final Profile owner;
  final Payload payload;
  final ActivityType activity;
  TransferActivity(
      {required this.id,
      required this.owner,
      required this.payload,
      required this.activity});
  factory TransferActivity.fromData(
      Map<String, dynamic> data, GeneratedDatabase db,
      {String? prefix}) {
    final effectivePrefix = prefix ?? '';
    return TransferActivity(
      id: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}id'])!,
      owner: $TransferActivitiesTable.$converter0.mapToDart(const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}owner']))!,
      payload: $TransferActivitiesTable.$converter1.mapToDart(const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}payload']))!,
      activity: $TransferActivitiesTable.$converter2.mapToDart(const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}activity']))!,
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    {
      final converter = $TransferActivitiesTable.$converter0;
      map['owner'] = Variable<String>(converter.mapToSql(owner)!);
    }
    {
      final converter = $TransferActivitiesTable.$converter1;
      map['payload'] = Variable<int>(converter.mapToSql(payload)!);
    }
    {
      final converter = $TransferActivitiesTable.$converter2;
      map['activity'] = Variable<int>(converter.mapToSql(activity)!);
    }
    return map;
  }

  TransferActivitiesCompanion toCompanion(bool nullToAbsent) {
    return TransferActivitiesCompanion(
      id: Value(id),
      owner: Value(owner),
      payload: Value(payload),
      activity: Value(activity),
    );
  }

  factory TransferActivity.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return TransferActivity(
      id: serializer.fromJson<int>(json['id']),
      owner: serializer.fromJson<Profile>(json['owner']),
      payload: serializer.fromJson<Payload>(json['payload']),
      activity: serializer.fromJson<ActivityType>(json['activity']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'owner': serializer.toJson<Profile>(owner),
      'payload': serializer.toJson<Payload>(payload),
      'activity': serializer.toJson<ActivityType>(activity),
    };
  }

  TransferActivity copyWith(
          {int? id,
          Profile? owner,
          Payload? payload,
          ActivityType? activity}) =>
      TransferActivity(
        id: id ?? this.id,
        owner: owner ?? this.owner,
        payload: payload ?? this.payload,
        activity: activity ?? this.activity,
      );
  @override
  String toString() {
    return (StringBuffer('TransferActivity(')
          ..write('id: $id, ')
          ..write('owner: $owner, ')
          ..write('payload: $payload, ')
          ..write('activity: $activity')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => $mrjf($mrjc(id.hashCode,
      $mrjc(owner.hashCode, $mrjc(payload.hashCode, activity.hashCode))));
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TransferActivity &&
          other.id == this.id &&
          other.owner == this.owner &&
          other.payload == this.payload &&
          other.activity == this.activity);
}

class TransferActivitiesCompanion extends UpdateCompanion<TransferActivity> {
  final Value<int> id;
  final Value<Profile> owner;
  final Value<Payload> payload;
  final Value<ActivityType> activity;
  const TransferActivitiesCompanion({
    this.id = const Value.absent(),
    this.owner = const Value.absent(),
    this.payload = const Value.absent(),
    this.activity = const Value.absent(),
  });
  TransferActivitiesCompanion.insert({
    this.id = const Value.absent(),
    required Profile owner,
    required Payload payload,
    required ActivityType activity,
  })  : owner = Value(owner),
        payload = Value(payload),
        activity = Value(activity);
  static Insertable<TransferActivity> custom({
    Expression<int>? id,
    Expression<Profile>? owner,
    Expression<Payload>? payload,
    Expression<ActivityType>? activity,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (owner != null) 'owner': owner,
      if (payload != null) 'payload': payload,
      if (activity != null) 'activity': activity,
    });
  }

  TransferActivitiesCompanion copyWith(
      {Value<int>? id,
      Value<Profile>? owner,
      Value<Payload>? payload,
      Value<ActivityType>? activity}) {
    return TransferActivitiesCompanion(
      id: id ?? this.id,
      owner: owner ?? this.owner,
      payload: payload ?? this.payload,
      activity: activity ?? this.activity,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (owner.present) {
      final converter = $TransferActivitiesTable.$converter0;
      map['owner'] = Variable<String>(converter.mapToSql(owner.value)!);
    }
    if (payload.present) {
      final converter = $TransferActivitiesTable.$converter1;
      map['payload'] = Variable<int>(converter.mapToSql(payload.value)!);
    }
    if (activity.present) {
      final converter = $TransferActivitiesTable.$converter2;
      map['activity'] = Variable<int>(converter.mapToSql(activity.value)!);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TransferActivitiesCompanion(')
          ..write('id: $id, ')
          ..write('owner: $owner, ')
          ..write('payload: $payload, ')
          ..write('activity: $activity')
          ..write(')'))
        .toString();
  }
}

class $TransferActivitiesTable extends TransferActivities
    with TableInfo<$TransferActivitiesTable, TransferActivity> {
  final GeneratedDatabase _db;
  final String? _alias;
  $TransferActivitiesTable(this._db, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  late final GeneratedColumn<int?> id = GeneratedColumn<int?>(
      'id', aliasedName, false,
      typeName: 'INTEGER',
      requiredDuringInsert: false,
      defaultConstraints: 'PRIMARY KEY AUTOINCREMENT');
  final VerificationMeta _ownerMeta = const VerificationMeta('owner');
  late final GeneratedColumnWithTypeConverter<Profile, String?> owner =
      GeneratedColumn<String?>('owner', aliasedName, false,
              typeName: 'TEXT', requiredDuringInsert: true)
          .withConverter<Profile>($TransferActivitiesTable.$converter0);
  final VerificationMeta _payloadMeta = const VerificationMeta('payload');
  late final GeneratedColumnWithTypeConverter<Payload, int?> payload =
      GeneratedColumn<int?>('payload', aliasedName, false,
              typeName: 'INTEGER', requiredDuringInsert: true)
          .withConverter<Payload>($TransferActivitiesTable.$converter1);
  final VerificationMeta _activityMeta = const VerificationMeta('activity');
  late final GeneratedColumnWithTypeConverter<ActivityType, int?> activity =
      GeneratedColumn<int?>('activity', aliasedName, false,
              typeName: 'INTEGER', requiredDuringInsert: true)
          .withConverter<ActivityType>($TransferActivitiesTable.$converter2);
  @override
  List<GeneratedColumn> get $columns => [id, owner, payload, activity];
  @override
  String get aliasedName => _alias ?? 'transfer_activities';
  @override
  String get actualTableName => 'transfer_activities';
  @override
  VerificationContext validateIntegrity(Insertable<TransferActivity> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    context.handle(_ownerMeta, const VerificationResult.success());
    context.handle(_payloadMeta, const VerificationResult.success());
    context.handle(_activityMeta, const VerificationResult.success());
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TransferActivity map(Map<String, dynamic> data, {String? tablePrefix}) {
    return TransferActivity.fromData(data, _db,
        prefix: tablePrefix != null ? '$tablePrefix.' : null);
  }

  @override
  $TransferActivitiesTable createAlias(String alias) {
    return $TransferActivitiesTable(_db, alias);
  }

  static TypeConverter<Profile, String> $converter0 = const ProfileConverter();
  static TypeConverter<Payload, int> $converter1 = const PayloadConverter();
  static TypeConverter<ActivityType, int> $converter2 =
      const ActivityConverter();
}

abstract class _$CardsDatabase extends GeneratedDatabase {
  _$CardsDatabase(QueryExecutor e) : super(SqlTypeSystem.defaultInstance, e);
  late final $TransferCardsTable transferCards = $TransferCardsTable(this);
  late final $TransferActivitiesTable transferActivities =
      $TransferActivitiesTable(this);
  @override
  Iterable<TableInfo> get allTables => allSchemaEntities.whereType<TableInfo>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities =>
      [transferCards, transferActivities];
}
