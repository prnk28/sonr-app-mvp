import 'dart:async';

import 'package:flutter_beacon/flutter_beacon.dart';
import 'package:beacon_broadcast/beacon_broadcast.dart';
import 'package:sonar_app/core/core.dart';

BeaconBroadcast beaconBroadcast = BeaconBroadcast();

class BeaconsProvider {
  StreamSubscription<RangingResult> streamRanging;
  var regionBeacons = <Region, List<Beacon>>{};
  var beacons = <Beacon>[];
  var regions = <Region>[];

  bool authorizationStatusOk = false;
  bool locationServiceEnabled = false;
  bool bluetoothEnabled = false;

  checkAllRequirements() async {
    final bluetoothState = await flutterBeacon.bluetoothState;
    final bluetoothEnabled = bluetoothState == BluetoothState.stateOn;
    final authorizationStatus = await flutterBeacon.authorizationStatus;
    final authorizationStatusOk =
        authorizationStatus == AuthorizationStatus.allowed ||
            authorizationStatus == AuthorizationStatus.always;
    final locationServiceEnabled =
        await flutterBeacon.checkLocationServicesIfEnabled;

    this.authorizationStatusOk = authorizationStatusOk;
    this.locationServiceEnabled = locationServiceEnabled;
    this.bluetoothEnabled = bluetoothEnabled;
  }

  initScanBeacon(String id, String lobbyId) async {
    await flutterBeacon.initializeScanning;
    await checkAllRequirements();
    if (!authorizationStatusOk ||
        !locationServiceEnabled ||
        !bluetoothEnabled) {
      return;
    }
    final regions = <Region>[
      Region(
        identifier: id,
        proximityUUID: lobbyId,
      ),
    ];

    if (streamRanging != null) {
      if (streamRanging.isPaused) {
        streamRanging.resume();
        return;
      }
    }

    streamRanging =
        flutterBeacon.ranging(regions).listen((RangingResult result) {
      print(result);
      if (result != null) {
        regionBeacons[result.region] = result.beacons;
        beacons.clear();
        regionBeacons.values.forEach((list) {
          beacons.addAll(list);
        });
        beacons.sort(_compareParameters);
      }
    });

    // Setup Sender
    if (Platform.isAndroid) {
      beaconBroadcast
          .setUUID(lobbyId)
          .setMajorId(1)
          .setMinorId(100)
          .setTransmissionPower(-59)
          .setIdentifier(id)
          .setLayout(BeaconBroadcast.ALTBEACON_LAYOUT)
          .setManufacturerId(0x0118)
          .start();
    } else if (Platform.isIOS) {
      beaconBroadcast
          .setUUID(lobbyId)
          .setMajorId(2)
          .setMinorId(101)
          .setTransmissionPower(-59) //optional
          .setIdentifier(id) //iOS-only, optional
          .setLayout('m:2-3=0215,i:4-19,i:20-21,i:22-23,p:24-24')
          .setManufacturerId(0x004C)
          .start();
    }
  }

  pauseScanBeacon() async {
    streamRanging?.pause();
    if (beacons.isNotEmpty) {
      beacons.clear();
    }
  }

  int _compareParameters(Beacon a, Beacon b) {
    int compare = a.proximityUUID.compareTo(b.proximityUUID);

    if (compare == 0) {
      compare = a.major.compareTo(b.major);
    }

    if (compare == 0) {
      compare = a.minor.compareTo(b.minor);
    }

    return compare;
  }

  addRegion({String id, String proximityUUID}) {
    // android platform, it can ranging out of beacon that filter all of Proximity UUID
    regions.add(Region(identifier: proximityUUID));
  }
}
