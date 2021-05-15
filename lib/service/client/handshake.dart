import 'dart:convert';
import 'package:sonr_app/data/model/model_hs.dart';

import '../../env.dart';
import 'package:get/get.dart';

class HandshakeService extends GetxService {
  final client = _NamebaseClient();
  final records = RxList<HSRecord>();

  /// Initializes Handshake Service
  Future<HandshakeService> init() async {
    var resp = await client.getNameserverSettings();
    if (resp.success) {
      records(resp.records);
    }
    return this;
  }
}

/// ### Namebase API Client
class _NamebaseClient extends GetConnect {
  // Base Client Properties
  final _BASE_URL = "https://www.namebase.io";
  final _AUTHORIZATION = base64Encode(utf8.encode("${Env.hs_key}:${Env.hs_secret}"));

  // Endpoint for Nameserver DNS Settings
  final _NAME_DNS_POINT = '/api/v0/dns/domains/snr/nameserver';

  // Authorization Header Map
  Map<String, String> get _AUTH_HEADERS =>
      {'Authorization': 'Basic $_AUTHORIZATION', 'Accept': 'application/json', 'Content-Type': 'application/json'};

  // Returns Auth Headers
  Future<HSResponse> getNameserverSettings() async {
    var resp = await get(_BASE_URL + _NAME_DNS_POINT, headers: _AUTH_HEADERS);
    return HSResponse.fromJson(resp.body);
  }
}
