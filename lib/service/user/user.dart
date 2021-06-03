import 'dart:async';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:sonr_app/service/device/auth.dart';
import 'package:sonr_app/style/style.dart';
import 'package:sentry/sentry.dart';

class UserService extends GetxService {
  // Accessors
  static bool get isRegistered => Get.isRegistered<UserService>();
  static UserService get to => Get.find<UserService>();

  /// ** User Status Properties **
  final _hasUser = false.obs;
  final _isNewUser = false.obs;

  /// ** User Reactive Properties **
  final _contact = Contact().obs;
  final _devices = RxMap<String, Device>();
  final _settings = RxMap<String, Settings>();

  // Preferences
  final _isDarkMode = true.val('isDarkMode', getBox: () => GetStorage('Preferences'));
  final _hasFlatMode = true.val('flatModeEnabled', getBox: () => GetStorage('Preferences'));
  final _hasPointToShare = true.val('pointToShareEnabled', getBox: () => GetStorage('Preferences'));

  /// **  Getter Methods for Contact Properties **
  static RxBool get hasUser => to._hasUser;
  static RxBool get isNewUser => to._isNewUser;
  static Rx<Contact> get contact => to._contact;
  static RxMap<String, Device> get devices => to._devices;
  static RxMap<String, Settings> get settings => to._settings;

  // Getters for Preferences
  static bool get isDarkMode => to._isDarkMode.val;
  static bool get flatModeEnabled => to._hasFlatMode.val;
  static bool get pointShareEnabled => to._hasPointToShare.val;
  static String get sName => to._hasUser.value ? to._contact.value.sName : "";

  /// ** References **
  final _userBox = GetStorage('User');

  /// @ Open SharedPreferences on Init
  Future<UserService> init() async {
    // @ Init Shared Preferences
    await GetStorage.init('User');
    await GetStorage.init('Preferences');

    // Check User Status
    _hasUser(_userBox.hasData("user"));

    if (DeviceService.isDesktop) {
      // Delete User
      _userBox.remove('user');
      _hasUser(false);
      _isNewUser(true);
    }

    // Check if Exists
    if (_hasUser.value) {
      try {
        var profileJson = _userBox.read("user");
        var user = User.fromJson(profileJson);

        // Set Contact Values
        _contact(user.contact);
        _devices(user.devices);
        _settings(user.settings);
        _isNewUser(false);

        // Configure Sentry
        Sentry.configureScope((scope) => scope.user = SentryUser(
              id: DeviceService.device.id,
              username: _contact.value.sName,
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

  /// @ Method to Create New User from Contact
  static Future<User> newUser(Contact newContact) async {
    // Set Valuse
    to._isNewUser(true);

    // Set Contact for User
    to._contact(newContact);
    to._contact.refresh();

    // Save User/Contact to Disk
    await to._userBox.write("user", user.writeToJson());

    // Place Auth Record
    if (DeviceService.isMobile) {
      await AuthService.putUser();
    }

    to._hasUser(true);
    return user;
  }

  /// @ Method to Create New User from Contact
  static Future<User> returnUser() async {
    // Fetch User Data
    var data = await AuthService.getUser();

    // Check Data
    if (data != null) {
      // Set Values
      to._contact(data.contact);
      to._devices(data.devices);
      to._settings(data.settings);
      to._isNewUser(false);

      // Rewrite Data
      await to._userBox.write("user", user.writeToJson());
      to._hasUser(true);
    }
    return user;
  }

  /// @ Method Collects user Feedback and Sends Email
  static void sendFeedback(String message, Uint8List? screenshot) async {
    var screenshotPath = "";

    // Save Image
    if (screenshot != null) {
      screenshotPath = await TransferService.writeImageToStorage(screenshot);
    }

    // Create Email
    final Email email = Email(
      body: message,
      subject: 'Sonr In-App Feedback',
      recipients: ['contact@sonr.io'],
      bcc: ['rishir@sonr.io', 'pradn@sonr.io'],
      attachmentPaths: screenshotPath != "" ? [screenshotPath] : [],
      isHTML: false,
    );
    await FlutterEmailSender.send(email);
  }

  /// @ Trigger iOS Local Network with Alert
  static toggleDarkMode() => SonrTheme.setDarkMode(isDark: to._isDarkMode.val = !to._isDarkMode.val);

  /// @ Trigger iOS Local Network with Alert
  static toggleFlatMode() => to._hasFlatMode.val = !to._hasFlatMode.val;

  /// @ Trigger iOS Local Network with Alert
  static togglePointToShare() => to._hasPointToShare.val = !to._hasPointToShare.val;

  // # Helper Method to Handle Contact Updates
  void _handleContact(Contact data) async {
    // Save Updated User to Disk
    await to._userBox.write("user", user.writeToJson());

    // Send Update to Node
    if (SonrService.status.value.isConnected) {
      SonrService.setProfile(data);
    }
  }

  /// @ Returns User Based on Service Values
  static User get user => User(
      id: DeviceService.isMobile ? AuthService.prefix : "",
      contact: to._contact.value,
      device: DeviceService.device,
      devices: to._devices,
      location: DeviceService.location,
      settings: to._settings);
}
