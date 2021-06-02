// import 'dart:async';

// // import 'package:flutter_ble_peripheral/flutter_ble_peripheral.dart';
// import 'package:sonr_app/style/style.dart';
// import 'package:flutter_blue/flutter_blue.dart';

// class BLEService extends GetxService {
//   // Static Analyzers
//   static bool get isRegistered => Get.isRegistered<LobbyService>();
//   static BLEService get to => Get.find<BLEService>();

//   // @ Properties
//   final _devices = RxList<BLEDevice>();
//   final _selfUdid = BLESonrUdid("").obs;
//   final _status = BLEStatus.None.obs;

//   // @ References
//   final FlutterBlue _reader = FlutterBlue.instance;
//   // final FlutterBlePeripheral _writer = FlutterBlePeripheral();
//   late StreamSubscription _deviceStream;

//   /// * Initializes Service for Mobile Devices *
//   Future<BLEService> init() async {
//     // Set Status from Availibility
//     _status(BLEStatusUtils.fromData(Tuple(await _reader.isAvailable, await _reader.isOn)));

//     // Bind Status Stream
//     return this;
//   }

//   /// #### Inititalize MultiAddr from Connected SonrService
//   static Future<void> initMultiAddr(String maddr) async {
//     // Check if Platform is Mobile
//     if (DeviceService.isMobile) {
//       // Set Udid
//       to._selfUdid(BLESonrUdid.fromData(DeviceService.platform, maddr));

//       print("MultiAddr: " + maddr);
//       // Begin Scanning
//       // to._startAdvertise();
//     }
//   }

//   /// #### Begin Discovery of Peers
//   static Future<void> discover(String maddr) async {
//     if (DeviceService.isMobile) {
//       // Scan Devices
//       if (to._status.value.isReady) {
//         // Start scanning
//         to._status(to._status.value.setIsScanning(true));
//         to._refreshScan();
//         to._status(to._status.value.setIsScanning(false));
//       }
//     }
//   }

//   // Helper: Refreshes Scan
//   void _refreshScan() async {
//     // Start Scan with 4s Timeout
//     _reader.startScan(timeout: 4.seconds);

//     // Listen to scan results
//     _deviceStream = _reader.scanResults.listen(_handleScanResults);

//     // Stop scanning
//     _reader.stopScan();
//   }

//   // // Helper: Starts Advertising
//   // void _startAdvertise() async {
//   //   // Check for Not Advertising
//   //   if (!await _writer.isAdvertising()) {
//   //     // Validate Self Udid
//   //     if (_selfUdid.value.isValid) {
//   //       // Start Broadcast
//   //       await _writer.start(_selfUdid.value.toAdvertiseData());
//   //       to._status(to._status.value.setIsAdvertising(true));
//   //     }
//   //   }
//   // }

//   // // Helper: Stops Advertising
//   // void _stopAdvertise() async {
//   //   if (await _writer.isAdvertising()) {
//   //     await _writer.stop();
//   //     to._status(to._status.value.setIsAdvertising(false));
//   //   }
//   // }

//   // Helper: Handles Scan Results
//   void _handleScanResults(List<ScanResult> results) {
//     // Add Devices from Results
//     _devices.addAllScanResults(results);
//     _devices.refresh();
//     _devices.printCount();
//   }

//   // * Handle Close for Service * //
//   @override
//   void onClose() {
//     // _stopAdvertise();
//     _deviceStream.cancel();
//     super.onClose();
//   }
// }
