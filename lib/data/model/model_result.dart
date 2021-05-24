import 'package:get/get_connect/connect.dart';
import 'package:sonr_app/data/data.dart';
import 'package:sonr_app/service/device/mobile.dart';

enum NameCheckType {
  All,
  Available,
  Blocked,
  InvalidPrefix,
  Restricted,
  Unblocked,
  Unrestricted,
  Unavailable,
  ValidPrefix,
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
  factory UsernameResult.isValidFetch(String username) =>
      UsernameResult(username: username, isValid: true, prefix: MobileService.prefix, mnemonic: MobileService.mnemonic);

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

  /// Checks if Name Provided with Prefix is Available
  bool isPrefixAvailable(String n) => !records.any((r) => r.equalsPrefix(MobileService.newPrefix(n)));

  /// Checks if Name Provided is Valid with ALL Checks
  bool isValidName(String n) => isNameAvailable(n) && isNameUnblocked(n) && isNameUnrestricted(n) && isPrefixAvailable(n);

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
      case NameCheckType.ValidPrefix:
        return isPrefixAvailable(name);
      case NameCheckType.All:
        return isValidName(name);
      case NameCheckType.Blocked:
        return !isNameUnblocked(name);
      case NameCheckType.InvalidPrefix:
        return !isPrefixAvailable(name);
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
