import 'dart:async';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:sonr_app/service/api/handshake.dart';
import 'package:sonr_app/style/style.dart';
import 'package:sentry/sentry.dart';
import 'dart:convert';
import 'dart:typed_data';
import 'package:sonr_app/data/model/model_hs.dart';
import 'package:sonr_app/service/device/device.dart';
import 'package:sonr_plugin/sonr_plugin.dart';
import 'package:crypton/crypton.dart';
import 'package:bip39/bip39.dart' as bip39;
import 'package:crypto/crypto.dart' as crypto;

// Username List Constants
const K_RESTRICTED_NAMES = ['elon', 'vitalik', 'prad', 'rishi', 'brax', 'vt', 'isa'];
const K_BLOCKED_NAMES = ['root', 'admin', 'mail', 'auth', 'crypto', 'id', 'app', 'beta', 'alpha', 'code', 'ios', 'android', 'test', 'node', 'sonr'];

// Storage Constants
const K_PRIVKEY_TAG = 'sonr-private-key';
const K_PREFIX_TAG = 'sonr-prefix';
const K_MNEMONIC_TAG = 'sonr-mnemonic';

class UserService extends GetxService {
  // Accessors
  static bool get isRegistered => Get.isRegistered<UserService>();
  static UserService get to => Get.find<UserService>();

  // Auth Properties
  final _hasKey = false.obs;
  final _hasMnemonic = false.obs;
  final _hasPrefix = false.obs;
  final _records = RxList<HSRecord>();

  // User Reactive Properties
  final _hasUser = false.obs;
  final _isNewUser = false.obs;
  final _user = User().obs;

  // Contact Reactive Properties
  final _contact = Contact().obs;
  final _profile = Profile().obs;

  // Preferences
  final _isDarkMode = true.val('isDarkMode', getBox: () => GetStorage('Preferences'));
  final _hasFlatMode = true.val('flatModeEnabled', getBox: () => GetStorage('Preferences'));
  final _hasPointToShare = true.val('pointToShareEnabled', getBox: () => GetStorage('Preferences'));

  // Getter Methods for Contact Properties
  static RxBool get hasUser => to._hasUser;
  static RxBool get isNewUser => to._isNewUser;
  static Rx<User> get user => to._user;
  static Rx<Contact> get contact => to._contact;
  static Rx<Profile> get profile => to._profile;

  // Getters for Preferences
  static bool get isDarkMode => to._isDarkMode.val;
  static bool get flatModeEnabled => to._hasFlatMode.val;
  static bool get pointShareEnabled => to._hasPointToShare.val;

  // Shortcuts
  String get deviceID => DeviceService.device.id;
  String get mnemonic => _mnemonic;
  Uint8List get mnemonicUTF => Uint8List.fromList(utf8.encode(_mnemonic));
  String get prefix => this._prefix;
  String get privateKey => _ecKeypair.privateKey.toString();
  String get publicKey => _ecKeypair.publicKey.toString();
  Uint8List get signature => _ecKeypair.privateKey.createSHA512Signature(mnemonicUTF);
  String get signatureHex => String.fromCharCodes(signature);

  // Authentication
  late ECKeypair _ecKeypair;
  late String _mnemonic;
  late String _prefix;

  // Auth Checkers
  bool get hasAuth => _hasKey.value && _hasMnemonic.value && _hasPrefix.value;
  bool isNameAvailable(String n) => !_records.any((r) => r.equalsName(n));
  bool isNameUnblocked(String n) => !K_BLOCKED_NAMES.any((v) => v == n.toLowerCase());
  bool isNameUnrestricted(String n) => !K_RESTRICTED_NAMES.any((v) => v == n.toLowerCase());
  bool isPrefixAvailable(String n) => !_records.any((r) => r.equalsPrefix(to._newPrefix(n)));
  bool isValidName(String n) => isNameAvailable(n) && isNameUnblocked(n) && isNameUnrestricted(n) && isPrefixAvailable(n);

  // References
  final _nbClient = NamebaseClient();
  final _secure = FlutterSecureStorage();
  final _userBox = GetStorage('User');

  /// @ Open Storage on Init
  Future<UserService> init() async {
    // Set Auth Data
    _hasKey(await _secure.containsKey(key: K_PRIVKEY_TAG));
    _hasMnemonic(await _secure.containsKey(key: K_MNEMONIC_TAG));
    _hasPrefix(await _secure.containsKey(key: K_PREFIX_TAG));

    // i. Set Key
    if (_hasKey.value) {
      final privKeyData = await _secure.read(key: K_PRIVKEY_TAG);
      _ecKeypair = ECKeypair(ECPrivateKey.fromString(privKeyData!));
    }

    // ii. Set Mnemonic
    if (_hasMnemonic.value) {
      final data = await _secure.read(key: K_MNEMONIC_TAG);
      _mnemonic = data!;
    }

    // iii. Set Prefix
    if (_hasPrefix.value) {
      final prefixData = await _secure.read(key: K_PREFIX_TAG);
      _prefix = prefixData!;
    }

    // Get Records
    refreshRecords();

    // Init Storage
    await GetStorage.init('User');
    await GetStorage.init('Preferences');

    // Check User Status
    _hasUser(_userBox.hasData("user"));

    // Check if Exists
    if (_hasUser.value) {
      try {
        var profileJson = _userBox.read("user");
        var user = User.fromJson(profileJson);

        // Set Contact Values
        _user(user);
        _contact(user.contact);
        _isNewUser(false);

        // Configure Crypto
        setCrypto(User_Crypto(prefix: _prefix, signature: signatureHex));

        // Configure Sentry
        Sentry.configureScope((scope) => scope.user = SentryUser(
              id: DeviceService.device.id,
              username: _contact.value.username,
              extras: {
                "firstName": _contact.value.firstName,
                "lastName": _contact.value.lastName,
              },
            ));
      } catch (e) {
        // Delete User
        _userBox.remove('user');
        _hasUser(false);
        _isNewUser(true);

        // Clear Database
        CardService.deleteAllCards();
        CardService.clearAllActivity();
      }
    } else {
      _isNewUser(true);
    }

    // Handle Contact Updates
    _contact.listen(_handleContact);

    // Set Theme
    SonrTheme.setDarkMode(isDark: _isDarkMode.val);
    return this;
  }

