// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cards_db.dart';

// **************************************************************************
// MoorGenerator
// **************************************************************************

// ignore_for_file: unnecessary_brace_in_string_interps, unnecessary_this
class TransferCardItem extends DataClass
    implements Insertable<TransferCardItem> {
  final int id;
  final Profile owner;
  final Payload payload;
  final Contact contact;
  final Metadata metadata;
  final URLLink url;
  final DateTime received;
  TransferCardItem(
      {@required this.id,
      @required this.owner,
      @required this.payload,
      this.contact,
      this.metadata,
      this.url,
      @required this.received});
  factory TransferCardItem.fromData(
      Map<String, dynamic> data, GeneratedDatabase db,
      {String prefix}) {
    final effectivePrefix = prefix ?? '';
    final intType = db.typeSystem.forDartType<int>();
    final stringType = db.typeSystem.forDartType<String>();
    final dateTimeType = db.typeSystem.forDartType<DateTime>();
    return TransferCardItem(
      id: intType.mapFromDatabaseResponse(data['${effectivePrefix}id']),
      owner: $TransferCardItemsTable.$converter0.mapToDart(
          stringType.mapFromDatabaseResponse(data['${effectivePrefix}owner'])),
      payload: $TransferCardItemsTable.$converter1.mapToDart(
          intType.mapFromDatabaseResponse(data['${effectivePrefix}payload'])),
      contact: $TransferCardItemsTable.$converter2.mapToDart(stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}contact'])),
      metadata: $TransferCardItemsTable.$converter3.mapToDart(stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}metadata'])),
      url: $TransferCardItemsTable.$converter4.mapToDart(
          stringType.mapFromDatabaseResponse(data['${effectivePrefix}url'])),
      received: dateTimeType
          .mapFromDatabaseResponse(data['${effectivePrefix}received']),
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (!nullToAbsent || id != null) {
      map['id'] = Variable<int>(id);
    }
    if (!nullToAbsent || owner != null) {
      final converter = $TransferCardItemsTable.$converter0;
      map['owner'] = Variable<String>(converter.mapToSql(owner));
    }
    if (!nullToAbsent || payload != null) {
      final converter = $TransferCardItemsTable.$converter1;
      map['payload'] = Variable<int>(converter.mapToSql(payload));
    }
    if (!nullToAbsent || contact != null) {
      final converter = $TransferCardItemsTable.$converter2;
      map['contact'] = Variable<String>(converter.mapToSql(contact));
    }
    if (!nullToAbsent || metadata != null) {
      final converter = $TransferCardItemsTable.$converter3;
      map['metadata'] = Variable<String>(converter.mapToSql(metadata));
    }
    if (!nullToAbsent || url != null) {
      final converter = $TransferCardItemsTable.$converter4;
      map['url'] = Variable<String>(converter.mapToSql(url));
    }
    if (!nullToAbsent || received != null) {
      map['received'] = Variable<DateTime>(received);
    }
    return map;
  }

  TransferCardItemsCompanion toCompanion(bool nullToAbsent) {
    return TransferCardItemsCompanion(
      id: id == null && nullToAbsent ? const Value.absent() : Value(id),
      owner:
          owner == null && nullToAbsent ? const Value.absent() : Value(owner),
      payload: payload == null && nullToAbsent
          ? const Value.absent()
          : Value(payload),
      contact: contact == null && nullToAbsent
          ? const Value.absent()
          : Value(contact),
      metadata: metadata == null && nullToAbsent
          ? const Value.absent()
          : Value(metadata),
      url: url == null && nullToAbsent ? const Value.absent() : Value(url),
      received: received == null && nullToAbsent
          ? const Value.absent()
          : Value(received),
    );
  }

  factory TransferCardItem.fromJson(Map<String, dynamic> json,
      {ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return TransferCardItem(
      id: serializer.fromJson<int>(json['id']),
      owner: serializer.fromJson<Profile>(json['owner']),
      payload: serializer.fromJson<Payload>(json['payload']),
      contact: serializer.fromJson<Contact>(json['contact']),
      metadata: serializer.fromJson<Metadata>(json['metadata']),
      url: serializer.fromJson<URLLink>(json['url']),
      received: serializer.fromJson<DateTime>(json['received']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'owner': serializer.toJson<Profile>(owner),
      'payload': serializer.toJson<Payload>(payload),
      'contact': serializer.toJson<Contact>(contact),
      'metadata': serializer.toJson<Metadata>(metadata),
      'url': serializer.toJson<URLLink>(url),
      'received': serializer.toJson<DateTime>(received),
    };
  }

  TransferCardItem copyWith(
          {int id,
          Profile owner,
          Payload payload,
          Contact contact,
          Metadata metadata,
          URLLink url,
          DateTime received}) =>
      TransferCardItem(
        id: id ?? this.id,
        owner: owner ?? this.owner,
        payload: payload ?? this.payload,
        contact: contact ?? this.contact,
        metadata: metadata ?? this.metadata,
        url: url ?? this.url,
        received: received ?? this.received,
      );
  @override
  String toString() {
    return (StringBuffer('TransferCardItem(')
          ..write('id: $id, ')
          ..write('owner: $owner, ')
          ..write('payload: $payload, ')
          ..write('contact: $contact, ')
          ..write('metadata: $metadata, ')
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
                  $mrjc(metadata.hashCode,
                      $mrjc(url.hashCode, received.hashCode)))))));
  @override
  bool operator ==(dynamic other) =>
      identical(this, other) ||
      (other is TransferCardItem &&
          other.id == this.id &&
          other.owner == this.owner &&
          other.payload == this.payload &&
          other.contact == this.contact &&
          other.metadata == this.metadata &&
          other.url == this.url &&
          other.received == this.received);
}

