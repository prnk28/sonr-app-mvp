import 'dart:convert';
import 'package:crypto/crypto.dart';

const FINGERPRINT_DIVIDER = "v=0;fingerprint=";
const PREFIX_DIVIDER = "._auth.";

class HSResponse {
  HSResponse({
    required this.success,
    required this.records,
  });

  bool success;
  List<HSRecord> records;

  factory HSResponse.fromJson(dynamic json) {
    return HSResponse(
      success: json["success"],
      records: List<HSRecord>.from(json["records"].map((x) => HSRecord.fromJson(x))),
    );
  }

  String toJson() => jsonEncode({
        "success": success,
        "records": List<dynamic>.from(records.map((x) => x.toJson())),
      });
}

class HSRecord {
  HSRecord({
    required this.ttl,
    required this.type,
    required this.host,
    required this.value,
  });

  int ttl;
  String type;
  String host;
  String value;

  bool get isAuth => this.host.contains(PREFIX_DIVIDER);
  String get fingerprint => isAuth ? extractFingerprint(host) : "";
  String get name => isAuth ? extractName(host) : "";
  String get prefix => isAuth ? extractPrefix(host) : "";

  // @ Method Checks if Prefix Values are the same
  Future<bool> checkPrefix(String username, String deviceID) async {
    if (this.name == username) {
      var hmacSha256 = Hmac(sha256, utf8.encode(username + deviceID)); // HMAC-SHA256
      var digest = hmacSha256.convert(utf8.encode(username + deviceID));
      return this.prefix == "$digest".substring(0, 16);
    } else {
      return false;
    }
  }

  factory HSRecord.newAuth(String deviceID, String name, String fingerprint) {
    // Build Prefix
    var hmacSha256 = Hmac(sha256, utf8.encode(name + deviceID)); // HMAC-SHA256
    var digest = hmacSha256.convert(utf8.encode(name + deviceID));
    var prefix = "$digest".substring(0, 16);

    // Return Record
    return HSRecord(ttl: 0, type: "TXT", host: "$prefix._auth.$name.snr", value: FINGERPRINT_DIVIDER + fingerprint);
  }

  factory HSRecord.fromJson(dynamic json) => HSRecord(
        ttl: json["ttl"],
        type: json["type"],
        host: json["host"],
        value: json["value"],
      );

  Map<String, dynamic> toJson() => {
        "ttl": ttl,
        "type": type,
        "host": host,
        "value": value,
      };

  // Extracts FingerPrint from Record Value
  static extractFingerprint(String value) {
    return value.substring(FINGERPRINT_DIVIDER.length);
  }

  // Extracts Prefix from Record Host
  static extractPrefix(String host) {
    var idx = host.indexOf(PREFIX_DIVIDER);
    return host.substring(0, idx);
  }

  // Extracts Name from Record Host
  static String extractName(String host) {
    var idx = host.indexOf(PREFIX_DIVIDER);
    return host.substring(idx + PREFIX_DIVIDER.length);
  }

  @override
  String toString() {
    if (this.isAuth) {
      return "--Auth Record-- \n" +
          {
            "Fingerprint": this.fingerprint,
            "Prefix": this.prefix,
            "Name": this.name,
          }.toString();
    } else {
      return "--Default Record-- \n" + this.toJson().toString();
    }
  }
}
