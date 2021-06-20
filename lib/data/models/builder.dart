import 'package:sonr_app/style.dart';

class RequestBuilder {
  static APIKeys get apiKeys => AppServices.apiKeys;
  static Device get device => DeviceService.device;
  static Contact get contact => ContactService.contact.value;
  static ConnectionRequest_InternetType get internetType => DeviceService.connectivity.value.toInternetType();

  /// Returns New Connection Request
  static Future<ConnectionRequest> get connection async {
    return ConnectionRequest(
      apiKeys: apiKeys,
      location: await DeviceService.location,
      contact: contact,
    );
  }

  /// Returns New Initialize Request
  static InitializeRequest get initialize {
    return InitializeRequest(
      apiKeys: apiKeys,
      device: DeviceService.device,
    );
  }

  /// Returns New Position Update Request
  static UpdateRequest get positionUpdate {
    return Request.newUpdatePosition(DeviceService.isMobile ? MobileService.position.value : DesktopService.position);
  }
}
