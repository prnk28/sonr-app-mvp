// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cards_db.dart';

// **************************************************************************
// MoorGenerator
// **************************************************************************

// ignore_for_file: unnecessary_brace_in_string_interps, unnecessary_this
class CardItemData extends DataClass implements Insertable<CardItemData> {
  final int id;
  final int owner;
  final Payload payload;
  final int transfer;
  final DateTime received;
  CardItemData(
      {@required this.id,
      @required this.owner,
      @required this.payload,
      @required this.transfer,
      @required this.received});
  factory CardItemData.fromData(Map<String, dynamic> data, GeneratedDatabase db,
      {String prefix}) {
    final effectivePrefix = prefix ?? '';
    final intType = db.typeSystem.forDartType<int>();
    final dateTimeType = db.typeSystem.forDartType<DateTime>();
    return CardItemData(
      id: intType.mapFromDatabaseResponse(data['${effectivePrefix}id']),
      owner: intType.mapFromDatabaseResponse(data['${effectivePrefix}owner']),
      payload: $CardItemTable.$converter0.mapToDart(
          intType.mapFromDatabaseResponse(data['${effectivePrefix}payload'])),
      transfer:
          intType.mapFromDatabaseResponse(data['${effectivePrefix}transfer']),
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
      map['owner'] = Variable<int>(owner);
    }
    if (!nullToAbsent || payload != null) {
      final converter = $CardItemTable.$converter0;
      map['payload'] = Variable<int>(converter.mapToSql(payload));
    }
    if (!nullToAbsent || transfer != null) {
      map['transfer'] = Variable<int>(transfer);
    }
    if (!nullToAbsent || received != null) {
      map['received'] = Variable<DateTime>(received);
    }
    return map;
  }

  CardItemCompanion toCompanion(bool nullToAbsent) {
    return CardItemCompanion(
      id: id == null && nullToAbsent ? const Value.absent() : Value(id),
      owner:
          owner == null && nullToAbsent ? const Value.absent() : Value(owner),
      payload: payload == null && nullToAbsent
          ? const Value.absent()
          : Value(payload),
      transfer: transfer == null && nullToAbsent
          ? const Value.absent()
          : Value(transfer),
      received: received == null && nullToAbsent
          ? const Value.absent()
          : Value(received),
    );
  }

  factory CardItemData.fromJson(Map<String, dynamic> json,
      {ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return CardItemData(
      id: serializer.fromJson<int>(json['id']),
      owner: serializer.fromJson<int>(json['owner']),
      payload: serializer.fromJson<Payload>(json['payload']),
      transfer: serializer.fromJson<int>(json['transfer']),
      received: serializer.fromJson<DateTime>(json['received']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'owner': serializer.toJson<int>(owner),
      'payload': serializer.toJson<Payload>(payload),
      'transfer': serializer.toJson<int>(transfer),
      'received': serializer.toJson<DateTime>(received),
    };
  }

  CardItemData copyWith(
          {int id,
          int owner,
          Payload payload,
          int transfer,
          DateTime received}) =>
      CardItemData(
        id: id ?? this.id,
        owner: owner ?? this.owner,
        payload: payload ?? this.payload,
        transfer: transfer ?? this.transfer,
        received: received ?? this.received,
      );
  @override
  String toString() {
    return (StringBuffer('CardItemData(')
          ..write('id: $id, ')
          ..write('owner: $owner, ')
          ..write('payload: $payload, ')
          ..write('transfer: $transfer, ')
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
              payload.hashCode, $mrjc(transfer.hashCode, received.hashCode)))));
  @override
  bool operator ==(dynamic other) =>
      identical(this, other) ||
      (other is CardItemData &&
          other.id == this.id &&
          other.owner == this.owner &&
          other.payload == this.payload &&
          other.transfer == this.transfer &&
          other.received == this.received);
}

