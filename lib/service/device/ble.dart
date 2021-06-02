import 'dart:async';

import 'package:sonr_app/style/style.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';

class BLEService extends GetxService {
  // Static Analyzers
  static bool get isRegistered => Get.isRegistered<LobbyService>();
  static BLEService get to => Get.find<BLEService>();

  // @ Properties
  final _status = BleStatus.unknown.obs;
  final _allDevices = RxList<BLEDevice>();
  final _sonrDevices = RxList<BLEDevice>();

  // @ Accessors
  /// Checks if BLE Discovery is Ready
  bool get isReady => _status.value.isReady;

  /// Checks if BLE Discovery is NOT Ready
  bool get isNotReady => _status.value.isNotReady;

  /// Checks if BLE Discovery CANNOT Start due to Location Services
  bool get isLocationDisabled => _status.value.isLocationDisabled;

  /// Accessor for Device Service ID
  String get deviceId => DeviceService.device.id;

  // @ References
  final FlutterReactiveBle _ble = FlutterReactiveBle();
  late StreamSubscription _allDevicesStream;
  late StreamSubscription _sonrDevicesStream;

  List<StreamSubscription> _connections = [];

  /// Initializes BLEDiscovery for Mobile
  Future<BLEService> init() async {
    // Bind Status Stream
    _status.bindStream(_ble.statusStream);
    return this;
  }

  /// #### Begin Discovery of Peers
  static void discover(String maddr) {
    // Write Characteristic
    to.write(type: BLECharacteristicType.MultiAddr, value: maddr);

    // Scan Devices
    if (to.isReady) {
      // Handle Device Streams
      to._allDevicesStream = to._ble.scanForDevices(withServices: []).listen(to._handleGeneralDevice);

      // Scan for Devices
      to._sonrDevicesStream = to._ble.scanForDevices(withServices: [BLE_SONR_SERVICE_ID]).listen(to._handleSonrDevice);
    }
  }

  /// #### Read
  /// Method Reads Characteristic for Type
  Future<String> read({required BLECharacteristicType type}) async {
    if (isReady) {
      // Write Value
      try {
        // Find Value
        final result = await _ble.readCharacteristic(type.characteristic(deviceId));

        // Return String Value
        return String.fromCharCodes(result);
      } on Exception catch (e, s) {
        // Print Error
        print('Error occured when writing ${type.name} : $e');
        print(s);
        return "";
      }
    } else {
      print('BLE is not Ready: ' + _status.toString());
      return "";
    }
  }

  /// #### Write
  /// Method Writes Characteristic With Type and Value
  Future<void> write({required BLECharacteristicType type, required String value}) async {
    if (isReady) {
      // Write Value
      try {
        await _ble.writeCharacteristicWithoutResponse(type.characteristic(deviceId), value: value.codeUnits);
      } on Exception catch (e, s) {
        print('Error occured when writing ${type.characteristic(deviceId).characteristicId} : $e');
        print(s);
        rethrow;
      }
    } else {
      print('BLE is not Ready: ' + _status.toString());
    }
  }

  // Helper: Handle General BLE Device
  void _handleGeneralDevice(DiscoveredDevice device) {
    // Add Device
    if (_allDevices.contains(device)) {
      _allDevices[_allDevices.indexOf(device)] = _ble.newDevice(device);
    } else {
      _allDevices.add(_ble.newDevice(device));
    }

    // Refresh List
    _allDevices.refresh();
  }

  // Helper: Handle Sonr BLE Device
  void _handleSonrDevice(DiscoveredDevice data) {
    // New Device
    var device = _ble.newDevice(data);

    // Connect to Device
    var sub = device.connect();
    if (sub != null) {
      _connections.add(sub);
    }

    // Refresh List
    _sonrDevices.refresh();
  }

  // * Handle Close for Service * //
  @override
  void onClose() {
    _allDevicesStream.cancel();
    _sonrDevicesStream.cancel();
    _connections.forEach((c) => c.cancel());
    super.onClose();
  }
}
