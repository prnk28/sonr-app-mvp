import 'dart:async';
import 'dart:typed_data';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:sonr_app/theme/theme.dart';

class UserService extends GetxService {
  // ** User Reactive Properties **
  final _isExisting = false.obs;
  final _isNewUser = false.obs;

  // ** Contact Reactive Properties **
  final _firstName = "".obs;
  final _lastName = "".obs;
  final _phone = "".obs;
  final _email = "".obs;
  final _website = "".obs;
  final _picture = Rx<Uint8List>();
  final _socials = <Contact_SocialTile>[].obs;

  // Preferences
  final _brightness = Rx<Brightness>();
  final _direction = Rx<CompassEvent>();
  final _isDarkMode = true.obs;
  final _hasPointToShare = false.obs;

  // **  Getter Methods for Contact Properties **
  static RxBool get isExisting => Get.find<UserService>()._isExisting;
  static RxBool get isNewUser => Get.find<UserService>()._isNewUser;

  // Getters for Preferences
  static Rx<Brightness> get brightness => Get.find<UserService>()._brightness;
  static Rx<CompassEvent> get direction => Get.find<UserService>()._direction;
  static RxBool get isDarkMode => Get.find<UserService>()._isDarkMode;
  static RxBool get hasPointToShare => Get.find<UserService>()._hasPointToShare;

  static RxString get firstName => Get.find<UserService>()._firstName;
  static RxString get lastName => Get.find<UserService>()._lastName;
  static RxString get phone => Get.find<UserService>()._phone;
  static RxString get email => Get.find<UserService>()._email;
  static RxString get website => Get.find<UserService>()._website;

  static Rx<Uint8List> get picture => Get.find<UserService>()._picture;
  static RxList<Contact_SocialTile> get socials => Get.find<UserService>()._socials;
  static int get tileCount => Get.find<UserService>()._socials.length;
  static String get username => UserService.current.hasProfile() ? UserService.current.profile.username : UserService.current.contact.tempUsername;
  static String get wireID => "${Get.find<UserService>()._firstName.value}-${Get.find<UserService>()._lastName.value}";

  // ** Return Current User Object **
  static User get current {
    var controller = Get.find<UserService>();
    // Return Existing User
    if (controller._isExisting.value) {
      var profileJson = controller._userBox.read("user");
      return User.fromJson(profileJson);
    }
    return new User();
  }

  // ** References **
  final _userBox = GetStorage('User');
  final _prefsBox = GetStorage('Preferences');