class CardItemCompanion extends UpdateCompanion<CardItemData> {
  final Value<int> id;
  final Value<int> owner;
  final Value<Payload> payload;
  final Value<int> transfer;
  final Value<DateTime> received;
  const CardItemCompanion({
    this.id = const Value.absent(),
    this.owner = const Value.absent(),
    this.payload = const Value.absent(),
    this.transfer = const Value.absent(),
    this.received = const Value.absent(),
  });
  CardItemCompanion.insert({
    this.id = const Value.absent(),
    @required int owner,
    @required Payload payload,
    @required int transfer,
    @required DateTime received,
  })  : owner = Value(owner),
        payload = Value(payload),
        transfer = Value(transfer),
        received = Value(received);
  static Insertable<CardItemData> custom({
    Expression<int> id,
    Expression<int> owner,
    Expression<Payload> payload,
    Expression<int> transfer,
    Expression<DateTime> received,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (owner != null) 'owner': owner,
      if (payload != null) 'payload': payload,
      if (transfer != null) 'transfer': transfer,
      if (received != null) 'received': received,
    });
  }

  CardItemCompanion copyWith(
      {Value<int> id,
      Value<int> owner,
      Value<Payload> payload,
      Value<int> transfer,
      Value<DateTime> received}) {
    return CardItemCompanion(
      id: id ?? this.id,
      owner: owner ?? this.owner,
      payload: payload ?? this.payload,
      transfer: transfer ?? this.transfer,
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
      map['owner'] = Variable<int>(owner.value);
    }
    if (payload.present) {
      final converter = $CardItemTable.$converter0;
      map['payload'] = Variable<int>(converter.mapToSql(payload.value));
    }
    if (transfer.present) {
      map['transfer'] = Variable<int>(transfer.value);
    }
    if (received.present) {
      map['received'] = Variable<DateTime>(received.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CardItemCompanion(')
          ..write('id: $id, ')
          ..write('owner: $owner, ')
          ..write('payload: $payload, ')
          ..write('transfer: $transfer, ')
          ..write('received: $received')
          ..write(')'))
        .toString();
  }
}

class $CardItemTable extends CardItem
    with TableInfo<$CardItemTable, CardItemData> {
  final GeneratedDatabase _db;
  final String _alias;
  $CardItemTable(this._db, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  GeneratedIntColumn _id;
  @override
  GeneratedIntColumn get id => _id ??= _constructId();
  GeneratedIntColumn _constructId() {
    return GeneratedIntColumn('id', $tableName, false,
        hasAutoIncrement: true, declaredAsPrimaryKey: true);
  }

  final VerificationMeta _ownerMeta = const VerificationMeta('owner');
  GeneratedIntColumn _owner;
  @override
  GeneratedIntColumn get owner => _owner ??= _constructOwner();
  GeneratedIntColumn _constructOwner() {
    return GeneratedIntColumn(
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

  final VerificationMeta _transferMeta = const VerificationMeta('transfer');
  GeneratedIntColumn _transfer;
  @override
  GeneratedIntColumn get transfer => _transfer ??= _constructTransfer();
  GeneratedIntColumn _constructTransfer() {
    return GeneratedIntColumn(
      'transfer',
      $tableName,
      false,
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
      [id, owner, payload, transfer, received];
  @override
  $CardItemTable get asDslTable => this;
  @override
  String get $tableName => _alias ?? 'card_item';
  @override
  final String actualTableName = 'card_item';
  @override
  VerificationContext validateIntegrity(Insertable<CardItemData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id'], _idMeta));
    }
    if (data.containsKey('owner')) {
      context.handle(
          _ownerMeta, owner.isAcceptableOrUnknown(data['owner'], _ownerMeta));
    } else if (isInserting) {
      context.missing(_ownerMeta);
    }
    context.handle(_payloadMeta, const VerificationResult.success());
    if (data.containsKey('transfer')) {
      context.handle(_transferMeta,
          transfer.isAcceptableOrUnknown(data['transfer'], _transferMeta));
    } else if (isInserting) {
      context.missing(_transferMeta);
    }
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
  CardItemData map(Map<String, dynamic> data, {String tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : null;
    return CardItemData.fromData(data, _db, prefix: effectivePrefix);
  }

  @override
  $CardItemTable createAlias(String alias) {
    return $CardItemTable(_db, alias);
  }

  static TypeConverter<Payload, int> $converter0 = const PayloadConverter();
}

class Owner extends DataClass implements Insertable<Owner> {
  final int id;
  final String profile;
  final String firstName;
  final String lastName;
  final String userName;
  Owner(
      {@required this.id,
      @required this.profile,
      @required this.firstName,
      @required this.lastName,
      @required this.userName});
  factory Owner.fromData(Map<String, dynamic> data, GeneratedDatabase db,
      {String prefix}) {
    final effectivePrefix = prefix ?? '';
    final intType = db.typeSystem.forDartType<int>();
    final stringType = db.typeSystem.forDartType<String>();
    return Owner(
      id: intType.mapFromDatabaseResponse(data['${effectivePrefix}id']),
      profile:
          stringType.mapFromDatabaseResponse(data['${effectivePrefix}profile']),
      firstName: stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}first_name']),
      lastName: stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}last_name']),
      userName: stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}user_name']),
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (!nullToAbsent || id != null) {
      map['id'] = Variable<int>(id);
    }
    if (!nullToAbsent || profile != null) {
      map['profile'] = Variable<String>(profile);
    }
    if (!nullToAbsent || firstName != null) {
      map['first_name'] = Variable<String>(firstName);
    }
    if (!nullToAbsent || lastName != null) {
      map['last_name'] = Variable<String>(lastName);
    }
    if (!nullToAbsent || userName != null) {
      map['user_name'] = Variable<String>(userName);
    }
    return map;
  }

  OwnersCompanion toCompanion(bool nullToAbsent) {
    return OwnersCompanion(
      id: id == null && nullToAbsent ? const Value.absent() : Value(id),
      profile: profile == null && nullToAbsent
          ? const Value.absent()
          : Value(profile),
      firstName: firstName == null && nullToAbsent
          ? const Value.absent()
          : Value(firstName),
      lastName: lastName == null && nullToAbsent
          ? const Value.absent()
          : Value(lastName),
      userName: userName == null && nullToAbsent
          ? const Value.absent()
          : Value(userName),
    );
  }

  factory Owner.fromJson(Map<String, dynamic> json,
      {ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return Owner(
      id: serializer.fromJson<int>(json['id']),
      profile: serializer.fromJson<String>(json['profile']),
      firstName: serializer.fromJson<String>(json['firstName']),
      lastName: serializer.fromJson<String>(json['lastName']),
      userName: serializer.fromJson<String>(json['userName']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'profile': serializer.toJson<String>(profile),
      'firstName': serializer.toJson<String>(firstName),
      'lastName': serializer.toJson<String>(lastName),
      'userName': serializer.toJson<String>(userName),
    };
  }

  Owner copyWith(
          {int id,
          String profile,
          String firstName,
          String lastName,
          String userName}) =>
      Owner(
        id: id ?? this.id,
        profile: profile ?? this.profile,
        firstName: firstName ?? this.firstName,
        lastName: lastName ?? this.lastName,
        userName: userName ?? this.userName,
      );
  @override
  String toString() {
    return (StringBuffer('Owner(')
          ..write('id: $id, ')
          ..write('profile: $profile, ')
          ..write('firstName: $firstName, ')
          ..write('lastName: $lastName, ')
          ..write('userName: $userName')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => $mrjf($mrjc(
      id.hashCode,
      $mrjc(
          profile.hashCode,
          $mrjc(firstName.hashCode,
              $mrjc(lastName.hashCode, userName.hashCode)))));
  @override
  bool operator ==(dynamic other) =>
      identical(this, other) ||
      (other is Owner &&
          other.id == this.id &&
          other.profile == this.profile &&
          other.firstName == this.firstName &&
          other.lastName == this.lastName &&
          other.userName == this.userName);
}

class OwnersCompanion extends UpdateCompanion<Owner> {
  final Value<int> id;
  final Value<String> profile;
  final Value<String> firstName;
  final Value<String> lastName;
  final Value<String> userName;
  const OwnersCompanion({
    this.id = const Value.absent(),
    this.profile = const Value.absent(),
    this.firstName = const Value.absent(),
    this.lastName = const Value.absent(),
    this.userName = const Value.absent(),
  });
  OwnersCompanion.insert({
    this.id = const Value.absent(),
    @required String profile,
    @required String firstName,
    @required String lastName,
    @required String userName,
  })  : profile = Value(profile),
        firstName = Value(firstName),
        lastName = Value(lastName),
        userName = Value(userName);
  static Insertable<Owner> custom({
    Expression<int> id,
    Expression<String> profile,
    Expression<String> firstName,
    Expression<String> lastName,
    Expression<String> userName,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (profile != null) 'profile': profile,
      if (firstName != null) 'first_name': firstName,
      if (lastName != null) 'last_name': lastName,
      if (userName != null) 'user_name': userName,
    });
  }

  OwnersCompanion copyWith(
      {Value<int> id,
      Value<String> profile,
      Value<String> firstName,
      Value<String> lastName,
      Value<String> userName}) {
    return OwnersCompanion(
      id: id ?? this.id,
      profile: profile ?? this.profile,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      userName: userName ?? this.userName,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (profile.present) {
      map['profile'] = Variable<String>(profile.value);
    }
    if (firstName.present) {
      map['first_name'] = Variable<String>(firstName.value);
    }
    if (lastName.present) {
      map['last_name'] = Variable<String>(lastName.value);
    }
    if (userName.present) {
      map['user_name'] = Variable<String>(userName.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('OwnersCompanion(')
          ..write('id: $id, ')
          ..write('profile: $profile, ')
          ..write('firstName: $firstName, ')
          ..write('lastName: $lastName, ')
          ..write('userName: $userName')
          ..write(')'))
        .toString();
  }
}

class $OwnersTable extends Owners with TableInfo<$OwnersTable, Owner> {
  final GeneratedDatabase _db;
  final String _alias;
  $OwnersTable(this._db, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  GeneratedIntColumn _id;
  @override
  GeneratedIntColumn get id => _id ??= _constructId();
  GeneratedIntColumn _constructId() {
    return GeneratedIntColumn('id', $tableName, false,
        hasAutoIncrement: true, declaredAsPrimaryKey: true);
  }

  final VerificationMeta _profileMeta = const VerificationMeta('profile');
  GeneratedTextColumn _profile;
  @override
  GeneratedTextColumn get profile => _profile ??= _constructProfile();
  GeneratedTextColumn _constructProfile() {
    return GeneratedTextColumn(
      'profile',
      $tableName,
      false,
    );
  }

  final VerificationMeta _firstNameMeta = const VerificationMeta('firstName');
  GeneratedTextColumn _firstName;
  @override
  GeneratedTextColumn get firstName => _firstName ??= _constructFirstName();
  GeneratedTextColumn _constructFirstName() {
    return GeneratedTextColumn(
      'first_name',
      $tableName,
      false,
    );
  }

  final VerificationMeta _lastNameMeta = const VerificationMeta('lastName');
  GeneratedTextColumn _lastName;
  @override
  GeneratedTextColumn get lastName => _lastName ??= _constructLastName();
  GeneratedTextColumn _constructLastName() {
    return GeneratedTextColumn(
      'last_name',
      $tableName,
      false,
    );
  }

  final VerificationMeta _userNameMeta = const VerificationMeta('userName');
  GeneratedTextColumn _userName;
  @override
  GeneratedTextColumn get userName => _userName ??= _constructUserName();
  GeneratedTextColumn _constructUserName() {
    return GeneratedTextColumn(
      'user_name',
      $tableName,
      false,
    );
  }

  @override
  List<GeneratedColumn> get $columns =>
      [id, profile, firstName, lastName, userName];
  @override
  $OwnersTable get asDslTable => this;
  @override
  String get $tableName => _alias ?? 'owners';
  @override
  final String actualTableName = 'owners';
  @override
  VerificationContext validateIntegrity(Insertable<Owner> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id'], _idMeta));
    }
    if (data.containsKey('profile')) {
      context.handle(_profileMeta,
          profile.isAcceptableOrUnknown(data['profile'], _profileMeta));
    } else if (isInserting) {
      context.missing(_profileMeta);
    }
    if (data.containsKey('first_name')) {
      context.handle(_firstNameMeta,
          firstName.isAcceptableOrUnknown(data['first_name'], _firstNameMeta));
    } else if (isInserting) {
      context.missing(_firstNameMeta);
    }
    if (data.containsKey('last_name')) {
      context.handle(_lastNameMeta,
          lastName.isAcceptableOrUnknown(data['last_name'], _lastNameMeta));
    } else if (isInserting) {
      context.missing(_lastNameMeta);
    }
    if (data.containsKey('user_name')) {
      context.handle(_userNameMeta,
          userName.isAcceptableOrUnknown(data['user_name'], _userNameMeta));
    } else if (isInserting) {
      context.missing(_userNameMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Owner map(Map<String, dynamic> data, {String tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : null;
    return Owner.fromData(data, _db, prefix: effectivePrefix);
  }

  @override
  $OwnersTable createAlias(String alias) {
    return $OwnersTable(_db, alias);
  }
}

class Transfer extends DataClass implements Insertable<Transfer> {
  final int id;
  final Contact contact;
  final Metadata metadata;
  final URLLink url;
  Transfer({@required this.id, this.contact, this.metadata, this.url});
  factory Transfer.fromData(Map<String, dynamic> data, GeneratedDatabase db,
      {String prefix}) {
    final effectivePrefix = prefix ?? '';
    final intType = db.typeSystem.forDartType<int>();
    final stringType = db.typeSystem.forDartType<String>();
    return Transfer(
      id: intType.mapFromDatabaseResponse(data['${effectivePrefix}id']),
      contact: $TransfersTable.$converter0.mapToDart(stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}contact'])),
      metadata: $TransfersTable.$converter1.mapToDart(stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}metadata'])),
      url: $TransfersTable.$converter2.mapToDart(
          stringType.mapFromDatabaseResponse(data['${effectivePrefix}url'])),
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (!nullToAbsent || id != null) {
      map['id'] = Variable<int>(id);
    }
    if (!nullToAbsent || contact != null) {
      final converter = $TransfersTable.$converter0;
      map['contact'] = Variable<String>(converter.mapToSql(contact));
    }
    if (!nullToAbsent || metadata != null) {
      final converter = $TransfersTable.$converter1;
      map['metadata'] = Variable<String>(converter.mapToSql(metadata));
    }
    if (!nullToAbsent || url != null) {
      final converter = $TransfersTable.$converter2;
      map['url'] = Variable<String>(converter.mapToSql(url));
    }
    return map;
  }

  TransfersCompanion toCompanion(bool nullToAbsent) {
    return TransfersCompanion(
      id: id == null && nullToAbsent ? const Value.absent() : Value(id),
      contact: contact == null && nullToAbsent
          ? const Value.absent()
          : Value(contact),
      metadata: metadata == null && nullToAbsent
          ? const Value.absent()
          : Value(metadata),
      url: url == null && nullToAbsent ? const Value.absent() : Value(url),
    );
  }

  factory Transfer.fromJson(Map<String, dynamic> json,
      {ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return Transfer(
      id: serializer.fromJson<int>(json['id']),
      contact: serializer.fromJson<Contact>(json['contact']),
      metadata: serializer.fromJson<Metadata>(json['metadata']),
      url: serializer.fromJson<URLLink>(json['url']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'contact': serializer.toJson<Contact>(contact),
      'metadata': serializer.toJson<Metadata>(metadata),
      'url': serializer.toJson<URLLink>(url),
    };
  }

  Transfer copyWith(
          {int id, Contact contact, Metadata metadata, URLLink url}) =>
      Transfer(
        id: id ?? this.id,
        contact: contact ?? this.contact,
        metadata: metadata ?? this.metadata,
        url: url ?? this.url,
      );
  @override
  String toString() {
    return (StringBuffer('Transfer(')
          ..write('id: $id, ')
          ..write('contact: $contact, ')
          ..write('metadata: $metadata, ')
          ..write('url: $url')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => $mrjf($mrjc(id.hashCode,
      $mrjc(contact.hashCode, $mrjc(metadata.hashCode, url.hashCode))));
  @override
  bool operator ==(dynamic other) =>
      identical(this, other) ||
      (other is Transfer &&
          other.id == this.id &&
          other.contact == this.contact &&
          other.metadata == this.metadata &&
          other.url == this.url);
}

class TransfersCompanion extends UpdateCompanion<Transfer> {
  final Value<int> id;
  final Value<Contact> contact;
  final Value<Metadata> metadata;
  final Value<URLLink> url;
  const TransfersCompanion({
    this.id = const Value.absent(),
    this.contact = const Value.absent(),
    this.metadata = const Value.absent(),
    this.url = const Value.absent(),
  });
  TransfersCompanion.insert({
    this.id = const Value.absent(),
    this.contact = const Value.absent(),
    this.metadata = const Value.absent(),
    this.url = const Value.absent(),
  });
  static Insertable<Transfer> custom({
    Expression<int> id,
    Expression<Contact> contact,
    Expression<Metadata> metadata,
    Expression<URLLink> url,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (contact != null) 'contact': contact,
      if (metadata != null) 'metadata': metadata,
      if (url != null) 'url': url,
    });
  }

  TransfersCompanion copyWith(
      {Value<int> id,
      Value<Contact> contact,
      Value<Metadata> metadata,
      Value<URLLink> url}) {
    return TransfersCompanion(
      id: id ?? this.id,
      contact: contact ?? this.contact,
      metadata: metadata ?? this.metadata,
      url: url ?? this.url,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (contact.present) {
      final converter = $TransfersTable.$converter0;
      map['contact'] = Variable<String>(converter.mapToSql(contact.value));
    }
    if (metadata.present) {
      final converter = $TransfersTable.$converter1;
      map['metadata'] = Variable<String>(converter.mapToSql(metadata.value));
    }
    if (url.present) {
      final converter = $TransfersTable.$converter2;
      map['url'] = Variable<String>(converter.mapToSql(url.value));
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TransfersCompanion(')
          ..write('id: $id, ')
          ..write('contact: $contact, ')
          ..write('metadata: $metadata, ')
          ..write('url: $url')
          ..write(')'))
        .toString();
  }
}

class $TransfersTable extends Transfers
    with TableInfo<$TransfersTable, Transfer> {
  final GeneratedDatabase _db;
  final String _alias;
  $TransfersTable(this._db, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  GeneratedIntColumn _id;
  @override
  GeneratedIntColumn get id => _id ??= _constructId();
  GeneratedIntColumn _constructId() {
    return GeneratedIntColumn('id', $tableName, false,
        hasAutoIncrement: true, declaredAsPrimaryKey: true);
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

  @override
  List<GeneratedColumn> get $columns => [id, contact, metadata, url];
  @override
  $TransfersTable get asDslTable => this;
  @override
  String get $tableName => _alias ?? 'transfers';
  @override
  final String actualTableName = 'transfers';
  @override
  VerificationContext validateIntegrity(Insertable<Transfer> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id'], _idMeta));
    }
    context.handle(_contactMeta, const VerificationResult.success());
    context.handle(_metadataMeta, const VerificationResult.success());
    context.handle(_urlMeta, const VerificationResult.success());
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Transfer map(Map<String, dynamic> data, {String tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : null;
    return Transfer.fromData(data, _db, prefix: effectivePrefix);
  }

  @override
  $TransfersTable createAlias(String alias) {
    return $TransfersTable(_db, alias);
  }

  static TypeConverter<Contact, String> $converter0 = const ContactConverter();
  static TypeConverter<Metadata, String> $converter1 =
      const MetadataConverter();
  static TypeConverter<URLLink, String> $converter2 = const URLConverter();
}

abstract class _$CardsDatabase extends GeneratedDatabase {
  _$CardsDatabase(QueryExecutor e) : super(SqlTypeSystem.defaultInstance, e);
  $CardItemTable _cardItem;
  $CardItemTable get cardItem => _cardItem ??= $CardItemTable(this);
  $OwnersTable _owners;
  $OwnersTable get owners => _owners ??= $OwnersTable(this);
  $TransfersTable _transfers;
  $TransfersTable get transfers => _transfers ??= $TransfersTable(this);
  @override
  Iterable<TableInfo> get allTables => allSchemaEntities.whereType<TableInfo>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities =>
      [cardItem, owners, transfers];
}
