import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
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
  final _pushToken = "".obs;

  // User Reactive Properties
  static Rx<UserStatus> get status => to._status;
  static Rx<Contact> get contact => to._contact;
  static RxString get pushToken => to._pushToken;
  static String get sName => to._status.value.hasUser ? to._contact.value.sName.toLowerCase() : "";

  // References
  final _userBox = GetStorage('User');
  bool _setIntercom = false;

  /// Stream Subscription for Push Token
  late StreamSubscription<String> tokenSubscription;

  // ^ Constructer ^ //
  Future<ContactService> init() async {
    // Fetch User
    await GetStorage.init('User');
    _status(UserStatusUtils.fromBox(_userBox.hasData("contact")));

    // Check for Mobile Device
    if (DeviceService.isMobile) {
      // Register Push Token Subscription
      tokenSubscription = _pushToken.listen(_handlePushToken);

      // Get Push Token
      _pushToken(await FirebaseMessaging.instance.getToken());
      _pushToken.bindStream(FirebaseMessaging.instance.onTokenRefresh);

      // Send Token to Intercom
      await Intercom.sendTokenToIntercom(_pushToken.value);
    }

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
        await Logger.initProfile(contact);
        _setIntercom = true;

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

  @override
  void onClose() {
    tokenSubscription.cancel();
    super.onClose();
  }

// * ------------------- Methods ----------------------------
  /// #### Method finds Push Token for User
  static Future<String?> findPushToken(String sName) async {
    return FirebaseFirestore.instance.collection('push-users').doc(sName).get().then((snapshot) {
      Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;

      if (data.containsKey('pushToken')) {
        return data['pushToken'];
      } else {
        return null;
      }
    });
  }

  /// #### Method to Create New User from Contact
  static Future<void> newContact(Contact newContact) async {
    // Clean Data
    newContact.profile.firstName.capitalizeFirst;
    newContact.profile.lastName.capitalizeFirst;

    // Save User/Contact to Disk
    await to._userBox.write("contact", newContact.writeToJson());

    // Set User Properties for Intercom/Firebase
    if (!to._setIntercom) {
      await Logger.initProfile(newContact);
      to._setIntercom = true;
    }

    // Set Contact for User
    to._contact(newContact);
    to._contact.refresh();

    // Update Status
    to._status(UserStatus.Existing);
  }

  /// Method updates Push Token for User
  static Future<void> updateUser(String token) async {
    if (ContactService.isRegistered) {
      return FirebaseFirestore.instance
          .collection('push-users')
          .doc(ContactService.sName)
          .set({
            'firstName': ContactService.contact.value.firstName,
            'pushToken': token,
          })
          .then((value) => print("User Added"))
          .catchError((error) => print("Failed to add user: $error"));
    } else {
      return Future.value(null);
    }
  }

  // # Helper: Method to Handle Contact Updates
  void _handleContact(Contact data) async {
    // Only update contact with user
    if (_status.value.hasUser) {
      // Save Updated User to Disk
      await to._userBox.write("contact", data.writeToJson());
      Logger.event(event: AnalyticsEvent.user(AnalyticsUserEvent.UpdatedProfile));

      // Send Update to Node
      if (NodeService.status.value.isConnected) {
        NodeService.setProfile(data);
      }
    }
  }

  /// Helper: Handles Push Token Subscription
  void _handlePushToken(String token) {
    updateUser(token);
  }
}
