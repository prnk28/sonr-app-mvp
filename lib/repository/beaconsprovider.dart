import 'dart:async';
import 'dart:io' show Platform;
import 'package:beacon_broadcast/beacon_broadcast.dart';
import 'package:flutter/services.dart';
import 'package:beacons_plugin/beacons_plugin.dart';
import 'package:sonar_app/core/core.dart';

BeaconBroadcast beaconBroadcast = BeaconBroadcast();

class BeaconsProvider {
  initialize(String id) async {
    // Set Debug Level
    BeaconsPlugin.setDebugLevel(1);

    // Set Plugin
    await BeaconsPlugin.addRegion("com.sonr.beacon", id);

    // Begin Monitoring
    await BeaconsPlugin.startMonitoring;

    //IMPORTANT: Start monitoring once scanner is setup & ready (only for Android)
    if (Platform.isAndroid) {
      // Setup Broadcaster
      beaconBroadcast.setUUID(id).setMajorId(1).setMinorId(100).start();

      // Check Transmission Status
      var transmissionSupportStatus =
          await beaconBroadcast.checkTransmissionSupported();
      log.i(enumAsString(transmissionSupportStatus));
    } else if (Platform.isIOS) {
      // Setup Broadcaster
      beaconBroadcast
          .setUUID(id)
          .setMajorId(1)
          .setMinorId(100)
          .setIdentifier('com.sonr.beacon')
          .setLayout('m:2-3=0215,i:4-19,i:20-21,i:22-23,p:24-24')
          .setManufacturerId(0x004C)
          .start();
    }
  }
}
