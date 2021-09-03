import 'dart:async';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:sonr_app/style/style.dart';
import 'package:sonr_app/data/services/services.dart';

/// Contact File Name
const K_CONTACT_FILE = "contact.snr";

class ContactService extends GetxService {
  // Accessors
  static bool get isRegistered => Get.isRegistered<ContactService>();
  static ContactService get to => Get.find<ContactService>();

  // User Status Properties
  final _contact = Contact().obs;
  final _hasContact = false.val("hasContact", getBox: () => GetStorage('User'));
  final _fingerprint = "".val("fingerprint", getBox: () => GetStorage('User'));
  final _identity = "".val("identity", getBox: () => GetStorage('User'));
  final _mnemonic = "".val("mnemonic", getBox: () => GetStorage('User'));
  final _prefix = "".val("prefix", getBox: () => GetStorage('User'));
  final _sName = "".val("sName", getBox: () => GetStorage('User'));
  final _status = UserStatus.Default.obs;

  // User Reactive Properties
  /// User Status Reactive
  static Rx<UserStatus> get status => to._status;

  /// User Contact Reactive
  static Rx<Contact> get contact => to._contact;

  /// User SName
  static String get sName => to._status.value.hasUser ? to._sName.val.toLowerCase() : "";

  // References
  final _userBox = GetStorage('User');
  bool _setIntercom = false;

  /// Stream Subscription for Push Token
  late StreamSubscription<String> tokenSubscription;

  // ^ Constructer ^ //
  Future<ContactService> init() async {
    // Initialize Namebase
    Namebase.init(key: AppServices.handshakeKeys.item1, secret:  AppServices.handshakeKeys.item2);

    // Fetch User
    await GetStorage.init('User');
    _status(UserStatusUtils.fromBox(_hasContact.val));

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
  /// #### Method to Save Auth Response
  static Future<void> newAuth(String mnemonic, String sName, AuthResponse result) async {
    // Logging
    Logger.info(
      "Prefix: ${result.signedPrefix} \n Mnemonic: $mnemonic \n Fingerprint: ${result.signedFingerprint} \n Identity: ${result.publicKey}",
    );

    // Add UserRecord Domain
    if (await Namebase.addRecords(DNSRecord.newRegisteredRecords(
      fingerprint: result.signedFingerprint,
      prefix: result.signedPrefix,
      name: sName,
      publicKey: result.publicKey,
    ))) {
      // Save Info
      to._sName.val = sName;
      to._mnemonic.val = mnemonic;
      to._identity.val = result.publicKey;
      to._fingerprint.val = result.signedFingerprint;
      to._prefix.val = result.signedPrefix;

      // Initialize Client Name
      Namebase.initName(to._sName.val);
    }
    // Failed to Add Auth to DNS
    else {
      // Reset info
      to._sName.val = "";
      to._mnemonic.val = "";
      to._identity.val = "";
      to._fingerprint.val = "";
      to._prefix.val = "";

      // Display Error
      AppRoute.snack(SnackArgs.error("Could not create new user."));
    }

    // Analytics
    Logger.event(event: AppEvent.user(UserEvent.NewSName, parameters: {'sName': sName}));
  }

  /// #### Method to Create New User from Contact
  static Future<void> newContact(Contact newContact) async {
    // Write Contact to Disk
    await DeviceService.writeFile(K_CONTACT_FILE, newContact.writeToBuffer());
    to._hasContact.val = true;

    // Set Contact for User
    to._contact(newContact);
    to._contact.refresh();

    // Set User Properties for Intercom/Firebase
    if (!to._setIntercom) {
      // Set Intercom
      await Logger.initProfile(to._contact.value);
      to._setIntercom = true;
    }

    // Update Status
    to._status(UserStatus.Existing);
  }



  // * ------------------- Helpers ----------------------------
  /// #### Helper: Method to Handle Contact Updates
  void _handleContact(Contact data) async {
    // Write Contact to Disk
    await DeviceService.writeFile(K_CONTACT_FILE, data.writeToBuffer());

    // Save Updated User to Disk
    Logger.event(event: AppEvent.user(UserEvent.UpdatedProfile));

    // Send Update to Node
    if (NodeService.status.value.isConnected) {
      NodeService.setProfile(data);
    }
  }


  // * ------------------- Initializers ----------------------------
  /// #### Method Initializes existing user
  Future<bool> _initExisting() async {
    // Check if GetStorage contains contact
    if (_userBox.hasData("contact")) {
      try {
        // Fetch Contact
        final data = _userBox.read<String>("contact");
        if (data != null) {
          // Write the contact to disk
          final contact = Contact.fromJson(data);
          await DeviceService.writeFile(K_CONTACT_FILE, contact.writeToBuffer());

          // Erase Contact entry
          _userBox.remove("contact");
        }
      } catch (e) {
        // Erase Contact entry
        _userBox.remove("contact");

        // Failed to read contact
        Logger.error("Failed to read contact: " + e.toString());
      }
    }

    // Read From File
    final data = await DeviceService.readFile(K_CONTACT_FILE);
    if (data != null) {
      _contact(Contact.fromBuffer(data.toList()));

      // Set SName Value
      if (!_userBox.hasData("sName")) {
        _sName.val = _contact.value.sName;
      }

      // Initialize Client Name
      Namebase.initName(_sName.val);

      // Set User Properties
      await Logger.initProfile(_contact.value);
      _setIntercom = true;

      // Return Validated Records
      return await Namebase.hasAllRecords();
    } else {
      _status(UserStatus.New);
      Logger.warn("RESET: Contact and User");
      return false;
    }
  }
}
