import 'dart:io';
import 'package:share/share.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sonr_app/data/data.dart';
import 'package:sonr_app/env.dart';
import 'package:sonr_app/service/device/device.dart';
import 'package:sonr_app/service/device/mobile.dart';
import 'package:sonr_app/style.dart';
import 'package:bip39/bip39.dart' as bip39;

enum RegisterNameStatus { Default, Returning, TooShort, Available, Unavailable, Blocked, Restricted, DeviceRegistered }

extension RegisterNameStatusUtil on RegisterNameStatus {
  bool get isValid {
    switch (this) {
      case RegisterNameStatus.Available:
        return true;
      default:
        return false;
    }
  }
}

enum RegisterStatus { Name, Backup, Contact, Location, Gallery, Linker }

class RegisterController extends GetxController {
  // Properties
  final nameStatus = RegisterNameStatus.Default.obs;
  final mnemonic = "".obs;
  final sName = "".obs;
  final firstName = "".obs;
  final lastName = "".obs;
  final status = Rx<RegisterStatus>(RegisterStatus.Name);
  final auth = Rx<HSRecord>(HSRecord.blank());
  final result = Rx<NamebaseResult>(NamebaseResult.blank());

  // Error Status
  final firstNameStatus = Rx<TextInputValidStatus>(TextInputValidStatus.None);
  final lastNameStatus = Rx<TextInputValidStatus>(TextInputValidStatus.None);
  final emailStatus = Rx<TextInputValidStatus>(TextInputValidStatus.None);

  // References
  final _nbClient = NamebaseClient(hsKey: Env.hs_key, hsSecret: Env.hs_secret);

  // * Constructer * //
  onInit() {
    // Get Records
    refreshRecords();

    // Check Platform
    if (DeviceService.isDesktop) {
      status(RegisterStatus.Linker);
      status.refresh();
    }
    super.onInit();
  }

  void checkName(String name) {
    sName(name);
    validateName();
  }

  void exportCode() async {
    if (mnemonic.value != "") {
      final directory = await getApplicationDocumentsDirectory();
      final path = '${directory.path}/sonr_backup_code.txt';
      final File file = File(path);
      await file.writeAsString(mnemonic.value);
      Share.shareFiles([path], text: 'Sonr Backup Code');
    }
  }

  Future<void> setName() async {
    // Refresh Records
    refreshRecords();

    // Validate
    if (await validateName()) {
      if (nameStatus.value != RegisterNameStatus.Returning) {
        // Check Valid
        if (result.value.isValidName(sName.value)) {
          var genMnemomic = bip39.generateMnemonic();
          var result = await signUser(sName.value, genMnemomic);

          // Logging
          Logger.info(
              "Prefix: ${result.signedPrefix} \n Mnemonic: $genMnemomic \n Fingerprint: ${result.signedFingerprint} \n Identity: ${result.publicIdentity}");

          // Add UserRecord Domain
          await _nbClient.addRecord(
              HSRecord.newAuth(result.signedPrefix, sName.value, result.signedFingerprint), HSRecord.newName(sName.value, result.publicIdentity));

          // Analytics
          Logger.event(
            name: '[AuthService]: Create-Username',
            parameters: {
              'createdAt': DateTime.now().toString(),
              'platform': DeviceService.platform.toString(),
              'new-username': sName.value,
            },
          );

          // Update Status
          mnemonic(genMnemomic);
          status(RegisterStatus.Backup);
        }
      } else {
        status(RegisterStatus.Location);
      }
    }
  }

  void nextFromBackup() async {
    status(RegisterStatus.Contact);
  }

  /// @ Submits Contact
  setContact() async {
    if (validateContact()) {
      // Get Contact from Values
      var contact = Contact(
          profile: Profile(
        firstName: firstName.value,
        lastName: lastName.value,
        sName: sName.value,
      ));

      // Create User
      await UserService.newContact(contact);

      // Process data
      if (DeviceService.isMobile) {
        // Remove Textfield Focus
        FocusScopeNode currentFocus = FocusScope.of(Get.context!);
        if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
          FocusManager.instance.primaryFocus!.unfocus();
        }

        // Change Status
        status(RegisterStatus.Location);
      }
    }

