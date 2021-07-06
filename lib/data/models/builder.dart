import 'package:sonr_app/style/style.dart';

class RequestBuilder {
  // Request References
  static Device get device => DeviceService.device;
  static Contact get contact => ContactService.contact.value;
  static ConnectionRequest_InternetType get internetType => DeviceService.connectivity.value.toInternetType();
  static ConnectionRequest_UserStatus get userStatus => ContactService.status.value.toConnectionStatus();

  /// Define Connection Request Options
  static ConnectionRequest_HostOptions get _hostOpts => ConnectionRequest_HostOptions(mdnsDiscovery: true);
  static ConnectionRequest_PubsubOptions get _pubsubOpts => ConnectionRequest_PubsubOptions(relay: true);
  static ConnectionRequest_TextileOptions get _textileOpts => ConnectionRequest_TextileOptions(enabled: true, mailbox: true);

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
