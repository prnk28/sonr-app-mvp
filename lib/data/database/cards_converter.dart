// stores preferences as strings
import 'package:moor/moor.dart';
import 'package:sonr_plugin/sonr_plugin.dart';
import 'cards_db.dart';

class ActivityConverter extends TypeConverter<ActivityType, int> {
  const ActivityConverter();
  @override
  ActivityType mapToDart(int fromDb) {
    if (fromDb == null) {
      return null;
    }
    return ActivityType.values[fromDb];
  }

  @override
  int mapToSql(ActivityType value) {
    if (value == null) {
      return null;
    }
    return value.index;
  }
}

class CardConverter extends TypeConverter<TransferCard, String> {
  const CardConverter();
  @override
  TransferCard mapToDart(String fromDb) {
    if (fromDb == null) {
      return null;
    }
    return TransferCard.fromJson(fromDb);
  }

  @override
  String mapToSql(TransferCard value) {
    if (value == null) {
      return null;
    }
    return value.writeToJson();
  }
}

class ContactConverter extends TypeConverter<Contact, String> {
  const ContactConverter();
  @override
  Contact mapToDart(String fromDb) {
    if (fromDb == null) {
      return null;
    }
    return Contact.fromJson(fromDb);
  }

  @override
  String mapToSql(Contact value) {
    if (value == null) {
      return null;
    }
    return value.writeToJson();
  }
}

class FileConverter extends TypeConverter<SonrFile, String> {
  const FileConverter();
  @override
  SonrFile mapToDart(String fromDb) {
    if (fromDb == null) {
      return null;
    }
    return SonrFile.fromJson(fromDb);
  }

  @override
  String mapToSql(SonrFile value) {
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
    return Profile.fromJson(fromDb);
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
    return URLLink.fromJson(fromDb);
  }

  @override
  String mapToSql(URLLink value) {
    if (value == null) {
      return null;
    }
    return value.writeToJson();
  }
}
