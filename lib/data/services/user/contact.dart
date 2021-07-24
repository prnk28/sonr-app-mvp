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
  final _fingerprint = "".val("fingerprint", getBox: () => GetStorage('User'));
  final _identity = "".val("identity", getBox: () => GetStorage('User'));
  final _mnemonic = "".val("mnemonic", getBox: () => GetStorage('User'));
  final _pushToken = "".obs;
  final _prefix = "".val("prefix", getBox: () => GetStorage('User'));
  final _status = UserStatus.Default.obs;

  // User Reactive Properties
  /// User Status Reactive
  static Rx<UserStatus> get status => to._status;

  /// User Contact Reactive
  static Rx<Contact> get contact => to._contact;

  /// User Push Token Reactive
  static RxString get pushToken => to._pushToken;

  /// User SName
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
      // Get Push Token
      _pushToken(await FirebaseMessaging.instance.getToken());
      _pushToken.bindStream(FirebaseMessaging.instance.onTokenRefresh);
      updateUser(_pushToken.value);

      // Send Token to Intercom
      await Intercom.sendTokenToIntercom(_pushToken.value);

      // Register Push Token Subscription
      tokenSubscription = _pushToken.listen(_handlePushToken);
    }

    // Check if Exists
    if (_status.value.hasUser) {
      bool result = await _initExisting();
      if (result) {
        _status(UserStatus.Existing);
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
    return FirebaseFirestore.instance.collection('users').doc(sName).get().then((snapshot) {
      Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;

      if (data.containsKey('pushToken')) {
        return data['pushToken'];
      } else {
        return null;
      }
    });
  }

  /// #### Method to Save Auth Response
  static Future<void> newAuth(String mnemonic, String sName, AuthResponse result) async {
    // Logging
    Logger.info(
      "Prefix: ${result.signedPrefix} \n Mnemonic: $mnemonic \n Fingerprint: ${result.signedFingerprint} \n Identity: ${result.publicKey}",
    );

    // Save Info
    to._mnemonic.val = mnemonic;
    to._identity.val = result.publicKey;
    to._fingerprint.val = result.signedFingerprint;
    to._prefix.val = result.signedPrefix;

    // Add UserRecord Domain
    await Namebase.addRecords(DNSRecord.newRegisteredRecords(
      fingerprint: result.signedFingerprint,
      prefix: result.signedPrefix,
      name: sName,
      publicKey: result.publicKey,
    ));

    // Analytics
    Logger.event(event: AppEvent.user(UserEvent.NewSName, parameters: {'sName': sName}));
  }

  /// #### Method to Create New User from Contact
  static Future<void> newContact(Contact newContact) async {
    // Set Contact for User
    to._contact(newContact);
    to._contact.refresh();

    // Set User Properties for Intercom/Firebase
    if (!to._setIntercom) {
      await Logger.initProfile(to._contact.value);
      to._setIntercom = true;
    }

    // Update Status
    to._status(UserStatus.Existing);
  }

  /// #### Method updates Push Token for User
  static Future<void> updateUser(String token) async {
    if (ContactService.isRegistered) {
      return FirebaseFirestore.instance
          .collection('push-users')
          .doc(to._contact.value.sName.toLowerCase())
          .set({
            'firstName': ContactService.contact.value.firstName,
            'pushToken': token,
          })
          .then((value) => print("User Added"))
          .catchError((error) => print("Failed to add user: $error"));
    } else {
      return null;
    }
  }

  // * ------------------- Helpers ----------------------------
  /// #### Helper: Method to Handle Contact Updates
  void _handleContact(Contact data) async {
    // Save Updated User to Disk
    await to._userBox.write("contact", data.writeToJson());
    Logger.event(event: AppEvent.user(UserEvent.UpdatedProfile));

    // Send Update to Node
    if (NodeService.status.value.isConnected) {
      NodeService.setProfile(data);
    }
  }

  /// #### Helper: Handles Push Token Subscription
  void _handlePushToken(String token) {
    updateUser(token);
  }

  // * ------------------- Initializers ----------------------------
  /// #### Method Initializes existing user
  Future<bool> _initExisting() async {
    // Checker for Try Block
    bool hasLocalUser = false;
    bool hasAllRecords = false;

    // 1. Validate HS Record
    if (await Namebase.hasAllRecords()) {
      // Set Record Checker
      hasAllRecords = true;

      // 2. Verify Local Copy
      try {
        // Get Contact JSON
        var profileJson = _userBox.read("contact");
        var contact = Contact.fromJson(profileJson);

        // Capitalize First and Last Name
        contact.profile.firstName.capitalizeFirst;
        contact.profile.lastName.capitalizeFirst;
        hasLocalUser = true;

        // Set Contact Values
        _contact(contact);
      } catch (e) {
        // Delete User
        _userBox.remove('contact');
        _status(UserStatus.New);
        Logger.warn("RESET: Contact and User");
      }
    }

    // 3. Push Notif Key to Services
    if (hasLocalUser && hasAllRecords) {
      // Set User Properties
      await Logger.initProfile(_contact.value);
      _setIntercom = true;
    }
    return hasLocalUser && hasAllRecords;
  }
}
