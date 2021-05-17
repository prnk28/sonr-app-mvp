import 'dart:convert';
import 'dart:typed_data';
import 'package:sonr_app/data/model/model_hs.dart';
import 'package:sonr_app/service/api/handshake.dart';
import 'package:sonr_app/service/device/device.dart';
import 'package:get/get.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:sonr_plugin/sonr_plugin.dart';
import 'package:crypton/crypton.dart';
import 'package:bip39/bip39.dart' as bip39;
import 'package:crypto/crypto.dart' as crypto;

// Username List Constants
const K_RESTRICTED_NAMES = ['elon', 'vitalik', 'prad', 'rishi', 'brax', 'nukala', 'vt', 'isa'];
const K_BLOCKED_NAMES = ['root', 'admin', 'mail', 'auth', 'crypto', 'id', 'app', 'beta', 'alpha', 'code', 'ios', 'android'];

// Storage Constants
const K_PRIVKEY_TAG = 'sonr-private-key';
const K_PREFIX_TAG = 'sonr-prefix';
const K_MNEMONIC_TAG = 'sonr-mnemonic';

class AuthService extends GetxService {
  // Accessors
  static bool get isRegistered => Get.isRegistered<AuthService>();
  static AuthService get to => Get.find<AuthService>();

  // Properties
  final auth = Rx<HSRecord>(HSRecord.blank());
  final hasKey = false.obs;
  final hasMnemonic = false.obs;
  final hasPrefix = false.obs;
  final records = RxList<HSRecord>();

  // Checkers
  bool get hasAuth => hasKey.value && hasMnemonic.value && hasPrefix.value;
  bool isNameAvailable(String n) => !records.any((r) => r.equalsName(n));
  bool isNameUnblocked(String n) => !K_BLOCKED_NAMES.any((v) => v == n.toLowerCase());
  bool isNameUnrestricted(String n) => !K_RESTRICTED_NAMES.any((v) => v == n.toLowerCase());
  bool isPrefixAvailable(String n) => !records.any((r) => r.equalsPrefix(to._newPrefix(n)));
  bool isValidName(String n) => isNameAvailable(n) && isNameUnblocked(n) && isNameUnrestricted(n) && isPrefixAvailable(n);

  // References
  final _nbClient = NamebaseClient();
  final _storage = FlutterSecureStorage();

  // Shortcuts
  String get deviceID => DeviceService.device.id;
  String get mnemonic => _mnemonic;
  Uint8List get mnemonicUTF => Uint8List.fromList(utf8.encode(_mnemonic));
  String get privateKey => _ecKeypair.privateKey.toString();
  String get publicKey => _ecKeypair.publicKey.toString();
  Uint8List get signature => _ecKeypair.privateKey.createSHA512Signature(mnemonicUTF);
  String get signatureHex => String.fromCharCodes(signature);

  // Crypto Values
  late ECKeypair _ecKeypair;
  late String _mnemonic;
  late String _prefix;

  /// ^ Initializes Auth Service ^
  Future<AuthService> init() async {
    // Check if Tags Exist in Storage
    hasKey(await _storage.containsKey(key: K_PRIVKEY_TAG));
    hasMnemonic(await _storage.containsKey(key: K_MNEMONIC_TAG));
    hasPrefix(await _storage.containsKey(key: K_PREFIX_TAG));

    // i. Set Key
    if (hasKey.value) {
      final privKeyData = await _storage.read(key: K_PRIVKEY_TAG);
      _ecKeypair = ECKeypair(ECPrivateKey.fromString(privKeyData!));
    }

    // ii. Set Mnemonic
    if (hasMnemonic.value) {
      final data = await _storage.read(key: K_MNEMONIC_TAG);
      _mnemonic = data!;
    }

    // iii. Set Prefix
    if (hasPrefix.value) {
      final prefixData = await _storage.read(key: K_PREFIX_TAG);
      _prefix = prefixData!;
    }

    // Get Records
    refresh();
    return this;
  }

  /// ^ Adds User to Record if Provided Name is Allowed
  Future<bool> addUser(String n) async {
    if (isValidName(n) && hasAuth) {
      return to._nbClient.addRecord(HSRecord.newAuth(_newPrefix(n), n, signatureHex));
    }
    return false;
  }

  /// ^ Creates Crypto User Data, Returns Mnemonic Text
  Future<String> createUser(String name) async {
    // No Key Data
    if (!hasKey.value) {
      _ecKeypair = ECKeypair.fromRandom();
      await _storage.write(key: K_PRIVKEY_TAG, value: _ecKeypair.privateKey.toString());
      hasKey(true);
    }

    // No Prefix Data
    if (!hasPrefix.value) {
      _prefix = _newPrefix(name);
      await _storage.write(key: K_PREFIX_TAG, value: _prefix);
      hasPrefix(true);
    }

    // No Mnemonic Found
    if (!hasMnemonic.value) {
      _mnemonic = bip39.generateMnemonic();
      await _storage.write(key: K_MNEMONIC_TAG, value: _mnemonic);
      hasMnemonic(true);
    }
    return to._mnemonic;
  }

  /// ^ Returns ConnectionRequest_ECKeyPair
  static ConnectionRequest_ECKeyPair requestKeyPair({bool asBytes = false}) {
    return asBytes
        ? ConnectionRequest_ECKeyPair(privateKeyBytes: utf8.encode(to.privateKey), publicKeyBytes: utf8.encode(to.publicKey))
        : ConnectionRequest_ECKeyPair(privateKeyString: to.privateKey, publicKeyString: to.publicKey);
  }

  bool checkUser(String n) {
    var prefix = to._newPrefix(n);
    var record = findMatchingRecord(n, prefix);
    if (record != null) {
      return verifyFingerprint(record) && record.equals(n, prefix);
    }
    return false;
  }

  /// ^ Refreshes Record Table from Namebase Client
  HSRecord? findMatchingRecord(String n, String p) {
    // Add Auth Records from All Records
    var data = records.singleWhere(
      (r) => r.equals(n, p),
      orElse: () => HSRecord.blank(),
    );

    // Check Data
    if (data.isBlank) {
      return null;
    }
    return data;
  }

  /// ^ Refreshes Record Table from Namebase Client
  Future<void> refresh() async {
    // Set Data From Response
    var data = await _nbClient.refresh();
    if (data.item1) {
      records(data.item2);
      records.refresh();
    }
  }

  /// ^ Verifys Given Signature with Mnemonic
  bool verifyFingerprint(HSRecord record) {
    if (record.isAuth) {
      return to._ecKeypair.publicKey.verifySHA512Signature(
        to.mnemonicUTF,
        record.fingerprint,
      );
    }
    return false;
  }

  // * --------------------------------------------------------------------------
  // * ---- Helper Methods ------------------------------------------------------
  // * --------------------------------------------------------------------------
  // Helper Method to Generate Prefix
  String _newPrefix(String username) {
    // Create New Prefix
    var hmacSha256 = crypto.Hmac(crypto.sha256, utf8.encode(username + deviceID));
    var digest = hmacSha256.convert(utf8.encode(username + deviceID));
    return "$digest".substring(0, 16);
  }
}
