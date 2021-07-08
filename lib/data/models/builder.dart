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
        mailbox: true, //DeviceService.isIOS,
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
    for (var s in SVGIcons.values) {
      debugPrint('/// ### SVGIcons - `${s.value}`');
      debugPrint('/// !["Image of ${s.value}"](${s.fullPath(projectDir)})');
      debugPrint('/// !["Image of ${s.value} as Dots"](${s.fullPath(projectDir, withDots: true)})');
      debugPrint('${s.value},');
      debugPrint('\n');
    }
  }
}
