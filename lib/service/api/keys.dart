import 'dart:convert';
import 'package:jwk/jwk.dart';
import 'package:cryptography/cryptography.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

const K_KEY_NAME = 'sonr-key-pair';

class UserKeys {
  final _algorithm = Ecdsa.p256(Sha256());
  final _storage = FlutterSecureStorage();
  late KeyPair _keyPair;

  KeyPair get keyPair => _keyPair;
  Future<PublicKey> publicKeyBytes() async {
    var keyData = await _keyPair.extract();
    return await keyData.extractPublicKey();
  }

  Future<bool> get hasKeyPair async => await _storage.containsKey(key: 'sonr-key-pair');

  Future<UserKeys> init() async {
    // Read File Data
    if (!await hasKeyPair) {
      // Create New Key-Pair
      final keyPair = await _algorithm.newKeyPair();

      this._keyPair = keyPair;

      // Save Keypair to Disk
      await _writeKeys(this._keyPair);
    }
    this._keyPair = await _readKeys();
    return this;
  }

  Future<KeyPair> _readKeys() async {
    final jsonString = await _storage.read(key: K_KEY_NAME);
    final json = jsonDecode(jsonString!);
    final jwk = Jwk.fromJson(json);
    return jwk.toKeyPair();
  }

  Future<void> _writeKeys(KeyPair keys) async {
    // Extract Data
    final jwk = Jwk.fromKeyPair(_keyPair);
    final json = jwk.toJson();
    final jsonString = jsonEncode(json);

    // Write File
    _storage.write(key: K_KEY_NAME, value: jsonString);
  }
}
