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
        serviceOptions: ConnectionRequest_ServiceOptions(
          textile: true,
          push: true,
          mailbox: DeviceService.isIOS,
        ),
        hostOptions: ConnectionRequest_HostOptions(
          mdnsDiscovery: true,
        ),
        pushToken: DeviceService.isMobile ? ContactService.pushToken.value : "",
      );

  /// Returns New Initialize Request
  static InitializeRequest get initialize => InitializeRequest(
        apiKeys: AppServices.apiKeys,
        device: DeviceService.device,
        logLevel: BuildModeUtil.logLevel(),
        resetKeys: Logger.hasMigratedKeyPair.val,
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

/// ## AnalyticsUserEvent
/// Enum Containing Possible User Analytics Events
enum UserEvent {
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
extension UserEventUtil on UserEvent {
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
class AppEvent {
  // Constructer
  AppEvent({required this.name, required this.parameters});

  /// Transfer Event Type
  final String name;

  /// User Event Type
  final Map<String, dynamic> parameters;

  /// ### AnalyticsEvent`.invited()`
  /// - Creates Analytics Transfer Invite Shared Event
  factory AppEvent.invited(InviteRequest request) =>
      AppEvent(name: request.eventName, parameters: _buildMetadata(request.eventMetadata, addPlatform: false));

  /// ### AnalyticsEvent`.responded()`
  /// - Creates Analytics Transfer Invite Response Event
  factory AppEvent.responded(InviteResponse response) =>
      AppEvent(name: response.eventName, parameters: _buildMetadata(response.eventMetadata, addPlatform: false));

  /// ### AnalyticsEvent`.user()`
  /// Creates Analytics Transfer Event
  factory AppEvent.user(UserEvent event, {Map<String, dynamic>? parameters}) => AppEvent(
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
