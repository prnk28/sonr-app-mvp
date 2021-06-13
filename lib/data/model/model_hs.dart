import 'dart:typed_data';
import 'package:get/get_connect/connect.dart';
import 'package:sonr_app/data/data.dart';

const IDENTITY_DIVIDER = "id=";
const FINGERPRINT_DIVIDER = "v=0;fingerprint=";
const AUTH_DIVIDER = "._auth.";
const TRANSFER_DIVIDER = ".transfer.";

class HSRecord {
  HSRecord({
    required this.ttl,
    required this.type,
    required this.host,
    required this.value,
  });

  int ttl;
  String type;
  String host;
  String value;

  bool get isAuth => this.host.contains(AUTH_DIVIDER);
  bool get isBlank => this.ttl == -1 && this.type == "-" && this.host == "-" && this.value == "-";
  bool get isTransfer => this.host.contains(TRANSFER_DIVIDER);
  Uint8List get fingerprint => isAuth ? extractFingerprint(value) : Uint8List(0);
  String get name => isAuth ? extractName(host) : "";
  String get prefix => isAuth ? extractPrefix(host) : "";

  // Method Checks if Prefix Values are the same
  bool equals(String n, String p) => this.equalsName(n) && this.equalsPrefix(p);
  bool equalsName(String n) => this.name.toLowerCase() == n.toLowerCase();
  bool equalsPrefix(String p) => this.prefix == p;
  bool notEquals(String n, String p) => this.notEqualsName(n) && this.notEqualsPrefix(p);
  bool notEqualsName(String n) => this.name.toLowerCase() != n.toLowerCase();
  bool notEqualsPrefix(String p) => this.prefix != p;

  /// Returns Blank Record
  factory HSRecord.blank() {
    return HSRecord(ttl: -1, type: "-", host: "-", value: "-");
  }

  /// Returns Auth Based Record
  factory HSRecord.newAuth(String prefix, String name, String fingerprint) {
    return HSRecord(ttl: 5, type: "TXT", host: "$prefix$AUTH_DIVIDER$name", value: FINGERPRINT_DIVIDER + fingerprint);
  }

  /// Returns Auth Based Record
  factory HSRecord.newName(String name, String identity) {
    return HSRecord(ttl: 5, type: "TXT", host: name, value: IDENTITY_DIVIDER + identity);
  }

  /// Returns Remote Transfer Based Record
  factory HSRecord.newRemote(String prefix, String name, String fingerprint) {
    return HSRecord(ttl: 5, type: "TXT", host: "$prefix$TRANSFER_DIVIDER$name", value: FINGERPRINT_DIVIDER + fingerprint);
  }

  /// Creates Record From JSON
  factory HSRecord.fromJson(dynamic json) => HSRecord(
        ttl: json["ttl"],
        type: json["type"],
        host: json["host"],
        value: json["value"],
      );

  // Extracts FingerPrint from Record Value
  static Uint8List extractFingerprint(String value) {
    var data = value.substring(FINGERPRINT_DIVIDER.length);
    return Uint8List.fromList(data.codeUnits);
  }

  // Extracts Prefix from Record Host
  static String extractPrefix(String host) {
    var idx = host.indexOf(AUTH_DIVIDER);
    return host.substring(0, idx);
  }

  // Extracts Name from Record Host
  static String extractName(String host) {
    var idx = host.indexOf(AUTH_DIVIDER);
    return host.substring(idx + AUTH_DIVIDER.length);
  }

  Map<String, dynamic> toMap() => {
        "ttl": ttl,
        "type": type,
        "host": host,
        "value": value,
      };

  @override
  String toString() {
    if (this.isAuth) {
      return "--Auth Record-- \n" +
          {
            "Fingerprint": this.fingerprint,
            "Prefix": this.prefix,
            "Name": this.name,
          }.toString();
    } else {
      return "--Default Record-- \n" + this.toMap().toString();
    }
  }
}

enum NameCheckType {
  All,
  Available,
  Blocked,
  Restricted,
  Unblocked,
  Unrestricted,
  Unavailable,
}

/// #### `UsernameResult`
/// Class Returns Username Result when selecting Username
class UsernameResult {
  final bool isValid;
  final String prefix;
  final String mnemonic;
  final String username;

  UsernameResult({
    required this.username,
    required this.isValid,
    required this.prefix,
    required this.mnemonic,
  });

  /// Creates Valid Username Result and Fetch's Prefix and Mnemonic from `MobileService`
  factory UsernameResult.isValidFetch(String username, String prefix, String mnemonic) =>
      UsernameResult(username: username, isValid: true, prefix: prefix, mnemonic: mnemonic);

  /// Creates Invalid Username Result
  factory UsernameResult.isInvalid() => UsernameResult(username: "-", isValid: false, prefix: "-", mnemonic: "-");
}

/// #### `NamebaseResult`
/// Class Returns `NameBase` Records on Refresh
class NamebaseResult {
  final List<HSRecord> records;
  final bool success;
  final bool isBlank;

  /// Checks if Name is not already Taken
  bool isNameAvailable(String n) => !records.any((r) => r.equalsName(n));

  /// Checks if Name not on Blocked List
  bool isNameUnblocked(String n) => !K_BLOCKED_NAMES.any((v) => v == n.toLowerCase());

  /// Checks if Name not on Restricted List
  bool isNameUnrestricted(String n) => !K_RESTRICTED_NAMES.any((v) => v == n.toLowerCase());

  /// Checks if Name Provided is Valid with ALL Checks
  bool isValidName(String n) => isNameAvailable(n) && isNameUnblocked(n) && isNameUnrestricted(n);

  NamebaseResult({required this.success, this.isBlank = false, this.records = const []});

  /// Returns NamebaseResult from `GetConnect` Response
  factory NamebaseResult.fromResponse(Response<dynamic> response) => NamebaseResult(
        isBlank: false,
        success: response.body["success"] ?? false,
        records: List<HSRecord>.from(response.body["records"].map((x) => HSRecord.fromJson(x))),
      );

  /// Returns Blank Namebase Result
  factory NamebaseResult.blank() => NamebaseResult(success: false, isBlank: true);

  /// Checks with `NameCheckType` and Returns bool
  bool checkName(NameCheckType type, String name) {
    switch (type) {
      case NameCheckType.Available:
        return isNameAvailable(name);
      case NameCheckType.Unblocked:
        return isNameUnblocked(name);
      case NameCheckType.Unrestricted:
        return isNameUnrestricted(name);
      case NameCheckType.All:
        return isValidName(name);
      case NameCheckType.Blocked:
        return !isNameUnblocked(name);
      case NameCheckType.Restricted:
        return !isNameUnrestricted(name);
      case NameCheckType.Unavailable:
        return !isNameAvailable(name);
    }
  }

  /// Finds Matching Record with Username and Prefix
  NamebaseRecordResult hasName(String name, String prefix) {
    // Check Exists
    var exists = records.any((r) => r.equals(name, prefix));

    // Find Existing Record
    if (exists) {
      var record = records.firstWhere((r) => r.equals(name, prefix));

      // Return Result
      return NamebaseRecordResult(exists: true, record: record);
    }
    return NamebaseRecordResult(exists: false, record: HSRecord.blank());
  }
}

/// #### `NamebaseRecordResult`
/// Class Returns `HSRecord` and Status on `NamebaseResult.hasName()`
class NamebaseRecordResult {
  final bool exists;
  final HSRecord record;

  NamebaseRecordResult({required this.exists, required this.record});
}