class TransferCardItemsCompanion extends UpdateCompanion<TransferCardItem> {
  final Value<int> id;
  final Value<Profile> owner;
  final Value<Payload> payload;
  final Value<Contact> contact;
  final Value<Metadata> metadata;
  final Value<URLLink> url;
  final Value<DateTime> received;
  const TransferCardItemsCompanion({
    this.id = const Value.absent(),
    this.owner = const Value.absent(),
    this.payload = const Value.absent(),
    this.contact = const Value.absent(),
    this.metadata = const Value.absent(),
    this.url = const Value.absent(),
    this.received = const Value.absent(),
  });
  TransferCardItemsCompanion.insert({
    this.id = const Value.absent(),
    @required Profile owner,
    @required Payload payload,
    this.contact = const Value.absent(),
    this.metadata = const Value.absent(),
    this.url = const Value.absent(),
    @required DateTime received,
  })  : owner = Value(owner),
        payload = Value(payload),
        received = Value(received);
  static Insertable<TransferCardItem> custom({
    Expression<int> id,
    Expression<Profile> owner,
    Expression<Payload> payload,
    Expression<Contact> contact,
    Expression<Metadata> metadata,
    Expression<URLLink> url,
    Expression<DateTime> received,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (owner != null) 'owner': owner,
      if (payload != null) 'payload': payload,
      if (contact != null) 'contact': contact,
      if (metadata != null) 'metadata': metadata,
      if (url != null) 'url': url,
      if (received != null) 'received': received,
    });
  }

  TransferCardItemsCompanion copyWith(
      {Value<int> id,
      Value<Profile> owner,
      Value<Payload> payload,
      Value<Contact> contact,
      Value<Metadata> metadata,
      Value<URLLink> url,
      Value<DateTime> received}) {
    return TransferCardItemsCompanion(
      id: id ?? this.id,
      owner: owner ?? this.owner,
      payload: payload ?? this.payload,
      contact: contact ?? this.contact,
      metadata: metadata ?? this.metadata,
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
      final converter = $TransferCardItemsTable.$converter0;
      map['owner'] = Variable<String>(converter.mapToSql(owner.value));
    }
    if (payload.present) {
      final converter = $TransferCardItemsTable.$converter1;
      map['payload'] = Variable<int>(converter.mapToSql(payload.value));
    }
    if (contact.present) {
      final converter = $TransferCardItemsTable.$converter2;
      map['contact'] = Variable<String>(converter.mapToSql(contact.value));
    }
    if (metadata.present) {
      final converter = $TransferCardItemsTable.$converter3;
      map['metadata'] = Variable<String>(converter.mapToSql(metadata.value));
    }
    if (url.present) {
      final converter = $TransferCardItemsTable.$converter4;
      map['url'] = Variable<String>(converter.mapToSql(url.value));
    }
    if (received.present) {
      map['received'] = Variable<DateTime>(received.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TransferCardItemsCompanion(')
          ..write('id: $id, ')
          ..write('owner: $owner, ')
          ..write('payload: $payload, ')
          ..write('contact: $contact, ')
          ..write('metadata: $metadata, ')
          ..write('url: $url, ')
          ..write('received: $received')
          ..write(')'))
        .toString();
  }
}

class $TransferCardItemsTable extends TransferCardItems
    with TableInfo<$TransferCardItemsTable, TransferCardItem> {
  final GeneratedDatabase _db;
  final String _alias;
  $TransferCardItemsTable(this._db, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  GeneratedIntColumn _id;
  @override
  GeneratedIntColumn get id => _id ??= _constructId();
  GeneratedIntColumn _constructId() {
    return GeneratedIntColumn('id', $tableName, false,
        hasAutoIncrement: true, declaredAsPrimaryKey: true);
  }

  final VerificationMeta _ownerMeta = const VerificationMeta('owner');
  GeneratedTextColumn _owner;
  @override
  GeneratedTextColumn get owner => _owner ??= _constructOwner();
  GeneratedTextColumn _constructOwner() {
    return GeneratedTextColumn(
      'owner',
      $tableName,
      false,
    );
  }

  final VerificationMeta _payloadMeta = const VerificationMeta('payload');
  GeneratedIntColumn _payload;
  @override
  GeneratedIntColumn get payload => _payload ??= _constructPayload();
  GeneratedIntColumn _constructPayload() {
    return GeneratedIntColumn(
      'payload',
      $tableName,
      false,
    );
  }

  final VerificationMeta _contactMeta = const VerificationMeta('contact');
  GeneratedTextColumn _contact;
  @override
  GeneratedTextColumn get contact => _contact ??= _constructContact();
  GeneratedTextColumn _constructContact() {
    return GeneratedTextColumn(
      'contact',
      $tableName,
      true,
    );
  }

  final VerificationMeta _metadataMeta = const VerificationMeta('metadata');
  GeneratedTextColumn _metadata;
  @override
  GeneratedTextColumn get metadata => _metadata ??= _constructMetadata();
  GeneratedTextColumn _constructMetadata() {
    return GeneratedTextColumn(
      'metadata',
      $tableName,
      true,
    );
  }

  final VerificationMeta _urlMeta = const VerificationMeta('url');
  GeneratedTextColumn _url;
  @override
  GeneratedTextColumn get url => _url ??= _constructUrl();
  GeneratedTextColumn _constructUrl() {
    return GeneratedTextColumn(
      'url',
      $tableName,
      true,
    );
  }

  final VerificationMeta _receivedMeta = const VerificationMeta('received');
  GeneratedDateTimeColumn _received;
  @override
  GeneratedDateTimeColumn get received => _received ??= _constructReceived();
  GeneratedDateTimeColumn _constructReceived() {
    return GeneratedDateTimeColumn(
      'received',
      $tableName,
      false,
    );
  }

  @override
  List<GeneratedColumn> get $columns =>
      [id, owner, payload, contact, metadata, url, received];
  @override
  $TransferCardItemsTable get asDslTable => this;
  @override
  String get $tableName => _alias ?? 'transfer_card_items';
  @override
  final String actualTableName = 'transfer_card_items';
  @override
  VerificationContext validateIntegrity(Insertable<TransferCardItem> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id'], _idMeta));
    }
    context.handle(_ownerMeta, const VerificationResult.success());
    context.handle(_payloadMeta, const VerificationResult.success());
    context.handle(_contactMeta, const VerificationResult.success());
    context.handle(_metadataMeta, const VerificationResult.success());
    context.handle(_urlMeta, const VerificationResult.success());
    if (data.containsKey('received')) {
      context.handle(_receivedMeta,
          received.isAcceptableOrUnknown(data['received'], _receivedMeta));
    } else if (isInserting) {
      context.missing(_receivedMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TransferCardItem map(Map<String, dynamic> data, {String tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : null;
    return TransferCardItem.fromData(data, _db, prefix: effectivePrefix);
  }

  @override
  $TransferCardItemsTable createAlias(String alias) {
    return $TransferCardItemsTable(_db, alias);
  }

  static TypeConverter<Profile, String> $converter0 = const ProfileConverter();
  static TypeConverter<Payload, int> $converter1 = const PayloadConverter();
  static TypeConverter<Contact, String> $converter2 = const ContactConverter();
  static TypeConverter<Metadata, String> $converter3 =
      const MetadataConverter();
  static TypeConverter<URLLink, String> $converter4 = const URLConverter();
}

class TransferCardActivity extends DataClass
    implements Insertable<TransferCardActivity> {
  final int id;
  final TransferCard card;
  final ActivityType activity;
  TransferCardActivity(
      {@required this.id, @required this.card, @required this.activity});
  factory TransferCardActivity.fromData(
      Map<String, dynamic> data, GeneratedDatabase db,
      {String prefix}) {
    final effectivePrefix = prefix ?? '';
    final intType = db.typeSystem.forDartType<int>();
    final stringType = db.typeSystem.forDartType<String>();
    return TransferCardActivity(
      id: intType.mapFromDatabaseResponse(data['${effectivePrefix}id']),
      card: $TransferCardActivitiesTable.$converter0.mapToDart(
          stringType.mapFromDatabaseResponse(data['${effectivePrefix}card'])),
      activity: $TransferCardActivitiesTable.$converter1.mapToDart(
          intType.mapFromDatabaseResponse(data['${effectivePrefix}activity'])),
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (!nullToAbsent || id != null) {
      map['id'] = Variable<int>(id);
    }
    if (!nullToAbsent || card != null) {
      final converter = $TransferCardActivitiesTable.$converter0;
      map['card'] = Variable<String>(converter.mapToSql(card));
    }
    if (!nullToAbsent || activity != null) {
      final converter = $TransferCardActivitiesTable.$converter1;
      map['activity'] = Variable<int>(converter.mapToSql(activity));
    }
    return map;
  }

  TransferCardActivitiesCompanion toCompanion(bool nullToAbsent) {
    return TransferCardActivitiesCompanion(
      id: id == null && nullToAbsent ? const Value.absent() : Value(id),
      card: card == null && nullToAbsent ? const Value.absent() : Value(card),
      activity: activity == null && nullToAbsent
          ? const Value.absent()
          : Value(activity),
    );
  }

  factory TransferCardActivity.fromJson(Map<String, dynamic> json,
      {ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return TransferCardActivity(
      id: serializer.fromJson<int>(json['id']),
      card: serializer.fromJson<TransferCard>(json['card']),
      activity: serializer.fromJson<ActivityType>(json['activity']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'card': serializer.toJson<TransferCard>(card),
      'activity': serializer.toJson<ActivityType>(activity),
    };
  }

  TransferCardActivity copyWith(
          {int id, TransferCard card, ActivityType activity}) =>
      TransferCardActivity(
        id: id ?? this.id,
        card: card ?? this.card,
        activity: activity ?? this.activity,
      );
  @override
  String toString() {
    return (StringBuffer('TransferCardActivity(')
          ..write('id: $id, ')
          ..write('card: $card, ')
          ..write('activity: $activity')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      $mrjf($mrjc(id.hashCode, $mrjc(card.hashCode, activity.hashCode)));
  @override
  bool operator ==(dynamic other) =>
      identical(this, other) ||
      (other is TransferCardActivity &&
          other.id == this.id &&
          other.card == this.card &&
          other.activity == this.activity);
}

class TransferCardActivitiesCompanion
    extends UpdateCompanion<TransferCardActivity> {
  final Value<int> id;
  final Value<TransferCard> card;
  final Value<ActivityType> activity;
  const TransferCardActivitiesCompanion({
    this.id = const Value.absent(),
    this.card = const Value.absent(),
    this.activity = const Value.absent(),
  });
  TransferCardActivitiesCompanion.insert({
    this.id = const Value.absent(),
    @required TransferCard card,
    @required ActivityType activity,
  })  : card = Value(card),
        activity = Value(activity);
  static Insertable<TransferCardActivity> custom({
    Expression<int> id,
    Expression<TransferCard> card,
    Expression<ActivityType> activity,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (card != null) 'card': card,
      if (activity != null) 'activity': activity,
    });
  }

  TransferCardActivitiesCompanion copyWith(
      {Value<int> id, Value<TransferCard> card, Value<ActivityType> activity}) {
    return TransferCardActivitiesCompanion(
      id: id ?? this.id,
      card: card ?? this.card,
      activity: activity ?? this.activity,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (card.present) {
      final converter = $TransferCardActivitiesTable.$converter0;
      map['card'] = Variable<String>(converter.mapToSql(card.value));
    }
    if (activity.present) {
      final converter = $TransferCardActivitiesTable.$converter1;
      map['activity'] = Variable<int>(converter.mapToSql(activity.value));
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TransferCardActivitiesCompanion(')
          ..write('id: $id, ')
          ..write('card: $card, ')
          ..write('activity: $activity')
          ..write(')'))
        .toString();
  }
}

class $TransferCardActivitiesTable extends TransferCardActivities
    with TableInfo<$TransferCardActivitiesTable, TransferCardActivity> {
  final GeneratedDatabase _db;
  final String _alias;
  $TransferCardActivitiesTable(this._db, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  GeneratedIntColumn _id;
  @override
  GeneratedIntColumn get id => _id ??= _constructId();
  GeneratedIntColumn _constructId() {
    return GeneratedIntColumn('id', $tableName, false,
        hasAutoIncrement: true, declaredAsPrimaryKey: true);
  }

  final VerificationMeta _cardMeta = const VerificationMeta('card');
  GeneratedTextColumn _card;
  @override
  GeneratedTextColumn get card => _card ??= _constructCard();
  GeneratedTextColumn _constructCard() {
    return GeneratedTextColumn(
      'card',
      $tableName,
      false,
    );
  }

  final VerificationMeta _activityMeta = const VerificationMeta('activity');
  GeneratedIntColumn _activity;
  @override
  GeneratedIntColumn get activity => _activity ??= _constructActivity();
  GeneratedIntColumn _constructActivity() {
    return GeneratedIntColumn(
      'activity',
      $tableName,
      false,
    );
  }

  @override
  List<GeneratedColumn> get $columns => [id, card, activity];
  @override
  $TransferCardActivitiesTable get asDslTable => this;
  @override
  String get $tableName => _alias ?? 'transfer_card_activities';
  @override
  final String actualTableName = 'transfer_card_activities';
  @override
  VerificationContext validateIntegrity(
      Insertable<TransferCardActivity> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id'], _idMeta));
    }
    context.handle(_cardMeta, const VerificationResult.success());
    context.handle(_activityMeta, const VerificationResult.success());
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TransferCardActivity map(Map<String, dynamic> data, {String tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : null;
    return TransferCardActivity.fromData(data, _db, prefix: effectivePrefix);
  }

  @override
  $TransferCardActivitiesTable createAlias(String alias) {
    return $TransferCardActivitiesTable(_db, alias);
  }

  static TypeConverter<TransferCard, String> $converter0 =
      const CardConverter();
  static TypeConverter<ActivityType, int> $converter1 =
      const ActivityConverter();
}

abstract class _$CardsDatabase extends GeneratedDatabase {
  _$CardsDatabase(QueryExecutor e) : super(SqlTypeSystem.defaultInstance, e);
  $TransferCardItemsTable _transferCardItems;
  $TransferCardItemsTable get transferCardItems =>
      _transferCardItems ??= $TransferCardItemsTable(this);
  $TransferCardActivitiesTable _transferCardActivities;
  $TransferCardActivitiesTable get transferCardActivities =>
      _transferCardActivities ??= $TransferCardActivitiesTable(this);
  @override
  Iterable<TableInfo> get allTables => allSchemaEntities.whereType<TableInfo>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities =>
      [transferCardItems, transferCardActivities];
}
