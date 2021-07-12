import 'package:sonr_app/env.dart';
import 'package:sonr_app/pages/register/models/status.dart';
import 'package:sonr_app/style/style.dart';
import 'package:flutter/foundation.dart';

class RequestBuilder {
  // Request References
  static Device get device => DeviceService.device;
  static Contact get contact => ContactService.contact.value;
  static ConnectionRequest_InternetType get internetType => DeviceService.connectivity.value.toInternetType();
  static ConnectionRequest_UserStatus get userStatus => ContactService.status.value.toConnectionStatus();

  /// Define Connection Request Options
  static ConnectionRequest_HostOptions get _hostOpts => ConnectionRequest_HostOptions(mdnsDiscovery: true);
  static ConnectionRequest_PubsubOptions get _pubsubOpts => ConnectionRequest_PubsubOptions(relay: true);
  static ConnectionRequest_TextileOptions get _textileOpts => ConnectionRequest_TextileOptions(
        enabled: true,
        mailbox: DeviceService.isIOS,
        threadDB: Env.thread_db,
      );

  /// Returns New Connection Request
  static Future<ConnectionRequest> get connection async => ConnectionRequest(
        apiKeys: AppServices.apiKeys,
        location: await DeviceService.location,
        contact: ContactService.contact.value,
        type: internetType,
        status: userStatus,
        textileOptions: _textileOpts,
        hostOptions: _hostOpts,
        pubsubOptions: _pubsubOpts,
      );

  /// Returns New Initialize Request
  static InitializeRequest get initialize => InitializeRequest(
        apiKeys: AppServices.apiKeys,
        device: DeviceService.device,
      );

  /// Returns New Contact Update Request
  static UpdateRequest get updateContact => API.newUpdateContact(contact);

  /// Returns New Position Update Request
  static UpdateRequest get updatePosition => API.newUpdatePosition(DeviceService.position.value);

  /// Returns New Properties Update Request
  static UpdateRequest get updateProperties => API.newUpdateProperties(Preferences.properties.value);
}

class CommentGenerator {
  /// Prints SVG Icons to Console
  /// - Copy and Paste into Enum to make it visible project wide.
  /// - Set the Project Directory Variable
  static void logSVGIcons() {
    // Update Me
    final projectDir = '/Users/prad/Sonr/app/';

    // Iterate and Print
    for (var s in ComplexIcons.values) {
      debugPrint('/// ### SVGIcons - `${s.value}`');
      debugPrint('/// !["Image of ${s.value}"](${s.fullPath(projectDir)})');
      debugPrint('/// !["Image of ${s.value} as Dots"](${s.fullPath(projectDir, withDots: true)})');
      debugPrint('${s.value},');
      debugPrint('\n');
    }
  }
}

/// Class Manages Namebase DNS Entries
class NamebaseClient {
  // @ Internal Reference
  static final _nbClient = NamebaseApi(keys: AppServices.apiKeys);

  /// Add Records to DNS Table
  static Future<bool> addRecords(List<HSRecord> records) => _nbClient.addRecords(records);

  /// Find Matching Peer for SName Query of Record
  static Future<Peer?> findPeerRecord(String query, {bool logging = false}) async {
    final result = await refresh();
    final record = result.records.firstWhere(
      (e) => e.host.toLowerCase() == query.toLowerCase(),
      orElse: () => HSRecord.blank(),
    );
    return record.toPeer();
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
