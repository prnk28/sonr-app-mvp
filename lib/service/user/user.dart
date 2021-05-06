import 'dart:async';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:sonr_app/style/style.dart';
import 'package:sentry/sentry.dart';

class UserService extends GetxService {
  // Accessors
  static bool get isRegistered => Get.isRegistered<UserService>();
  static UserService get to => Get.find<UserService>();

  // ** User Reactive Properties **
  final _hasUser = false.obs;
  final _isNewUser = false.obs;
  final _user = User().obs;

  // ** Contact Reactive Properties **
  final _contact = Contact().obs;
  final _profile = Profile().obs;

  // Preferences
  final _isDarkMode = false.val('isDarkMode', getBox: () => GetStorage('Preferences'));
  final _hasFlatMode = false.val('flatModeEnabled', getBox: () => GetStorage('Preferences'));
  final _hasPointToShare = false.val('pointToShareEnabled', getBox: () => GetStorage('Preferences'));

  // **  Getter Methods for Contact Properties **
  static RxBool get hasUser => to._hasUser;
  static RxBool get isNewUser => to._isNewUser;
  static Rx<User> get user => to._user;
  static Rx<Contact> get contact => to._contact;
  static Rx<Profile> get profile => to._profile;

  // Getters for Preferences
  static bool get isDarkMode => to._isDarkMode.val;
  static bool get flatModeEnabled => to._hasFlatMode.val;
  static bool get pointShareEnabled => to._hasPointToShare.val;

  // ** References **
  final _userBox = GetStorage('User');

  // ^ Open SharedPreferences on Init ^ //
  Future<UserService> init() async {
    // @ Init Shared Preferences
    await GetStorage.init('User');
    await GetStorage.init('Preferences');

    // Check User Status
    _hasUser(_userBox.hasData("user"));

    // Check if Exists
    if (_hasUser.value) {
      // Get Json Value
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
    } else {
      _isNewUser(true);
    }

    // Handle Contact Updates
    _contact.listen(_handleContact);

    // Set Theme
    SonrTheme.setDarkMode(isDark: _isDarkMode.val);
    return this;
  }

  // ^ Update Social in List ^ //
  static bool swapSocials(Contact_Social first, Contact_Social second) {
    // int idxOne = to._socials.keys.toList().indexOf(first.username);
    //int idxTwo = to._socials.keys.toList().indexOf(second.username);
    // controller._socials.swap(idxOne, idxTwo);
    return true;
  }

  // ^ Method to Create New User from Contact ^ //
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

  // # Resets User Data
  static void reset() async {
    to._userBox.remove('user');
  }

  // ^ Trigger iOS Local Network with Alert ^ //
  static toggleDarkMode() async {
    // Update Value
    to._isDarkMode.val = !to._isDarkMode.val;
    SonrTheme.setDarkMode(isDark: to._isDarkMode.val);
    return true;
  }

  // ^ Trigger iOS Local Network with Alert ^ //
  static toggleFlatMode() async {
    to._hasFlatMode.val = !to._hasFlatMode.val;
  }

  // ^ Trigger iOS Local Network with Alert ^ //
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

extension RxContact on Rx<Contact> {
  /// Add Address for Rx<Contact>
  void addAddress(
          {required String street,
          required String city,
          required String state,
          String streetTwo = "",
          String zipcode = "",
          String country = "",
          String countryCode = "",
          String label = ContactUtils.K_DEFAULT_LABEL}) =>
      this.update((val) {
        val?.addAddress(Contact_Address(
          label: label,
          street: street,
          state: state,
          streetTwo: streetTwo,
          zipcode: zipcode,
          country: country,
          countryCode: countryCode,
        ));
      });

  /// Add Date for Rx<Contact>
  void addDate(DateTime data, {String label = ContactUtils.K_DEFAULT_DATE_LABEL}) => this.update((val) {
        val?.addDate(data, label: label);
      });

  /// Add Email for Rx<Contact>
  void addEmail(String data) => this.update((val) {
        val?.addEmail(data);
      });

  /// Add Name for Rx<Contact>
  void addName(String data, String label) => this.update((val) {
        val?.addName(data, label);
      });

  /// Add Phone for Rx<Contact>
  void addPhone(String data, {String label = ContactUtils.K_DEFAULT_PHONE_LABEL}) => this.update((val) {
        val?.addPhone(data, label: label);
      });

  /// Add a Social Media Provider
  void addSocial(Contact_Social data) => this.update((val) {
        val?.addSocial(data);
      });

  /// Add Website for Rx<Contact>
  void addWebsite(String data, {String label = ContactUtils.K_DEFAULT_LABEL}) => this.update((val) async {
        // Get URL Link
        var link = await SonrService.getURL(data);

        // Set Website
        val?.addWebsite(link, label: label);
      });

  /// Delete a Social Media Provider
  void deleteSocial(Contact_Social data) => this.update((val) {
        val?.deleteSocial(data);
      });

  /// Set FirstName for Rx<Contact>
  void setFirstName(String data) => this.update((val) {
        val?.setFirstName(data);
      });

  /// Set LastName for Rx<Contact>
  void setLastName(String data) => this.update((val) {
        val?.setLastName(data);
      });

  /// Set Picture for Rx<Contact>
  void setPicture(Uint8List data) => this.update((val) {
        val?.setPicture(data);
      });

  /// Delete a Social Media Provider
  void updateSocial(Contact_Social data) => this.update((val) {
        val?.updateSocial(data);
      });
}