  /// @ Adds User to Record if Provided Name is Allowed
  Future<bool> addUserRecord(String n) async {
    if (isValidName(n) && hasAuth) {
      return to._nbClient.addRecord(HSRecord.newAuth(_newPrefix(n), n, signatureHex));
    }
    return false;
  }

  /// @ Checks if User is the Same
  bool checkUser(String n) {
    var prefix = _newPrefix(n);
    var record = findMatchingRecord(n, prefix);
    if (record != null) {
      return verifyFingerprint(record) && record.equals(n, prefix);
    }
    return false;
  }

  /// @ Creates Crypto User Data, Returns Mnemonic Text
  Future<Tuple<String, String>> createUser(String name) async {
    // No Key Data
    if (!_hasKey.value) {
      _ecKeypair = ECKeypair.fromRandom();
      await _secure.write(key: K_PRIVKEY_TAG, value: _ecKeypair.privateKey.toString());
      _hasKey(true);
    }

    // No Prefix Data
    if (!_hasPrefix.value) {
      _prefix = _newPrefix(name);
      await _secure.write(key: K_PREFIX_TAG, value: _prefix);
      _hasPrefix(true);
    }

    // No Mnemonic Found
    if (!_hasMnemonic.value) {
      _mnemonic = bip39.generateMnemonic();
      await _secure.write(key: K_MNEMONIC_TAG, value: _mnemonic);
      _hasMnemonic(true);
    }

    // Set Crypto and Return Mnemonic
    setCrypto(User_Crypto(prefix: _prefix, signature: signatureHex));
    return Tuple(to._mnemonic, _prefix);
  }

  Future<User?> returningUser(String name) async {
    // No Key Data
    if (!_hasKey.value) {
      _ecKeypair = ECKeypair.fromRandom();
      await _secure.write(key: K_PRIVKEY_TAG, value: _ecKeypair.privateKey.toString());
      _hasKey(true);
    }

    // No Prefix Data
    if (!_hasPrefix.value) {
      _prefix = _newPrefix(name);
      await _secure.write(key: K_PREFIX_TAG, value: _prefix);
      _hasPrefix(true);
    }

    // Fetch User Data
    var user = await SonrService.getUser(id: _prefix);

    // Set Contact for User
    to._contact(user!.contact);
    to._contact.refresh();

    // Set Valuse
    to._isNewUser(true);

    // Save User/Contact to Disk
    var permUser = User(contact: to._contact.value);
    await to._userBox.write("user", permUser.writeToJson());
    to._hasUser(true);
    return to._user.value;
  }

  /// @ Refreshes Record Table from Namebase Client
  HSRecord? findMatchingRecord(String n, String p) {
    // Add Auth Records from All Records
    var data = _records.singleWhere(
      (r) => r.equals(n, p),
      orElse: () => HSRecord.blank(),
    );

    // Check Data
    if (data.isBlank) {
      return null;
    }
    return data;
  }

  /// @ Method to Create New User from Contact
  static Future<User> saveUser(Contact providedContact, {bool withSonrConnect = false}) async {
    // Set Contact for User
    to._contact(providedContact);
    to._contact.refresh();

    // Set Valuse
    to._isNewUser(true);

    // Connect Sonr Node
    if (withSonrConnect) {
      Get.find<SonrService>().connect();
    }

    // Save User/Contact to Disk
    var permUser = User(contact: to._contact.value);
    await to._userBox.write("user", permUser.writeToJson());
    to._hasUser(true);
    return to._user.value;
  }

  /// @ Refreshes Record Table from Namebase Client
  Future<void> refreshRecords() async {
    // Set Data From Response
    var data = await _nbClient.refresh();
    if (data.item1) {
      _records(data.item2);
      _records.refresh();
    }
  }

  /// @ Sets User Crypto Data
  void setCrypto(User_Crypto data) {
    _user.update((val) {
      if (val != null) {
        val.id = data.prefix;
        val.crypto = data;
      }
    });
  }

  /// @ Trigger iOS Local Network with Alert
  static void toggleDarkMode() async {
    // Update Value
    to._isDarkMode.val = !to._isDarkMode.val;
    SonrTheme.setDarkMode(isDark: to._isDarkMode.val);
  }

  /// @ Trigger iOS Local Network with Alert
  static void toggleFlatMode() async {
    to._hasFlatMode.val = !to._hasFlatMode.val;
  }

  /// @ Trigger iOS Local Network with Alert
  static void togglePointToShare() async {
    to._hasPointToShare.val = !to._hasPointToShare.val;
  }

  /// @ Verifys Given Signature with Mnemonic
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

  // Helper Method to Handle Contact Updates
  void _handleContact(Contact data) async {
    // Check if User Exists
    if (_userBox.hasData("user")) {
      // Retreive User from Disk
      var permJson = _userBox.read("user");
      User permUser = User.fromJson(permJson)..contact = data;

      // Refresh Reactive Vars
      _user(permUser);
      _user.refresh();

      // Save Updated User to Disk
      await to._userBox.write("user", permUser.writeToJson());
    }

    // Send Update to Node
    SonrService.setProfile(data);
  }
}
