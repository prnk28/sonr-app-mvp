import 'package:sonr_app/pages/register/models/status.dart';
import 'package:sonr_app/style/style.dart';

/// Class Manages Namebase DNS Entries
class NamebaseClient {
  // @ Internal Reference
  static final _nbClient = NamebaseApi(keys: AppServices.apiKeys);

  /// Add Records to DNS Table
  static Future<bool> addRecords(List<HSRecord> records) => _nbClient.addRecords(records);

  /// Find Matching Peer for SName Query of Record
  static Future<Peer?> findPeerRecord(String query) async {
    final result = await refresh();
    final record = result.records.firstWhere(
      (e) => e.host.toLowerCase() == query.toLowerCase(),
      orElse: () => HSRecord.blank(),
    );
    return record.toPeer();
  }

  /// Check if Auth Record and SName Record Exists
  static Future<bool> hasAllRecords() async {
    return await hasAuthRecord() && await hasSNameRecord();
  }

  /// Check if Auth Record Exists
  static Future<bool> hasAuthRecord() async {
    final list = await userRecords;
    return list.any((e) => e.isAuth);
  }

  /// Check if SName Record Exists
  static Future<bool> hasSNameRecord() async {
    final list = await userRecords;
    return list.any((e) => e.isName);
  }

  /// Print all Records as Peer Data in Console
  static Future<void> printRecords() async {
    final result = await refresh();
    result.records.forEach((r) {
      Logger.info(r.toPeer().toString());
    });
  }

  /// Replace Record
  static Future<Response<dynamic>?> replaceRecord(HSRecord record) => _nbClient.replaceRecord(record);

  /// Refresh Records with Result
  static Future<NamebaseResult> refresh() => _nbClient.refresh();

  /// Find Records for User
  static Future<List<HSRecord>> get userRecords async {
    final result = await refresh();
    final records = result.records.where(
      (e) => e.host.toLowerCase() == ContactService.sName || e.name.toLowerCase() == ContactService.sName,
    );
    return records.toList();
  }

  /// Validates SName as Valid characters
  static Future<NewSNameStatus> validateName(String sName) async {
    final result = await refresh();
    // Check Alphabet Only
    if (!sName.isAlphabetOnly) {
      return NewSNameStatus.InvalidCharacters;
    } else {
      // Update Status
      if (sName.length > 3) {
        // Check Available
        if (result.checkName(NameCheckType.Unavailable, sName)) {
          return NewSNameStatus.Unavailable;
        }
        // Check Unblocked
        else if (result.checkName(NameCheckType.Blocked, sName)) {
          return NewSNameStatus.Blocked;
        }
        // Check Unrestricted
        else if (result.checkName(NameCheckType.Restricted, sName)) {
          return NewSNameStatus.Restricted;
        }
        // Check Valid
        else {
          return NewSNameStatus.Available;
        }
      } else {
        return NewSNameStatus.TooShort;
      }
    }
  }
}
