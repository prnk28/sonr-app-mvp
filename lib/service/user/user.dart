import 'dart:async';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:sonr_app/style/style.dart';
import 'package:sentry/sentry.dart';
import 'package:sonr_app/service/device/device.dart';
import 'package:sonr_plugin/sonr_plugin.dart';

class UserService extends GetxService {
  // Accessors
  static bool get isRegistered => Get.isRegistered<UserService>();
  static UserService get to => Get.find<UserService>();

  // Auth Properties
  final _nbResult = Rx<NamebaseResult>(NamebaseResult.blank());

  // User Reactive Properties
  final _hasUser = false.obs;
  final _isNewUser = false.obs;

  // User Data Properties
  final _id = "".obs;
  final _contact = Contact().obs;
  final _crypto = User_Crypto().obs;
  final _devices = <String, Device>{}.val('devices', getBox: _getUserBox);
  final _settings = <String, User_Settings>{}.val('settings', getBox: _getUserBox);

  // Preferences
  final _isDarkMode = true.val('isDarkMode', getBox: _getPrefsBox);
  final _hasFlatMode = true.val('flatModeEnabled', getBox: _getPrefsBox);
  final _hasPointToShare = true.val('pointToShareEnabled', getBox: _getPrefsBox);

  // Getter Methods for Contact Properties
  static RxBool get hasUser => to._hasUser;
  static RxBool get isNewUser => to._isNewUser;
  static Rx<Contact> get contact => to._contact;
  static Rx<NamebaseResult> get nbResult => to._nbResult;

  // Getters for Preferences
  static bool get isDarkMode => to._isDarkMode.val;
  static bool get flatModeEnabled => to._hasFlatMode.val;
  static bool get pointShareEnabled => to._hasPointToShare.val;

  // References
  final _nbClient = NamebaseClient();
  final _userBox = GetStorage('User');
  static GetStorage _getUserBox() => GetStorage('User');
  static GetStorage _getPrefsBox() => GetStorage('Preferences');

  /// @ Open Storage on Init
  Future<UserService> init() async {
    // Get Records
    var data = await _nbClient.refresh();
    if (data.success) {
      _nbResult(data);
      _nbResult.refresh();
    }

    // Init Storage
    await GetStorage.init('User');
    await GetStorage.init('Preferences');

    // Check User Status
    _hasUser(await readData());

    // Check if Exists
    if (_hasUser.value) {
      // Set Contact Values
      _isNewUser(false);

      // Configure Sentry
      Sentry.configureScope((scope) => scope.user = SentryUser(
            id: DeviceService.device.id,
            username: _contact.value.username,
            extras: {
              "firstName": _contact.value.firstName,
              "lastName": _contact.value.lastName,
            },
          ));
    } else {
      _isNewUser(true);
    }

    // Set Theme
    SonrTheme.setDarkMode(isDark: _isDarkMode.val);
    return this;
  }

  /// @ Checks if User is the Same
  static bool checkUser(String n) {
    if (DeviceService.isMobile) {
      var prefix = MobileService.newPrefix(n);
      var result = to._nbResult.value.hasName(n, prefix);

      if (result.exists) {
        return MobileService.verifyFingerprint(result.record);
      }
    }
    return false;
  }

  /// @ Creates Crypto User Data, Returns Mnemonic Text
  static Future<UsernameResult> newUsername(String name) async {
    if (DeviceService.isMobile) {
      // Set Crypto
      var data = await MobileService.newCrypto(name);
      to._id(data.prefix);
      to._crypto(data);

      // Add UserRecord Domain
      if (to._nbResult.value.isValidName(name) && MobileService.to.hasAuth) {
        await to._nbClient.addRecord(MobileService.getAuthRecord(name));
      }

      // Return Mnemonic and Prefix
      return UsernameResult.isValidFetch(name);
    }
    return UsernameResult.isInvalid();
  }

  // @ Set For Returning User
  static Future<User?> returningUser(String name) async {
    if (DeviceService.isMobile) {
      var prefix = await MobileService.updatePrefix(name);

      // Fetch User Data
      var data = await SonrService.getUser(id: prefix);

      // Check Data
      if (data != null) {
        // Set Valuse
        to._isNewUser(false);

        // Rewrite Data
        await to.writeData(
          contact: data.contact,
          devices: data.devices,
          settings: data.settings,
        );
      }
    }
    return null;
  }

  /// @ Method to Create New User from Contact
  static Future<User> saveUser(Contact data, {bool withSonrConnect = false}) async {
    // Write Data
    await to.writeData(contact: data);

    // Set Valuse
    to._isNewUser(true);

    // Connect Sonr Node
    if (withSonrConnect) {
      Get.find<SonrService>().connect();
    }
    // Write Data
    return user;
  }

  /// @ Reads User Data from Persistent Storage/ Returns if Exists
  Future<bool> readData() async {
    // Validate Mobile
    if (DeviceService.isMobile) {
      // Check Storage
      bool hasContact = _userBox.hasData('contact');
      bool hasDevices = _userBox.hasData('devices');
      bool hasSettings = _userBox.hasData('settings');

      // Data Exists
      if (hasContact && hasDevices && hasSettings && MobileService.to.hasAuth) {
        _id(MobileService.userCrypto.prefix);
        _crypto(MobileService.userCrypto);
        _contact(Contact.fromJson(_userBox.read("contact")));
        return true;
      }
    }

    // No Data
    return false;
  }

  /// @ Writes User Data to Persistent Storage/ Puts in Backup
  Future<void> writeData({
    Contact? contact,
    Tuple<String, Device>? device,
    Tuple<String, User_Settings>? setting,
    Map<String, Device>? devices,
    Map<String, User_Settings>? settings,
  }) async {
    // # Write Contact
    if (contact != null) {
      _contact(contact);
      _contact.refresh();
    }
    await _userBox.write('contact', _contact.value.writeToJson());

    // # Write ALL Devices
    if (devices != null) {
      _devices.val.addAll(devices);
    }
    // Single Entry
    else {
      // Write Device Entry
      if (device != null) {
        _devices.val[device.item1] = device.item2;
      }
    }

    // # Write ALL Settings
    if (settings != null) {
      _settings.val.addAll(settings);
    }
    // Single Entry
    else {
      // Write Setting Entry
      if (setting != null) {
        _settings.val[setting.item1] = setting.item2;
      }
    }

    // Save User to Backup Storage
    await SonrService.putUser(user: user);
  }

  /// @ Refreshes Record Table from Namebase Client
  static Future<void> refreshRecords() async {
    // Set Data From Response
    var data = await to._nbClient.refresh();
    if (data.success) {
      to._nbResult(data);
      to._nbResult.refresh();
    }
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

  /// @ Returns User Based on Service Values
  static User get user => User(
        id: to._id.value,
        contact: to._contact.value,
        crypto: to._crypto.value,
        devices: to._devices.val,
        settings: to._settings.val,
      );
}
