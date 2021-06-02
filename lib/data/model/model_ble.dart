// // import 'package:flutter_ble_peripheral/flutter_ble_peripheral.dart';
// import 'package:flutter_blue/flutter_blue.dart';
// import 'package:sonr_app/style/style.dart';
// import 'package:sonr_plugin/sonr_plugin.dart';

// /// #### BLEDevice
// /// Class for Managing a Device Found with BLE
// class BLEDevice {
//   // @ References
//   final BluetoothDevice device;

//   // @ Accessors
//   /// Checks if Discovered Device Has Sonr Service
//   bool get hasSonr => BLESonrUdid.validate(deviceID);

//   /// Returns this Device ID
//   String get deviceID => this.device.id.id;

//   // * Constructer * //
//   BLEDevice(this.device);

//   /// Return MultiAddr for this Device
//   String get multiAddr {
//     if (this.hasSonr) {
//       // Build UDID
//       var udid = BLESonrUdid(deviceID);

//       // Return MultiAddr
//       return udid.multiAddr;
//     } else {
//       return "";
//     }
//   }

//   /// Return Platform for this Device
//   Platform get platform {
//     if (this.hasSonr) {
//       // Build UDID
//       var udid = BLESonrUdid(deviceID);

//       // Return Platform
//       return udid.platform;
//     } else {
//       return Platform.Undefined;
//     }
//   }
// }

// /// BLE Advertisement UDID in form of SONR_BLE-(Platform)-(MultiAddr)
// class BLESonrUdid {
//   /// Banner Prior to Platform-Multiaddr
//   static const BLE_SONR_BANNER = "SONR_BLE-";

//   /// Initial UDID Index without Sonr Banner
//   static const BLE_START_IDX = BLE_SONR_BANNER.length + 1;

//   /// UDID String Value
//   final String udid;

//   /// Checks if Udid value is Empty
//   bool get isEmpty => this.udid.isEmpty;

//   /// Checks if Udid value is NOT Empty
//   bool get isNotEmpty => this.udid.isNotEmpty;

//   /// Checks if Udid is Valid
//   bool get isValid => this.isNotEmpty && this.udid.contains(BLE_SONR_BANNER);

//   /// Find Index Separator in UDID
//   int get indexSeparator => this.udid.indexOf('-');

//   /// Return MultiAddr from UDID
//   String get multiAddr => this.udid.substring(BLE_START_IDX, indexSeparator + 1);

//   /// Return Device Platform from UDID
//   Platform get platform =>
//       Platform.values.firstWhere((p) => p.toString() == this.udid.substring(BLE_START_IDX, indexSeparator), orElse: () => Platform.Undefined);

//   // * Constructer * //
//   BLESonrUdid(this.udid);

//   // @ Methods //
//   /// #### Method to Convert Value into Advertisement Data
//   // AdvertiseData toAdvertiseData() {
//   //   var _data = AdvertiseData();
//   //   _data.includeDeviceName = false;
//   //   _data.uuid = this.udid;
//   //   _data.txPowerLevel = AdvertisePower.ADVERTISE_TX_POWER_ULTRA_LOW;
//   //   _data.advertiseMode = AdvertiseMode.ADVERTISE_MODE_LOW_LATENCY;
//   //   return _data;
//   // }

//   // @ Static //
//   /// #### Construct BLESonrUdid from Given MultiAddr
//   static BLESonrUdid fromData(Platform platform, String multiAddr) {
//     return BLESonrUdid("$BLE_SONR_BANNER${platform.toString()}-$multiAddr");
//   }

//   /// #### Validates if Given ID contains Sonr UDID
//   static bool validate(String id) {
//     return id.contains(BLE_SONR_BANNER);
//   }
// }

// /// Enum for Current BLEService Status
// enum BLEStatus {
//   /// Default State
//   None,

//   /// Device Incompatible
//   Unavailable,

//   /// Device Compatible, but BLE not On
//   Standby,

//   /// Compatible and On
//   Ready,

//   /// Scanning for Devices
//   Scanning,

//   /// Advertising Self
//   Advertising,
// }

// /// BLEStatusUtils: Extension for BLEStatus for Handling Changes in State
// extension BLEStatusUtils on BLEStatus {
//   // * Constructer * //
//   /// Returns Status from Tuple Data: isAvailible, isOn
//   static BLEStatus fromData(Tuple<bool, bool> data) {
//     if (data.item1) {
//       return data.item2 ? BLEStatus.Ready : BLEStatus.Standby;
//     } else {
//       return BLEStatus.Unavailable;
//     }
//   }

//   // @ Accessors
//   /// Checks if Status is Ready
//   bool get isReady => this == BLEStatus.Ready;

//   /// Checks if Status is NOT Ready
//   bool get isNotReady => this != BLEStatus.Ready;

//   /// Checks if Status is Standby
//   bool get isStandby => this != BLEStatus.Standby;

//   /// Checks if Status is Unavailible
//   bool get isUnavailible => this == BLEStatus.Unavailable;

//   /// Checks if Status is Scanning
//   bool get isScanning => this == BLEStatus.Scanning;

//   /// Checks if Status is Advertising
//   bool get isAdvertising => this == BLEStatus.Advertising;

//   // @ Methods
//   /// Sets Status from isScanning
//   BLEStatus setIsAdvertising(bool val) {
//     if (val) {
//       return BLEStatus.Advertising;
//     } else {
//       return BLEStatus.Ready;
//     }
//   }

//   /// Sets Status from isScanning
//   BLEStatus setIsScanning(bool val) {
//     if (val) {
//       return BLEStatus.Scanning;
//     } else {
//       return BLEStatus.Ready;
//     }
//   }
// }

// /// BLEDeviceListUtils: Helper Methods for Handling BLEDevice List
// extension BLEDeviceListUtils on List<BLEDevice> {
//   /// Returns Number of Sonr Enabled BLE Devices
//   int get lengthSonr => this.where((e) => e.hasSonr).length;

//   /// Returns Sonr Device List filtering all Devices
//   List<BLEDevice> get filteredSonr => this.where((e) => e.hasSonr).toList();

//   /// Builds `DiscoverRequest` from List of Devices
//   DiscoverRequest toDiscoverRequest() => DiscoverRequest(
//         multiaddresses: this.filteredSonr.map<String>((e) => e.multiAddr),
//       );

//   /// Adds BLEDevice from List of ScanResults
//   void addAllScanResults(List<ScanResult> results) {
//     for (ScanResult r in results) {
//       this.addScanResult(r);
//     }
//   }

//   /// Adds BLEDevice from ScanResult
//   void addScanResult(ScanResult r) {
//     this.add(BLEDevice(r.device));
//   }

//   /// Prints Count to Console
//   void printCount() {
//     print("BLE Device Count: ${this.length}");
//     print("SONR Enabled BLE Device Count: ${this.lengthSonr}");
//   }
// }
