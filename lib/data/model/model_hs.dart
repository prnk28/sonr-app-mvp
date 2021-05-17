import 'dart:convert';
import 'dart:typed_data';

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
        "records": List<dynamic>.from(records.map((x) => x.toMap())),
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
  bool get isBlank => this.ttl == -1 && this.type == "-" && this.host == "-" && this.value == "-";
  Uint8List get fingerprint => isAuth ? extractFingerprint(value) : Uint8List(0);
  String get name => isAuth ? extractName(host) : "";
  String get prefix => isAuth ? extractPrefix(host) : "";

  // Method Checks if Prefix Values are the same
  bool equals(String n, String p) => this.equalsName(n) && this.equalsPrefix(p);
  bool equalsName(String n) => this.name.toLowerCase() == n.toLowerCase();
  bool equalsPrefix(String p) => this.prefix == p;
  bool notEquals(String n, String p) => this.notEqualsName(n) && this.notEqualsPrefix(p);
  bool notEqualsName(String n) => this.name.toLowerCase() != n.toLowerCase();
  bool notEqualsPrefix(String p) => this.prefix != p;

  /// Returns Blank Record
  factory HSRecord.blank() {
    return HSRecord(ttl: -1, type: "-", host: "-", value: "-");
  }

  /// Returns Auth Based Record
  factory HSRecord.newAuth(String prefix, String name, String fingerprint) {
    return HSRecord(ttl: 5, type: "TXT", host: "$prefix._auth.$name", value: FINGERPRINT_DIVIDER + fingerprint);
  }

  /// Creates Record From JSON
  factory HSRecord.fromJson(dynamic json) => HSRecord(
        ttl: json["ttl"],
        type: json["type"],
        host: json["host"],
        value: json["value"],
      );

  // Extracts FingerPrint from Record Value
  static Uint8List extractFingerprint(String value) {
    var data = value.substring(FINGERPRINT_DIVIDER.length);
    return Uint8List.fromList(data.codeUnits);
  }

  // Extracts Prefix from Record Host
  static String extractPrefix(String host) {
    var idx = host.indexOf(PREFIX_DIVIDER);
    return host.substring(0, idx);
  }

  // Extracts Name from Record Host
  static String extractName(String host) {
    var idx = host.indexOf(PREFIX_DIVIDER);
    return host.substring(idx + PREFIX_DIVIDER.length);
  }

  Map<String, dynamic> toMap() => {
        "ttl": ttl,
        "type": type,
        "host": host,
        "value": value,
      };

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
      return "--Default Record-- \n" + this.toMap().toString();
    }
  }
}
