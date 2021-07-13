import 'dart:async';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:sonr_app/style/style.dart';
import 'package:sonr_app/data/services/services.dart';

class ContactService extends GetxService {
  // Accessors
  static bool get isRegistered => Get.isRegistered<ContactService>();
  static ContactService get to => Get.find<ContactService>();

  // User Status Properties
  final _contact = Contact().obs;
  final _status = UserStatus.Default.obs;

  // User Reactive Properties
  static Rx<UserStatus> get status => to._status;
  static Rx<Contact> get contact => to._contact;
  static String get sName => to._status.value.hasUser ? to._contact.value.sName.toLowerCase() : "";

  // References
  final _userBox = GetStorage('User');

  // ^ Constructer ^ //
  Future<ContactService> init() async {
    await GetStorage.init('User');
    _status(UserStatusUtils.fromBox(_userBox.hasData("contact")));

    // Check if Exists
    if (_status.value.hasUser) {
      try {
        // Get Contact JSON
        var profileJson = _userBox.read("contact");
        var contact = Contact.fromJson(profileJson);

        // Capitalize First and Last Name
        contact.profile.firstName.capitalizeFirst;
        contact.profile.lastName.capitalizeFirst;

        // Set User Properties
        Logger.initProfile(contact.profile);

        // Set Contact Values
        _contact(contact);
      } catch (e) {
        // Delete User
        _userBox.remove('contact');
        _status(UserStatus.New);
        Logger.warn("RESET: Contact and User");
      }
    } else {
      _status(UserStatus.New);
      Logger.info("New User!");
    }

    // Handle Contact Updates
    _contact.listen(_handleContact);
    return this;
  }

// * ------------------- Methods ----------------------------
  /// #### Method to Create New User from Contact
  static Future<void> newContact(Contact newContact) async {
    // Set Contact for User
    to._contact(newContact);
    to._contact.refresh();

    // Save User/Contact to Disk
    await to._userBox.write("contact", newContact.writeToJson());
    to._status(UserStatus.Existing);
  }

  // # Helper: Method to Handle Contact Updates
  void _handleContact(Contact data) async {
    // Save Updated User to Disk
    await to._userBox.write("contact", data.writeToJson());

    // Send Update to Node
    if (NodeService.status.value.isConnected) {
      NodeService.setProfile(data);
    }
  }
}
