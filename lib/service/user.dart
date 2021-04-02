import 'dart:async';
import 'dart:typed_data';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:sonr_app/theme/theme.dart';

class UserService extends GetxService {
  // Accessors
  static bool get isRegistered => Get.isRegistered<UserService>();
  static UserService get to => Get.find<UserService>();

  // ** User Reactive Properties **
  final _isExisting = false.obs;
  final _isNewUser = false.obs;
  final _contact = Rx<Contact>();

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
  final _isDarkMode = false.val('isDarkMode', getBox: () => GetStorage('Preferences'));
  final _hasFlatMode = false.val('flatModeEnabled', getBox: () => GetStorage('Preferences'));
  final _hasPointToShare = false.val('pointToShareEnabled', getBox: () => GetStorage('Preferences'));

  // **  Getter Methods for Contact Properties **
  static RxBool get isExisting => to._isExisting;
  static RxBool get isNewUser => to._isNewUser;
  static Rx<Contact> get contact => to._contact;

  // Getters for Preferences
  static Rx<Brightness> get brightness => to._brightness;
  static bool get isDarkMode => to._isDarkMode.val;
  static bool get flatModeEnabled => to._hasFlatMode.val;
  static bool get pointShareEnabled => to._hasPointToShare.val;

  static RxString get firstName => to._firstName;
  static RxString get lastName => to._lastName;
  static RxString get phone => to._phone;
  static RxString get email => to._email;
  static RxString get website => to._website;

  static Rx<Uint8List> get picture => to._picture;
  static RxList<Contact_SocialTile> get socials => to._socials;
  static int get tileCount => to._socials.length;
  static String get username => UserService.current.hasProfile() ? UserService.current.profile.username : UserService.current.contact.tempUsername;
  static String get wireID => "${to._firstName.value}-${to._lastName.value}";

  // ** Return Current User Object **
  static User get current {
    var controller = to;
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
      _contact(user.contact);
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
    _brightness(_isDarkMode.val ? Brightness.dark : Brightness.light);

    // Update Android and iOS Status Bar
    _isDarkMode.val
        ? SystemChrome.setSystemUIOverlayStyle(
            SystemUiOverlayStyle(statusBarColor: Colors.transparent, statusBarBrightness: Brightness.dark, statusBarIconBrightness: Brightness.light))
        : SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
            statusBarColor: Colors.transparent, statusBarBrightness: Brightness.light, statusBarIconBrightness: Brightness.dark));
    return this;
  }

  // ^ Add Social to List ^ //
  static addSocial(Contact_SocialTile value) {
    var controller = to;
    controller._socials.add(value);
    saveChanges();
  }

  // ^ Delete Social from List ^ //
  static bool deleteSocial(Contact_SocialTile value) {
    var controller = to;
    if (controller._socials.contains(value)) {
      controller._socials.remove(value);
      saveChanges();
      return true;
    }
    return false;
  }

  // ^ Update Social in List ^ //
  static bool swapSocials(Contact_SocialTile first, Contact_SocialTile second) {
    var controller = to;
    int idxOne = controller._socials.indexOf(first);
    int idxTwo = controller._socials.indexOf(second);
    controller._socials.swap(idxOne, idxTwo);
    saveChanges();
    return true;
  }

  // ^ Update Social in List ^ //
  static bool updateSocial(Contact_SocialTile value) {
    var controller = to;
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
    var controller = to;
    controller._firstName(value);
    saveChanges();
  }

  // ^ Modify Contact LastName Value ^ //
  static setLastName(String value) {
    var controller = to;
    controller._lastName(value);
    saveChanges();
  }

  // ^ Modify Contact Phone Value ^ //
  static setPhone(String value) {
    var controller = to;
    controller._phone(value);
    saveChanges();
  }

  // ^ Modify Contact Email Value ^ //
  static setEmail(String value) {
    var controller = to;
    controller._email(value);
    saveChanges();
  }

  // ^ Modify Contact Website Value ^ //
  static setWebsite(String value) {
    var controller = to;
    controller._website(value);
    saveChanges();
  }

  // ^ Modify Contact Picture Value ^ //
  static setPicture(Uint8List value) {
    var controller = to;
    controller._picture(value);
    saveChanges();
  }

  // ^ Method to Save Changes ^ //
  static Future<User> saveChanges({Contact providedContact, bool isNewUser = false}) async {
    // @ Initialize
    var controller = to;
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
    _contact(contact);
    User user;
    if (_isExisting.value) {
      // Update Existing User with new Contact
      var profileJson = _userBox.read("user");
      user = User.fromJson(profileJson);
      user.contact = contact;

      // @ Save to SharedPreferences, Update SonrNode
      _userBox.write("user", user.writeToJson());
      SonrService.setProfile(contact);
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

  // ^ Trigger iOS Local Network with Alert ^ //
  static toggleDarkMode() async {
    // Update Value
    to._isDarkMode.val = !to._isDarkMode.val;

    // Update Android and iOS Status Bar
    to._isDarkMode.val
        ? SystemChrome.setSystemUIOverlayStyle(
            SystemUiOverlayStyle(statusBarColor: Colors.transparent, statusBarBrightness: Brightness.dark, statusBarIconBrightness: Brightness.light))
        : SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
            statusBarColor: Colors.transparent, statusBarBrightness: Brightness.light, statusBarIconBrightness: Brightness.dark));

    // Update Theme
    Get.changeThemeMode(to._isDarkMode.val ? ThemeMode.dark : ThemeMode.light);
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
}
