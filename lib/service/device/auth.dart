import 'dart:convert';

import 'package:sonr_app/data/data.dart';
import 'package:sonr_app/data/model/model_hs.dart';
import 'package:sonr_app/service/device/device.dart';
import 'package:get/get.dart';
import 'package:bip39/bip39.dart' as bip39;
import 'package:sonr_app/style.dart';

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
  final result = Rx<NamebaseResult>(NamebaseResult.blank());

  // References
  final _nbClient = NamebaseClient();

  /// #### Initializes Auth Service ^
  Future<AuthService> init() async {
    // Get Records
    await refreshRecords();
    return this;
  }

  /// #### Creates Crypto User Data, Returns Mnemonic Text
  static Future<UsernameResult> createUsername(String name) async {
    if (isRegistered) {
      var prefix = await signPrefix(name);
      var mnemonic = bip39.generateMnemonic();
      var fingerprint = await signFingerprint(mnemonic);

      // Sign Mnemonic Value

      // Check Valid
      if (to.result.value.isValidName(name)) {
        // Sign Mnemonic Value

        // Add UserRecord Domain
        await to._nbClient.addRecord(HSRecord.newAuth(prefix, name, fingerprint));

        // Analytics
        FirebaseAnalytics().logEvent(
          name: '[AuthService]: Create-Username',
          parameters: {
            'createdAt': DateTime.now().toString(),
            'platform': DeviceService.platform.toString(),
            'new-username': name,
          },
        );

        // Return Mnemonic and Prefix
        return UsernameResult.isValidFetch(name, prefix, mnemonic);
      }
    }
    // Return Mnemonic and Prefix
    return UsernameResult.isInvalid();
  }

  /// #### Refreshes Record Table from Namebase Client
  Future<void> refreshRecords() async {
    // Set Data From Response
    var data = await _nbClient.refresh();
    if (data.success) {
      result(data);
      result.refresh();
    }
  }

  /// #### Checks if Username matches device id and prefix from records
  static Future<bool> validateUser(String n, String mnemonic) async {
    var request = Request.newVerifyText(original: mnemonic, signature: mnemonic);
    var response = await SonrService.verify(request);
    return response.isVerified;
  }

  // Helper Method to Generate Prefix
  static Future<String> signPrefix(String username) async {
    // Create New Prefix
    var request = Request.newSignText(username + DeviceService.device.id);
    var response = await SonrService.sign(request);

    print(response.toString());

    // Check Result
    if (response.isSigned) {
      var value = utf8.decode(response.signedValue);
      return value.substring(0, 16);
    }
    return "";
  }

  static Future<String> signFingerprint(String mnemonic) async {
    // Create New Prefix
    var request = Request.newSignText(mnemonic);
    var response = await SonrService.sign(request);

    print(response.toString());
    // Check Result
    if (response.isSigned) {
      var value = utf8.decode(response.signedValue);
      return value;
    }
    return "";
  }
}
