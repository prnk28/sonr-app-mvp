import 'dart:async';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:sonr_app/style/style.dart';
import 'package:sentry/sentry.dart';

class UserService extends GetxService {
  // Accessors
  static bool get isRegistered => Get.isRegistered<UserService>();
  static UserService get to => Get.find<UserService>();

  /// ** User Reactive Properties **
  final _hasUser = false.obs;
  final _isNewUser = false.obs;
  final _user = User().obs;

  /// ** Contact Reactive Properties **
  final _contact = Contact().obs;
  final _profile = Profile().obs;

  // Preferences
  final _isDarkMode = true.val('isDarkMode', getBox: () => GetStorage('Preferences'));
  final _hasFlatMode = true.val('flatModeEnabled', getBox: () => GetStorage('Preferences'));
  final _hasPointToShare = true.val('pointToShareEnabled', getBox: () => GetStorage('Preferences'));

  /// **  Getter Methods for Contact Properties **
  static RxBool get hasUser => to._hasUser;
  static RxBool get isNewUser => to._isNewUser;
  static Rx<User> get user => to._user;
  static Rx<Contact> get contact => to._contact;
  static Rx<Profile> get profile => to._profile;

  // Getters for Preferences
  static bool get isDarkMode => to._isDarkMode.val;
  static bool get flatModeEnabled => to._hasFlatMode.val;
  static bool get pointShareEnabled => to._hasPointToShare.val;

  /// ** References **
  final _userBox = GetStorage('User');

  /// @ Open SharedPreferences on Init
  Future<UserService> init() async {
    // @ Init Shared Preferences
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

        // Configure Sentry
        Sentry.configureScope((scope) => scope.user = SentryUser(
              id: '1234',
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

  /// @ Update Social in List
  static bool swapSocials(Contact_Social first, Contact_Social second) {
    // int idxOne = to._socials.keys.toList().indexOf(first.username);
    //int idxTwo = to._socials.keys.toList().indexOf(second.username);
    // controller._socials.swap(idxOne, idxTwo);
    return true;
  }

  /// @ Method to Create New User from Contact
  static Future<User> newUser(Contact providedContact, {bool withSonrConnect = false}) async {
    // Set Valuse
    to._isNewUser(true);

    // Connect Sonr Node
    if (withSonrConnect) {
      Get.find<SonrService>().connectNewUser(UserService.contact.value);
    }

    // Set Contact for User
    to._contact(providedContact);
    to._contact.refresh();

    // Save User/Contact to Disk
    var permUser = User(contact: to._contact.value);
    await to._userBox.write("user", permUser.writeToJson());
    to._hasUser(true);
    return to._user.value;
  }

  /// @ Trigger iOS Local Network with Alert
  static toggleDarkMode() async {
    // Update Value
    to._isDarkMode.val = !to._isDarkMode.val;
    SonrTheme.setDarkMode(isDark: to._isDarkMode.val);
    return true;
  }

  /// @ Trigger iOS Local Network with Alert
  static toggleFlatMode() async {
    to._hasFlatMode.val = !to._hasFlatMode.val;
  }

  /// @ Trigger iOS Local Network with Alert
  static togglePointToShare() async {
    to._hasPointToShare.val = !to._hasPointToShare.val;
  }

  // # Helper Method to Handle Contact Updates
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