    // Check Desktop
    if (DeviceService.isDesktop) {
      // Get Contact from Values
      var contact = Contact(
          profile: Profile(
        firstName: "Anonymous",
        lastName: DeviceService.platform.toString(),
      ));

      // Create User
      await UserService.newContact(contact);

      // Connect to Network
      SonrService.to.connect();
      AppPage.Home.off(args: HomePageArgs(isFirstLoad: true));
    }
  }

  /// @ Validates Fields
  bool validateContact() {
    // Check Valid
    bool firstNameValid = GetUtils.isAlphabetOnly(firstName.value);
    bool lastNameValid = GetUtils.isAlphabetOnly(lastName.value);

    // Update Reactive Properties
    firstNameStatus(TextInputValidStatusUtils.fromValidBool(firstNameValid));
    lastNameStatus(TextInputValidStatusUtils.fromValidBool(lastNameValid));

    // Return Result
    return firstNameValid && lastNameValid;
  }

  Future<bool> validateName() async {
    // Update Status
    if (sName.value.length > 3 && !sName.value.contains(" ")) {
      // Check Available
      if (result.value.checkName(
        NameCheckType.Unavailable,
        sName.value,
      )) {
        nameStatus(RegisterNameStatus.Unavailable);
        return false;
      }
      // Check Unblocked
      else if (result.value.checkName(
        NameCheckType.Blocked,
        sName.value,
      )) {
        nameStatus(RegisterNameStatus.Blocked);
        return false;
      }
      // Check Unrestricted
      else if (result.value.checkName(
        NameCheckType.Restricted,
        sName.value,
      )) {
        nameStatus(RegisterNameStatus.Restricted);
        return false;
      }
      // Check Valid
      else {
        // Update Values
        nameStatus(RegisterNameStatus.Available);
        return true;
      }
    } else {
      nameStatus(RegisterNameStatus.TooShort);
      return false;
    }
  }

  /// @ Request Location Permissions
  Future<bool> requestLocation() async {
    if (await Permission.location.request().isGranted) {
      Get.find<MobileService>().updatePermissionsStatus();
      status(RegisterStatus.Gallery);
      return true;
    } else {
      Get.find<MobileService>().updatePermissionsStatus();
      return false;
    }
  }

  /// @ Request Gallery Permissions
  Future<bool> requestGallery() async {
    if (DeviceService.isAndroid) {
      if (await Permission.storage.request().isGranted) {
        Get.find<MobileService>().updatePermissionsStatus();
        AppPage.Home.off(args: HomePageArgs(isFirstLoad: true));
        return true;
      } else {
        Get.find<MobileService>().updatePermissionsStatus();
        return false;
      }
    } else {
      if (await Permission.photos.request().isGranted) {
        Get.find<MobileService>().updatePermissionsStatus();
        AppPage.Home.off(args: HomePageArgs(isFirstLoad: true));
        return true;
      } else {
        Get.find<MobileService>().updatePermissionsStatus();
        return false;
      }
    }
  }

  /// #### Refreshes Record Table from Namebase Client
  Future<void> refreshRecords() async {
    // Set Data From Response
    var data = await _nbClient.refresh();
    if (data.success) {
      result(data);
      result.refresh();
    }
  }

  /// #### Checks if Username matches device id and prefix from records
  static Future<bool> validateUser(String n, String mnemonic) async {
    var request = Request.newVerifyText(original: mnemonic, signature: mnemonic);
    var response = await SonrService.verify(request);
    return response.isVerified;
  }

  // Helper Method to Generate Prefix
  static Future<SignResponse> signUser(String username, String mnemonic) async {
    // Create New Prefix
    var request = Request.newSignature(username, mnemonic);
    var response = await SonrService.sign(request);
    Logger.info(response.toString());

    // Check Result
    return response;
  }
}
