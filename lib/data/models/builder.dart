import 'package:sonr_app/env.dart';
import 'package:sonr_app/pages/register/models/status.dart';
import 'package:sonr_app/style/style.dart';
import 'package:flutter/foundation.dart';

class RequestBuilder {
  // Request References
  static Device get device => DeviceService.device;
  static Contact get contact => ContactService.contact.value;

  /// Returns New Connection Request
  static Future<ConnectionRequest> get connection async => ConnectionRequest(
        apiKeys: AppServices.apiKeys,
        location: await DeviceService.location,
        contact: ContactService.contact.value,
        type: DeviceService.connectivity.value.toInternetType(),
        status: ContactService.status.value.toConnectionStatus(),
        serviceOptions: ConnectionRequest_ServiceOptions(
          textile: true,
          push: true,
          mailbox: DeviceService.isIOS,
          threadDB: Env.thread_db,
        ),
        hostOptions: ConnectionRequest_HostOptions(mdnsDiscovery: true),
        pushToken: DeviceService.isMobile ? ContactService.pushToken.value : "",
      );

  /// Returns New Initialize Request
  static InitializeRequest get initialize => InitializeRequest(
        apiKeys: AppServices.apiKeys,
        device: DeviceService.device,
        logLevel: BuildModeUtil.logLevel(),
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
  static Future<Peer?> findPeerRecord(String query) async {
    final result = await refresh();
    final record = result.records.firstWhere(
      (e) => e.host.toLowerCase() == query.toLowerCase(),
      orElse: () => HSRecord.blank(),
    );
    return record.toPeer();
  }

  /// Find Records for User
  static Future<List<HSRecord>> get userRecords async {
    final result = await refresh();
    final records = result.records.where(
      (e) => e.host.toLowerCase() == ContactService.sName || e.name.toLowerCase() == ContactService.sName,
    );
    return records.toList();
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

/// ## AnalyticsUserEvent
/// Enum Containing Possible User Analytics Events
enum AnalyticsUserEvent {
  /// User Created SName
  NewSName,

  /// User Linked Device to Account
  LinkedDevice,

  /// User Migrated SName to Latest Spec
  MigratedSName,

  /// User Shared/Copied SName to Share Externally
  SharedSName,

  /// User Updated Contact Card / Profile
  UpdatedProfile,

  /// User Updated App Settings
  UpdatedSettings,
}

/// ## AnalyticsUserEventUtil
/// Enum Extension for `AnalyticsUserEvent`
extension AnalyticsUserEventUtil on AnalyticsUserEvent {
  /// Returns Name of this Event
  String get name {
    // Get Value String
    final value = this.toString().substring(this.toString().indexOf('.') + 1);

    // Create RegExp
    final K_PASCAL_REGEX = RegExp(r"(?:[A-Z]+|^)[a-z]*");

    // Find Words
    final pascalWords = K_PASCAL_REGEX.allMatches(value).map((m) => m[0]).toList();

    // Initialize Name
    String name = "";

    // Iterate Words and Return Name
    pascalWords.forEach((w) {
      if (w != null) {
        name += w;
      }
    });
    return name;
  }
}

/// ## AnalyticsEvent
/// - Class Creates Paramters to Log Effective Analytics event
class AnalyticsEvent {
  // Constructer
  AnalyticsEvent({required this.name, required this.parameters});

  /// Transfer Event Type
  final String name;

  /// User Event Type
  final Map<String, dynamic> parameters;

  /// ### AnalyticsEvent`.invited()`
  /// - Creates Analytics Transfer Invite Shared Event
  factory AnalyticsEvent.invited(InviteRequest request) =>
      AnalyticsEvent(name: request.eventName, parameters: _buildMetadata(request.eventMetadata, addPlatform: false));

  /// ### AnalyticsEvent`.responded()`
  /// - Creates Analytics Transfer Invite Response Event
  factory AnalyticsEvent.responded(InviteResponse response) =>
      AnalyticsEvent(name: response.eventName, parameters: _buildMetadata(response.eventMetadata, addPlatform: false));

  /// ### AnalyticsEvent`.user()`
  /// Creates Analytics Transfer Event
  factory AnalyticsEvent.user(AnalyticsUserEvent event, {Map<String, dynamic>? parameters}) => AnalyticsEvent(
        name: event.name,
        parameters: _buildMetadata(parameters),
      );

  /// #### Helper: Generates Event Metadata
  static Map<String, dynamic> _buildMetadata(Map<String, dynamic>? metadata, {bool addPlatform = true}) {
    // Check if Metadata is not Null
    if (metadata != null) {
      // Add to Existing Map
      metadata["createdAt"] = DateTime.now().toString();

      // Check for Platform
      if (addPlatform) {
        metadata["platform"] = DeviceService.device.platform.toString();
      }
      return metadata;
    } else {
      // Create New Map
      var map = {
        "createdAt": DateTime.now().toString(),
        "platform": DeviceService.device.platform,
      };

      // Check Platform
      if (addPlatform) {
        map["platform"] = DeviceService.device.platform.toString();
      }
      return map;
    }
  }
}
