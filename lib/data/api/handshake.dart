import 'dart:convert';
import 'package:sonr_app/data/model/model_hs.dart';
import 'package:sonr_plugin/sonr_plugin.dart';
import '../../env.dart';
import 'package:get/get.dart';

/// ### Namebase API Client
class NamebaseClient extends GetConnect {
  // Base Client Properties
  final _BASE_URL = "https://www.namebase.io";
  final _AUTHORIZATION = base64Encode(utf8.encode("${Env.hs_key}:${Env.hs_secret}"));

  // Endpoint for Nameserver DNS Settings
  final _NAME_DNS_POINT = '/api/v0/dns/domains/snr/nameserver';

  // Authorization Header Map
  Map<String, String> get _AUTH_HEADERS =>
      {'Authorization': 'Basic $_AUTHORIZATION', 'Accept': 'application/json', 'Content-Type': 'application/json'};

  /// Returns All Records List
  Future<Tuple<bool, List<HSRecord>>> refresh() async {
    var resp = await get(_BASE_URL + _NAME_DNS_POINT, headers: _AUTH_HEADERS);
    var data = HSResponse.fromJson(resp.body);
    return Tuple(data.success, data.records);
  }

  Future<bool> addRecord(HSRecord newRecord) async {
    var map = {
      'records': [newRecord.toMap()],
      'deleteRecords': []
    };

    var body = jsonEncode(map);
    var resp = await put(_BASE_URL + _NAME_DNS_POINT, body, headers: _AUTH_HEADERS);
    return resp.body["success"];
  }

  Future<bool> removeRecord(List<HSRecord> allRecords, HSRecord removedRecord) async {
    return true;
  }
}
