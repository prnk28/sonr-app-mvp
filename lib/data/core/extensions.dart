import 'dart:math';
import 'package:geolocator/geolocator.dart' as geo;
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:sonr_app/data/data.dart';
import 'package:sonr_app/style/style.dart';

extension ListUtils<T> on List<T> {
  random() {
    final rand = Random();
    return this[rand.nextInt(this.length)];
  }

  void swap(int index1, int index2) {
    var length = this.length;
    RangeError.checkValidIndex(index1, this, "index1", length);
    RangeError.checkValidIndex(index2, this, "index2", length);
    if (index1 != index2) {
      var tmp1 = this[index1];
      this[index1] = this[index2];
      this[index2] = tmp1;
    }
  }
}

extension StringUtils on String {
  /// Check if this String is any of the Given list of Strings
  bool isAny(List<String> opts) => opts.any((element) => element == this);

  bool isOneOf(List<String> options) {
    bool contains = false;
    options.forEach((i) {
      if (this == i) {
        contains = true;
      }
    });
    return contains;
  }
}

extension NumUtils on int {
  bool isOneOf(List<int> options) {
    bool contains = false;
    options.forEach((i) {
      if (this == i) {
        contains = true;
      }
    });
    return contains;
  }
}

extension ConnectivityResultUtils on ConnectivityResult {
  /// Convert Package Enum to ConnectionRequest_InternetType enum
  ConnectionRequest_InternetType toInternetType() {
    switch (this) {
      case ConnectivityResult.wifi:
        return ConnectionRequest_InternetType.WIFI;
      case ConnectivityResult.mobile:
        return ConnectionRequest_InternetType.MOBILE;
      case ConnectivityResult.none:
        return ConnectionRequest_InternetType.OFFLINE;
      case ConnectivityResult.ethernet:
        return ConnectionRequest_InternetType.WIFI;
    }
  }

  bool get hasInternet => this != ConnectivityResult.none;
}

extension DNSRecordUtils on DNSRecord {
  /// Convert this DNSRecord to Sonr Proto Peer
  Future<Peer> toPeer() async {
    return Peer(
        sName: this.name,
        id: Peer_ID(
          publicKey: this.publicKey
        ));
  }
}

extension GeoLocaterPosition on geo.Position {
  /// Convert this Position to Sonr Proto Location
  Location toSonrLocation() {
    // Return Location
    return Location(
      longitude: this.longitude,
      latitude: this.latitude,
    );
  }
}
