import 'dart:convert';

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

  @override
  String toString() {
    return this.toJson().toString();
  }
}