  // ^ Open SharedPreferences on Init ^ //
  Future<UserService> init() async {
    // @ Init Shared Preferences
    await GetStorage.init('User');
    await GetStorage.init('Preferences');

    // @ Check User Status
    _isExisting(_userBox.hasData("user"));

    // @ Check if User Exists
    if (_isExisting.value) {
      // Get Json Value
      var profileJson = _userBox.read("user");
      var user = User.fromJson(profileJson);

      // Set Contact Values
      _firstName(user.contact.firstName);
      _lastName(user.contact.lastName);
      _phone(user.contact.phone);
      _email(user.contact.email);
      _website(user.contact.website);
      _picture(Uint8List.fromList(user.contact.picture));
      _socials(user.contact.socials);
    } else {
      _isNewUser(true);
    }

    // Set Preferences
    _isDarkMode(_prefsBox.read("isDarkMode") ?? false);
    _hasPointToShare(_prefsBox.read("hasPointToShare") ?? false);
    _brightness(_isDarkMode.value ? Brightness.dark : Brightness.light);

    // Update Android and iOS Status Bar
    _isDarkMode.value
        ? SystemChrome.setSystemUIOverlayStyle(
            SystemUiOverlayStyle(statusBarColor: Colors.transparent, statusBarBrightness: Brightness.dark, statusBarIconBrightness: Brightness.light))
        : SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
            statusBarColor: Colors.transparent, statusBarBrightness: Brightness.light, statusBarIconBrightness: Brightness.dark));
    return this;
  }

  // ^ Add Social to List ^ //
  static addSocial(Contact_SocialTile value) {
    var controller = Get.find<UserService>();
    controller._socials.add(value);
    saveChanges();
  }

  // ^ Delete Social from List ^ //
  static bool deleteSocial(Contact_SocialTile value) {
    var controller = Get.find<UserService>();
    if (controller._socials.contains(value)) {
      controller._socials.remove(value);
      saveChanges();
      return true;
    }
    return false;
  }

  // ^ Update Social in List ^ //
  static bool swapSocials(Contact_SocialTile first, Contact_SocialTile second) {
    var controller = Get.find<UserService>();
    int idxOne = controller._socials.indexOf(first);
    int idxTwo = controller._socials.indexOf(second);
    controller._socials.swap(idxOne, idxTwo);
    saveChanges();
    return true;
  }

  // ^ Update Social in List ^ //
  static bool updateSocial(Contact_SocialTile value) {
    var controller = Get.find<UserService>();
    if (controller._socials.contains(value)) {
      var idx = controller._socials.indexOf(value);
      controller._socials[idx] = value;
      saveChanges();
      return true;
    }
    return false;
  }

  // ^ Modify Contact FirstName Value ^ //
  static setFirstName(String value) {
    var controller = Get.find<UserService>();
    controller._firstName(value);
    saveChanges();
  }

  // ^ Modify Contact LastName Value ^ //
  static setLastName(String value) {
    var controller = Get.find<UserService>();
    controller._lastName(value);
    saveChanges();
  }

  // ^ Modify Contact Phone Value ^ //
  static setPhone(String value) {
    var controller = Get.find<UserService>();
    controller._phone(value);
    saveChanges();
  }

  // ^ Modify Contact Email Value ^ //
  static setEmail(String value) {
    var controller = Get.find<UserService>();
    controller._email(value);
    saveChanges();
  }

  // ^ Modify Contact Website Value ^ //
  static setWebsite(String value) {
    var controller = Get.find<UserService>();
    controller._website(value);
    saveChanges();
  }

  // ^ Modify Contact Picture Value ^ //
  static setPicture(Uint8List value) {
    var controller = Get.find<UserService>();
    controller._picture(value);
    saveChanges();
  }

  // ^ Method to Save Changes ^ //
  static Future<User> saveChanges({Contact providedContact, bool isNewUser = false}) async {
    // @ Initialize
    var controller = Get.find<UserService>();
    controller._isNewUser(isNewUser);

    // @ Check if Contact was Provided
    var contact = providedContact ??
        Contact(
            firstName: controller._firstName.value,
            lastName: controller._lastName.value,
            phone: controller._phone.value,
            email: controller._email.value,
            website: controller._website.value,
            picture: controller._picture.value.toList() ?? [],
            socials: controller._socials ?? []);

    // Set Contact for User
    return await controller._saveContactForUser(contact);
  }

  // ^ Saves Contact User to Disk ^ //
  Future<User> _saveContactForUser(Contact contact) async {
    // @ Initialize
    User user;
    if (_isExisting.value) {
      // Update Existing User with new Contact
      var profileJson = _userBox.read("user");
      user = User.fromJson(profileJson);
      user.contact = contact;

      // @ Save to SharedPreferences, Update SonrNode
      _userBox.write("user", user.writeToJson());
      SonrService.setContact(contact);
    }
    // Create New User with Contact
    else {
      user = new User(contact: contact);
      _userBox.write("user", user.writeToJson());
      _isExisting(true);
    }
    return user;
  }

  // ************************* //
  // ** Preference Requests ** //
  // ************************* //

  // ^ BoxStorage Theme Mode Helper ^ //
  bool _loadThemeFromBox() => _prefsBox.read("isDarkMode") ?? false;
  _saveThemeToBox(bool isDarkMode) {
    _prefsBox.write("isDarkMode", isDarkMode);
    _prefsBox.save();
  }

  // ^ Trigger iOS Local Network with Alert ^ //
  static toggleDarkMode() async {
    // Update Value
    Get.find<UserService>()._isDarkMode(!Get.find<UserService>()._isDarkMode.value);
    Get.find<UserService>()._isDarkMode.refresh();

    // Update Android and iOS Status Bar
    Get.find<UserService>()._isDarkMode.value
        ? SystemChrome.setSystemUIOverlayStyle(
            SystemUiOverlayStyle(statusBarColor: Colors.transparent, statusBarBrightness: Brightness.dark, statusBarIconBrightness: Brightness.light))
        : SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
            statusBarColor: Colors.transparent, statusBarBrightness: Brightness.light, statusBarIconBrightness: Brightness.dark));

    // Update Theme
    Get.changeThemeMode(Get.find<UserService>()._loadThemeFromBox() ? ThemeMode.light : ThemeMode.dark);

    // Save Preference
    Get.find<UserService>()._saveThemeToBox(!Get.find<UserService>()._loadThemeFromBox());
    return true;
  }

  // ^ BoxStorage Point to Share Mode Helper ^ //
  bool _loadPointToShareFromBox() => _prefsBox.read("hasPointToShare") ?? false;
  _savePointToShareToBox(bool hasPointToShare) => _prefsBox.write("hasPointToShare", hasPointToShare);

  // ^ Trigger iOS Local Network with Alert ^ //
  static togglePointToShare() async {
    // Update Value
    Get.find<UserService>()._hasPointToShare(!Get.find<UserService>()._hasPointToShare.value);
    Get.find<UserService>()._hasPointToShare.refresh();

    // Save Preference
    Get.find<UserService>()._savePointToShareToBox(!Get.find<UserService>()._loadPointToShareFromBox());
    return true;
  }
}
