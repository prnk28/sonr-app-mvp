import 'dart:async';
import 'dart:typed_data';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:sonr_app/theme/theme.dart';
import 'package:sonr_app/data/data.dart';

class UserService extends GetxService {
  // Accessors
  static bool get isRegistered => Get.isRegistered<UserService>();
  static UserService get to => Get.find<UserService>();

  // ** User Reactive Properties **
  final _hasUser = false.obs;
  final _isNewUser = false.obs;
  final _contact = Rx<Contact>(null);
  final _user = Rx<User>(null);

  // ** Contact Reactive Properties **
  final _firstName = "".obs;
  final _lastName = "".obs;
  final _phone = "".obs;
  final _email = "".obs;
  final _website = "".obs;
  final _picture = Rx<Uint8List>(null);
  final _socials = <Contact_SocialTile>[].obs;

  // Preferences
  final _brightness = Rx<Brightness>(Brightness.light);
  final _isDarkMode = false.val('isDarkMode', getBox: () => GetStorage('Preferences'));
  final _hasFlatMode = false.val('flatModeEnabled', getBox: () => GetStorage('Preferences'));
  final _hasPointToShare = false.val('pointToShareEnabled', getBox: () => GetStorage('Preferences'));

  // **  Getter Methods for Contact Properties **
  static RxBool get hasUser => to._hasUser;
  static RxBool get isNewUser => to._isNewUser;
  static Rx<User> get user => to._user;
  static Rx<Contact> get contact => to._contact;

  // Getters for Preferences
  static Rx<Brightness> get brightness => to._brightness;
  static bool get isDarkMode => to._isDarkMode.val;
  static bool get flatModeEnabled => to._hasFlatMode.val;
  static bool get pointShareEnabled => to._hasPointToShare.val;

  // Contact Values
  static RxString get firstName => to._firstName;
  static RxString get lastName => to._lastName;
  static RxString get phone => to._phone;
  static Rx<Uint8List> get picture => to._picture;
  static RxString get email => to._email;
  static RxString get website => to._website;
  static RxList<Contact_SocialTile> get socials => to._socials;
  static int get tileCount => to._socials.length;

  // Username
  static String get username => UserService.user.value.hasProfile() ? UserService.user.value.profile.username : "@TempUsername";

  // ** Checks if Required Data for Connection Exists ** //

  // ** References **
  final _userBox = GetStorage('User');

  // ^ Open SharedPreferences on Init ^ //
  Future<UserService> init() async {
    // @ Init Shared Preferences
    await GetStorage.init('User');
    await GetStorage.init('Preferences');

    // @ Check User Status
    _hasUser(_userBox.hasData("user"));

    // @ Check if User Exists
    if (_hasUser.value) {
      // Get Json Value
      var profileJson = _userBox.read("user");
      var user = User.fromJson(profileJson);

      // Set Contact Values
      _user(user);
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

    // @ Listen to Contact Updates
    _contact.listen(_handleContactUpdate);
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

  // ^ Method to Create New User from Contact ^ //
  static Future<User> newUser(Contact providedContact, {bool withSonrConnect = false}) async {
    // Set Valuse
    to._isNewUser(true);

    // Connect Sonr Node
    if (withSonrConnect) {
      Get.find<SonrService>().connectNewUser(UserService.contact.value, UserService.username);
    }

    // Set Contact for User
    return await to._saveContactForUser(providedContact);
  }

  // ^ Method to Save Changes ^ //
  static Future<User> saveChanges() async {
    // Set Contact for User
    return await to._saveContactForUser(Contact(
        firstName: to._firstName.value,
        lastName: to._lastName.value,
        phone: to._phone.value,
        email: to._email.value,
        website: to._website.value,
        picture: to._picture.value.toList() ?? [],
        socials: to._socials ?? []));
  }

  // # Saves Contact User to Disk
  Future<User> _saveContactForUser(Contact contact) async {
    // @ Initialize
    _contact(contact);
    _contact.refresh();

    User userValue;
    if (_hasUser.value) {
      // Update Existing User with new Contact
      var profileJson = _userBox.read("user");
      userValue = User.fromJson(profileJson);
      userValue.contact = contact;

      // @ Save to SharedPreferences, Update SonrNode
      await _userBox.write("user", userValue.writeToJson());
      SonrService.setProfile(contact);
    }
    // Create New User with Contact
    else {
      userValue = User(contact: contact);
      await _userBox.write("user", userValue.writeToJson());
      _hasUser(true);
    }
    user(userValue);
    return user.value;
  }

  // # Listen to Contact Updates
  _handleContactUpdate(Contact contact) async {
    // Set Values
    to._firstName(contact.firstName);
    to._lastName(contact.lastName);
    to._phone(contact.phone);
    to._email(contact.email);
    to._website(contact.website);
    to._picture(Uint8List.fromList(contact.picture));
    to._socials(contact.socials);

    // Refresh Lists
    to._socials.refresh();
    to._picture.refresh();
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
