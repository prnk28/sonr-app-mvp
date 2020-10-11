import 'dart:async';

import 'package:flutter_beacon/flutter_beacon.dart';
import 'package:beacon_broadcast/beacon_broadcast.dart';
import 'package:sonar_app/core/core.dart';

BeaconBroadcast beaconBroadcast = BeaconBroadcast();
final regions = <Region>[];

class BeaconsProvider {
  setup(String id, String lobbyid) async {
    if (Platform.isIOS) {
      beaconBroadcast
          .setUUID(lobbyid)
          .setMajorId(1)
          .setMinorId(100)
          .setTransmissionPower(-59) //optional
          .setIdentifier(id) //iOS-only, optional
          .setLayout('m:2-3=0215,i:4-19,i:20-21,i:22-23,p:24-24')
          .setManufacturerId(0x004C)
          .start();
    } else if (Platform.isAndroid) {
      // Setup Sender
      beaconBroadcast
          .setUUID(lobbyid)
          .setMajorId(1)
          .setMinorId(100)
          .setTransmissionPower(-59)
          .setLayout(BeaconBroadcast.ALTBEACON_LAYOUT)
          .setManufacturerId(0x0118)
          .start();
    }

    try {
      // if you want to manage manual checking about the required permissions
      await flutterBeacon.initializeScanning;

      // or if you want to include automatic checking permission
      await flutterBeacon.initializeAndCheckScanning;
    } on PlatformException catch (e) {
      // library failed to initialize, check code and message
    }
  }

  addRegion({String id, String proximityUUID}) {
    if (Platform.isIOS) {
      // iOS platform, at least set identifier and proximityUUID for region scanning
      regions.add(Region(identifier: id, proximityUUID: proximityUUID));
    } else {
      // Android platform, it can ranging out of beacon that filter all of Proximity UUID
      regions.add(Region(identifier: proximityUUID));
    }
  }
}
