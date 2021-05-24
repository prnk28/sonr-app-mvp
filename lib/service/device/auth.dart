import 'dart:convert';
import 'dart:typed_data';
import 'package:sonr_app/data/data.dart';
import 'package:sonr_app/data/model/model_hs.dart';
import 'package:sonr_app/env.dart';
import 'package:sonr_app/service/client/sonr.dart';
import 'package:sonr_app/service/device/device.dart';
import 'package:get/get.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:crypton/crypton.dart';
import 'package:bip39/bip39.dart' as bip39;
import 'package:crypto/crypto.dart' as crypto;
import 'package:sonr_app/service/user/user.dart';
import 'package:sonr_plugin/sonr_plugin.dart';

// Storage Constants
const K_NAME_TAG = 'sonr-name';
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
  final hasName = false.obs;
  final hasMnemonic = false.obs;
  final hasPrefix = false.obs;
  final result = Rx<NamebaseResult>(NamebaseResult.blank());

  // Checkers
  bool get hasAuth => hasKey.value && hasMnemonic.value && hasPrefix.value;

  // Crypto Values
  late ECKeypair _ecKeypair;
  late String _mnemonic;
  late String _name;
  late String _prefix;

  // References
  final _nbClient = NamebaseClient();
  final _storage = FlutterSecureStorage();

  // Shortcuts
  String get deviceID => DeviceService.device.id;
  Uint8List get mnemonicUTF => Uint8List.fromList(utf8.encode(_mnemonic));
  String get privateKey => _ecKeypair.privateKey.toString();
  String get publicKey => _ecKeypair.publicKey.toString();
  Uint8List get signature => _ecKeypair.privateKey.createSHA512Signature(mnemonicUTF);
  String get signatureHex => String.fromCharCodes(signature);

  // Retreives User_Crypto Data
  static User_Crypto get userCrypto => User_Crypto(prefix: to._prefix, signature: to.signatureHex, privateKey: to._ecKeypair.privateKey.toString());
  static String get mnemonic => to._mnemonic;
  static String get prefix => to._prefix;

  /// ^ Initializes Auth Service ^
  Future<AuthService> init() async {
    // Check if Tags Exist in Storage
    hasKey(await _storage.containsKey(key: K_PRIVKEY_TAG));
    hasMnemonic(await _storage.containsKey(key: K_MNEMONIC_TAG));
    hasName(await _storage.containsKey(key: K_NAME_TAG));
    hasPrefix(await _storage.containsKey(key: K_PREFIX_TAG));

    // i. Set Key
    if (hasKey.value) {
      final privKeyData = await _storage.read(key: K_PRIVKEY_TAG);
      _ecKeypair = ECKeypair(ECPrivateKey.fromString(privKeyData!));
    } else {
      _ecKeypair = ECKeypair.fromRandom();
      await _storage.write(key: K_PRIVKEY_TAG, value: _ecKeypair.privateKey.toString());
      hasKey(true);
    }

    // ii. Set Mnemonic
    if (hasMnemonic.value) {
      final data = await _storage.read(key: K_MNEMONIC_TAG);
      _mnemonic = data!;
    }

    // iii. Set Name
    if (hasName.value) {
      final data = await _storage.read(key: K_NAME_TAG);
      _name = data!;
    }

    // iV. Set Prefix
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
    if (result.value.isValidName(n) && hasAuth) {
      return to._nbClient.addRecord(HSRecord.newAuth(buildPrefix(n), n, signatureHex));
    }
    return false;
  }

  /// ^ Creates Crypto User Data, Returns Mnemonic Text
  static Future<UsernameResult> createUsername(
    String name,
  ) async {
    // No Prefix Data
    if (!to.hasPrefix.value) {
      to._prefix = buildPrefix(name);
      await to._storage.write(key: K_PREFIX_TAG, value: to._prefix);
      to.hasPrefix(true);
    }

    // No Mnemonic Found
    if (!to.hasMnemonic.value) {
      to._mnemonic = bip39.generateMnemonic();
      await to._storage.write(key: K_MNEMONIC_TAG, value: to._mnemonic);
      to.hasMnemonic(true);
    }

    // Check Valid
    if (to.result.value.isValidName(name)) {
      to._name = name;
      await to._storage.write(key: K_NAME_TAG, value: to._name);
      to.hasName(true);

      // Add UserRecord Domain
      await to._nbClient.addRecord(HSRecord.newAuth(to._prefix, name, to.signatureHex));

      // Return Mnemonic and Prefix
      return UsernameResult.isValidFetch(name);
    }

    // Return Mnemonic and Prefix
    return UsernameResult.isInvalid();
  }

  /// ^ Returns User Data from Remote Backup
  static Future<User?> getUser() async {
    if (to.hasPrefix.value) {
      var data = await SonrCore.userStorjRequest(
        StorjRequest(storjApiKey: Env.storj_key, storjRootPassword: Env.storj_root_password, userID: to._prefix),
      );
      if (data != null) {
        return data.user;
      }
    }
    return null;
  }

  /// ^ Place User into Remote Backup Storage
  static Future<bool> putUser() async {
    // Reference
    var resp =
        await SonrCore.userStorjRequest(StorjRequest(storjApiKey: Env.storj_key, storjRootPassword: Env.storj_root_password, user: UserService.user));
    if (resp != null) {
      return resp.success;
    }
    return false;
  }

  /// ^ Refreshes Record Table from Namebase Client
  Future<void> refresh() async {
    // Set Data From Response
    var data = await _nbClient.refresh();
    if (data.success) {
      result(data);
      result.refresh();
    }
  }

  /// ^ Saves Validated User Data
  Future<void> saveValidatedUser(String name) async {
    // Set Values
    to._name = name;
    to._prefix = buildPrefix(name);

    // Save To Storage
    await to._storage.write(key: K_PREFIX_TAG, value: to._prefix);
    await to._storage.write(key: K_NAME_TAG, value: to._name);

    // Update Validators
    to.hasPrefix(true);
    to.hasName(true);
  }

  /// ^ Checks if Username matches device id and prefix from records
  static Future<bool> validateUser(String n) async {
    if (to.hasMnemonic.value) {
      var data = to.result.value.hasName(n, buildPrefix(n));
      if (data.exists) {
        await to.saveValidatedUser(n);
        return to._ecKeypair.publicKey.verifySHA512Signature(
          to.mnemonicUTF,
          data.record.fingerprint,
        );
      }
    }
    return false;
  }

  // * --------------------------------------------------------------------------
  // * ---- Helper Methods ------------------------------------------------------
  // * --------------------------------------------------------------------------
  // Helper Method to Generate Prefix
  static String buildPrefix(String username) {
    // Create New Prefix
    var hmacSha256 = crypto.Hmac(crypto.sha256, utf8.encode(username + to.deviceID));
    var digest = hmacSha256.convert(utf8.encode(username + to.deviceID));
    return "$digest".substring(0, 16);
  }
}
