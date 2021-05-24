import 'dart:async';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:sonr_app/style/style.dart';
import 'package:sentry/sentry.dart';
import 'package:sonr_app/service/device/device.dart';
import 'package:sonr_plugin/sonr_plugin.dart';

import '../device/auth.dart';

class UserService extends GetxService {
  // Accessors
  static bool get isRegistered => Get.isRegistered<UserService>();
  static UserService get to => Get.find<UserService>();

  // User Reactive Properties
  final _hasUser = false.obs;
  final _isNewUser = false.obs;

  // User Data Properties
  final _contact = Contact().obs;
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

  // Getters for Preferences
  static bool get isDarkMode => to._isDarkMode.val;
  static bool get flatModeEnabled => to._hasFlatMode.val;
  static bool get pointShareEnabled => to._hasPointToShare.val;

  // References
  final _userBox = GetStorage('User');
  static GetStorage _getUserBox() => GetStorage('User');
  static GetStorage _getPrefsBox() => GetStorage('Preferences');

  /// @ Open Storage on Init
  Future<UserService> init() async {
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

  /// @ Method to Create New User from Contact
  static Future<User> returnUser() async {
    if (DeviceService.isMobile) {
      // Fetch User Data
      var data = await AuthService.getUser();

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
    return user;
  }

  /// @ Method to Create New User from Contact
  static Future<User> saveUser(Contact data, {bool withSonrConnect = false}) async {
    // Write Data
    await to.writeData(contact: data);
    await SonrService.putUser(user: user);

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
      if (hasContact && hasDevices && hasSettings) {
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
        id: AuthService.prefix,
        contact: to._contact.value,
        crypto: AuthService.userCrypto,
        devices: to._devices.val,
        settings: to._settings.val,
      );
}
