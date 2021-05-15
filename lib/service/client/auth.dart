import 'dart:convert';
import 'package:bip39/bip39.dart' as bip39;
import 'package:cryptography/cryptography.dart';
// import 'package:jwk/jwk.dart';
import 'package:sonr_app/data/model/model_hs.dart';
import 'package:sonr_app/service/api/handshake.dart';
import 'package:sonr_app/service/device/device.dart';
import 'package:get/get.dart';

const K_RESTRICTED_USERNAMES = [];
const K_BLOCKED_USERNAMES = [];

class AuthService extends GetxService {
  final client = NamebaseClient();
  final records = RxList<HSRecord>();
  final prefix = "".obs;
  final fingerprint = "".obs;

  /// Initializes Handshake Service
  Future<AuthService> init() async {
    // Get Records
    var resp = await client.initialize();
    if (resp.success) {
      handleRecords(resp.records);
    }
    await signFingerprint();
    return this;
  }

  // @ Handle Records Listed from Response
  void handleRecords(List<HSRecord> data) {
    // Set Records
    records(data);

    // Add Auth Records from All Records
    this.records.forEach((r) async {
      if (r.isAuth) {
        if (await r.checkPrefix("name", DeviceService.device.id)) {}
      }
    });
  }

  String getMnemonic() => bip39.generateMnemonic();

  Future<void> signFingerprint() async {
    // Sign Mnemonic
    final message = utf8.encode(getMnemonic());

    // Generate a keypair.
    final algorithm = Ed25519();
    final keyPair = await algorithm.newKeyPair();
    // final jwk = Jwk.fromKeyPair(keyPair);
    // final json = jwk.toJson();

    // var jsonRef = Jwk.fromJson(json);
    // jsonRef.toKeyPair();

    // Sign
    final signature = await algorithm.sign(
      message,
      keyPair: keyPair,
    );
    print('Signature: ${signature.bytes}');
    print('Public key: ${signature.publicKey}');

    // Verify signature
    final isSignatureCorrect = await algorithm.verify(
      message,
      signature: signature,
    );
    print('Correct signature: $isSignatureCorrect');
  }
}
