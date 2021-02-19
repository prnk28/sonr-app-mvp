import 'dart:async';
import 'dart:typed_data';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sonr_app/service/sonr_service.dart';

class UserService extends GetxService {
  // ** User Reactive Properties **
  final _exists = false.obs;

  // ** Contact Reactive Properties **
  final _firstName = "".obs;
  final _lastName = "".obs;
  final _phone = "".obs;
  final _email = "".obs;
  final _website = "".obs;
  final _picture = Rx<Uint8List>();
  final _socials = <Contact_SocialTile>[].obs;

  // **  Getter Methods **
  static RxBool get exists => Get.find<UserService>()._exists;
  static RxString get firstName => Get.find<UserService>()._firstName;
  static RxString get lastName => Get.find<UserService>()._lastName;
  static RxString get phone => Get.find<UserService>()._phone;
  static RxString get email => Get.find<UserService>()._email;
  static RxString get website => Get.find<UserService>()._website;
  static Rx<Uint8List> get picture => Get.find<UserService>()._picture;
  static RxList<Contact_SocialTile> get socials => Get.find<UserService>()._socials;
  static int get tileCount => Get.find<UserService>()._socials.length;

  // ** Return Current User Object **
  static User get current {
    var controller = Get.find<UserService>();
    // Return Existing User
    if (controller._exists.value) {
      var profileJson = controller._prefs.getString("user");
      return User.fromJson(profileJson);
    }
    return new User();
  }

  // ** References **
  SharedPreferences _prefs;

  // ^ Open SharedPreferences on Init ^ //
  Future<UserService> init() async {
    // @ Init Shared Preferences
    _prefs = await SharedPreferences.getInstance();

    // @ Check User Status
    _exists(_prefs.containsKey("user"));

    // @ Check if User Exists
    if (_exists.value) {
      // Get Json Value
      var profileJson = _prefs.getString("user");
      var user = User.fromJson(profileJson);

      // Set Contact Values
      _firstName(user.contact.firstName);
      _lastName(user.contact.lastName);
      _phone(user.contact.phone);
      _email(user.contact.email);
      _website(user.contact.website);
      _picture(Uint8List.fromList(user.contact.picture));
      _socials(user.contact.socials);
    }
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
  static Future<User> saveChanges({Contact providedContact}) async {
    // @ Initialize
    var controller = Get.find<UserService>();

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
    if (_exists.value) {
      // Update Existing User with new Contact
      var profileJson = _prefs.getString("user");
      user = User.fromJson(profileJson);
      user.contact = contact;

      // @ Save to SharedPreferences, Update SonrNode
      _prefs.setString("user", user.writeToJson());
      SonrService.setContact(contact);
    }
    // Create New User with Contact
    else {
      user = new User(contact: contact);
      _prefs.setString("user", user.writeToJson());
    }

    return user;
  }
}

// @ Dart Util to Swap Indexes In List //
extension ListSwap<T> on List<T> {
  void swap(int index1, int index2) {
    var length = this.length;
    RangeError.checkValidIndex(index1, this, "index1", length);
    RangeError.checkValidIndex(index2, this, "index2", length);
    if (index1 != index2) {
      var tmp1 = this[index1];
      this[index1] = this[index2];
      this[index2] = tmp1;
    }
  }
}
