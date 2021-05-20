import 'dart:io';
import 'package:share/share.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sonr_app/data/data.dart';
import 'package:sonr_app/service/device/device.dart';
import 'package:sonr_app/service/device/mobile.dart';
import 'package:sonr_app/style/style.dart';

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

enum RegisterStatus { Name, Backup, Contact, Location, Gallery }

class RegisterController extends GetxController {
  // Properties
  final nameStatus = RegisterNameStatus.Default.obs;
  final mnemonic = "".obs;
  final sonrName = "".obs;
  final firstName = "".obs;
  final lastName = "".obs;
  final status = Rx<RegisterStatus>(RegisterStatus.Name);

  // Error Status
  final firstNameStatus = Rx<TextInputValidStatus>(TextInputValidStatus.None);
  final lastNameStatus = Rx<TextInputValidStatus>(TextInputValidStatus.None);
  final emailStatus = Rx<TextInputValidStatus>(TextInputValidStatus.None);

  // * Constructer * //
  onInit() {
    super.onInit();
  }

  void checkName(String name) {
    sonrName(name);
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

  void setName() async {
    // Refresh Records
    UserService.to.refreshRecords();

    // Validate
    if (validateName()) {
      if (nameStatus.value != RegisterNameStatus.Returning) {
        // Create User Data
        var data = await UserService.to.createUser(sonrName.value);
        mnemonic(data.item1);

        // Add New User
        var result = await UserService.to.addUserRecord(sonrName.value);

        if (result) {
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
        username: sonrName.value,
      ));

      // Remove Textfield Focus
      FocusScopeNode currentFocus = FocusScope.of(Get.context!);
      if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
        FocusManager.instance.primaryFocus!.unfocus();
      }

      // Process data.
      await UserService.saveUser(contact);
      status(RegisterStatus.Location);
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

  bool validateName() {
    // Update Status
    if (sonrName.value.length > 3) {
      // Check Available
      if (!UserService.to.isNameAvailable(sonrName.value)) {
        if (UserService.to.checkUser(sonrName.value)) {
          setReturningUser();
          nameStatus(RegisterNameStatus.Returning);
          return true;
        } else {
          nameStatus(RegisterNameStatus.Unavailable);
          return false;
        }
      }
      // Check Unblocked
      else if (!UserService.to.isNameUnblocked(sonrName.value)) {
        nameStatus(RegisterNameStatus.Blocked);
        return false;
      }
      // Check Unrestricted
      else if (!UserService.to.isNameUnrestricted(sonrName.value)) {
        nameStatus(RegisterNameStatus.Restricted);
        return false;
      }
      // Check Unregisted Device
      else if (!UserService.to.isPrefixAvailable(sonrName.value)) {
        nameStatus(RegisterNameStatus.DeviceRegistered);
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

  /// @ Sets for Returning User
  void setReturningUser() async {
    await UserService.to.returningUser(sonrName.value);
  }

  /// @ Request Location Permissions
  Future<bool> requestLocation() async {
    if (await Permission.locationWhenInUse.request().isGranted) {
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
        await Get.offNamed("/home", arguments: HomeArguments(isFirstLoad: true));
        return true;
      } else {
        Get.find<MobileService>().updatePermissionsStatus();
        return false;
      }
    } else {
      if (await Permission.photos.request().isGranted) {
        Get.find<MobileService>().updatePermissionsStatus();
        await Get.offNamed("/home", arguments: HomeArguments(isFirstLoad: true));
        return true;
      } else {
        Get.find<MobileService>().updatePermissionsStatus();
        return false;
      }
    }
  }
}
