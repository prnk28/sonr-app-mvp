import 'dart:async';

import 'package:sonr_app/style/style.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:sonr_plugin/sonr_plugin.dart';

Uuid BLE_SONR_SERVICE_ID = Uuid.parse('sonr-ble-discovery');

enum BLECharacteristicType { MultiAddr, Profile, Test }

extension BLECharacteristicUtils on BLECharacteristicType {
  /// Returns UUID for the Characterisitc
  Uuid get uuid => Uuid.parse(this.name.toLowerCase());

  /// Returns Name for Enum Value
  String get name {
    int idx = this.toString().indexOf('.');
    return this.toString().substring(idx + 1);
  }

  /// Returns Qualified Characteristic for This Type
  QualifiedCharacteristic characteristic(String deviceID) {
    return QualifiedCharacteristic(characteristicId: this.uuid, serviceId: BLE_SONR_SERVICE_ID, deviceId: deviceID);
  }
}

extension BleStatusUtils on BleStatus {
  /// Check for Ready
  bool get isReady => this == BleStatus.ready;

  /// Check for Needs Location
  bool get isLocationDisabled => this == BleStatus.locationServicesDisabled;

  /// Check for Not Ready
  bool get isNotReady => this != BleStatus.ready;
}

extension DiscoveredServiceUtils on DiscoveredService {
  /// Checks if Sonr Service
  bool get isSonr => this.serviceId == BLE_SONR_SERVICE_ID;

  /// Checks for MultiAddr Characteristic
  bool get hasMultiAddr => this.characteristicIds.any((c) => c == BLECharacteristicType.MultiAddr.uuid);

  /// Checks for Profile Characteristic
  bool get hasProfile => this.characteristicIds.any((c) => c == BLECharacteristicType.Profile.uuid);

  /// Checks for Test Characteristic
  bool get hasTest => this.characteristicIds.any((c) => c == BLECharacteristicType.Test.uuid);
}

/// #### BLEDevice
/// Class for Managing a Device Found with BLE
class BLEDevice {
  // @ References
  final FlutterReactiveBle ble;
  final DiscoveredDevice device;

  // @ Accessors
  /// Checks if Discovered Device Has Sonr Service
  bool get hasSonr => device.serviceUuids.any((id) => id == BLE_SONR_SERVICE_ID);

  /// Returns this Device ID
  String get id => this.device.id;

  /// Checks if Device is Connected
  DeviceConnectionState get state => this._state;

  // @ Properties
  DeviceConnectionState _state = DeviceConnectionState.disconnected;

  // * Constructer * //
  BLEDevice(this.ble, this.device);

  /// Connect to BLE Device
  StreamSubscription? connect() {
    if (this.hasSonr) {
      return ble.connectToDevice(id: id).listen(_handleConnectionUpdate);
    }
    return null;
  }

  /// Return MultiAddr for this Device
  Future<String?> multiAddr() async {
    // Get Service
    var service = await this._service();

    // Check Service
    if (service != null) {
      // Attempt Reading Characteristic
      try {
        // Get Buffer
        final result = await ble.readCharacteristic(BLECharacteristicType.MultiAddr.characteristic(id));

        // Convert to String
        return String.fromCharCodes(result);
      } on Exception catch (e, _) {
        return null;
      }
    }
  }

  /// Return Profile for this Device
  Future<Profile?> profile() async {
    // Get Service
    var service = await this._service();

    // Check Service
    if (service != null) {
      // Attempt Reading Characteristic
      try {
        // Get Buffer
        final result = await ble.readCharacteristic(BLECharacteristicType.Test.characteristic(id));

        // Convert to String
        var json = String.fromCharCodes(result);
        return Profile.fromJson(json);
      } on Exception catch (e, _) {
        return null;
      }
    }
  }

  /// Return Test for this Device
  Future<String?> test() async {
    // Get Service
    var service = await this._service();

    // Check Service
    if (service != null) {
      // Attempt Reading Characteristic
      try {
        // Get Buffer
        final result = await ble.readCharacteristic(BLECharacteristicType.Test.characteristic(id));

        // Convert to String
        return String.fromCharCodes(result);
      } on Exception catch (e, _) {
        return null;
      }
    }
  }

  // Helper:  Returns Sonr Service
  Future<DiscoveredService?> _service() async {
    if (hasSonr) {
      var services = await await ble.discoverServices(device.id);
      return services.firstWhere((s) => s.isSonr, orElse: (null));
    }
    return null;
  }

  // Helper: Handles Connection Status Update
  void _handleConnectionUpdate(ConnectionStateUpdate update) {
    // Check for Error
    if (update.failure != null) {
      print("BLE Connection Error: " + update.failure.toString());
    } else {
      // Set State
      _state = update.connectionState;
    }
  }
}

extension FlutterReactiveBleUtils on FlutterReactiveBle {
  /// Creates new `BLEDevice`
  BLEDevice newDevice(DiscoveredDevice device) => BLEDevice(this, device);
}
