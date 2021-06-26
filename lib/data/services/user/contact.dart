import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
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
  static String get sName => to._status.value.hasUser ? to._contact.value.sName : "";

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
  /// @ Method to Create New User from Contact
  static Future<void> newContact(Contact newContact) async {
    // Set Contact for User
    to._contact(newContact);
    to._contact.refresh();

    // Save User/Contact to Disk
    await to._userBox.write("contact", newContact.writeToJson());
    to._status(UserStatus.Existing);
  }

  /// @ Method Collects user Feedback and Sends Email
  static void sendFeedback(UserFeedback data) async {
    var screenshotPath = "";

    // Save Image
    final Directory output = await getTemporaryDirectory();
    final String screenshotFilePath = '${output.path}/feedback.png';
    final File screenshotFile = File(screenshotFilePath);
    await screenshotFile.writeAsBytes(data.screenshot);
    screenshotPath = screenshotFilePath;

    // Check if Has Screenshot
    // Create Instance
    Reference ref = FirebaseStorage.instance.ref().child('screenshots').child(screenshotPath);

    // Set Metadata
    final feedback = SettableMetadata(
      contentType: 'image/jpeg',
      customMetadata: {'path': screenshotPath},
    );

    // Upload to Firebase
    UploadTask uploadTask = ref.putFile(File(screenshotPath), feedback);
    await uploadTask.whenComplete(() => to._handleUploadScreenshot(ref, data.text));
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

// * ------------------- Callbacks ----------------------------
  /// @ Helper: Posts User Feedback
  Future<void> _handlePostFeedback(String message, {String? link}) async {
    // Update Firestore
    DocumentReference docRef = FirebaseFirestore.instance.collection("feedback").doc();

    // Check for Link
    if (link != null) {
      docRef.update({
        "firstname": ContactService.contact.value.profile.firstName,
        "lastname": ContactService.contact.value.profile.lastName,
        "message": message,
        "screenshot": link,
        "hasScreenshot": true,
      });
    } else {
      docRef.update({
        "firstname": ContactService.contact.value.profile.firstName,
        "lastname": ContactService.contact.value.profile.lastName,
        "message": message,
        "hasScreenshot": false,
      });
    }
  }

  // # Helper: Uploads User Screenshot
  FutureOr<dynamic> _handleUploadScreenshot(Reference ref, String message) async {
    // Fetch Link
    String link = await ref.getDownloadURL();
    await _handlePostFeedback(message, link: link);
  }
}
