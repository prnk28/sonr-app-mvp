// stores preferences as strings
import 'dart:convert';

import 'package:moor/moor.dart';
import 'package:sonr_core/sonr_core.dart';

class ContactConverter extends TypeConverter<Contact, String> {
  const ContactConverter();
  @override
  Contact mapToDart(String fromDb) {
    if (fromDb == null) {
      return null;
    }
    return Contact.fromJson(json.decode(fromDb));
  }

  @override
  String mapToSql(Contact value) {
    if (value == null) {
      return null;
    }
    return value.writeToJson();
  }
}

class MetadataConverter extends TypeConverter<Metadata, String> {
  const MetadataConverter();
  @override
  Metadata mapToDart(String fromDb) {
    if (fromDb == null) {
      return null;
    }
    return Metadata.fromJson(json.decode(fromDb));
  }

  @override
  String mapToSql(Metadata value) {
    if (value == null) {
      return null;
    }
    return value.writeToJson();
  }
}

class PayloadConverter extends TypeConverter<Payload, int> {
  const PayloadConverter();
  @override
  Payload mapToDart(int fromDb) {
    if (fromDb == null) {
      return null;
    }
    return Payload.valueOf(fromDb);
  }

  @override
  int mapToSql(Payload value) {
    if (value == null) {
      return null;
    }
    return value.value;
  }
}

class ProfileConverter extends TypeConverter<Profile, String> {
  const ProfileConverter();
  @override
  Profile mapToDart(String fromDb) {
    if (fromDb == null) {
      return null;
    }
    return Profile.fromJson(json.decode(fromDb));
  }

  @override
  String mapToSql(Profile value) {
    if (value == null) {
      return null;
    }
    return value.writeToJson();
  }
}

class URLConverter extends TypeConverter<URLLink, String> {
  const URLConverter();
  @override
  URLLink mapToDart(String fromDb) {
    if (fromDb == null) {
      return null;
    }
    return URLLink.fromJson(json.decode(fromDb));
  }

  @override
  String mapToSql(URLLink value) {
    if (value == null) {
      return null;
    }
    return value.writeToJson();
  }
}
