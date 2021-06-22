import 'dart:io';
import 'package:share/share.dart';
import 'package:sonr_app/data/data.dart';
import 'package:sonr_app/env.dart';
import 'package:sonr_app/pages/home/home_controller.dart';
import 'package:sonr_app/data/services/services.dart';
import 'package:sonr_app/style.dart';
import 'package:bip39/bip39.dart' as bip39;
import 'models/info.dart';
import 'models/status.dart';
import 'models/type.dart';

class RegisterController extends GetxController {
  // Properties
  final nameStatus = NewSNameStatus.Default.obs;
  final mnemonic = "".obs;
  final sName = "".obs;
  final firstName = "".obs;
  final lastName = "".obs;
  final status = Rx<RegisterPageType>(RegisterPageType.Intro);
  final auth = Rx<HSRecord>(HSRecord.blank());
  final result = Rx<NamebaseResult>(NamebaseResult.blank());

  // Error Status
  final firstNameStatus = Rx<TextInputValidStatus>(TextInputValidStatus.None);
  final lastNameStatus = Rx<TextInputValidStatus>(TextInputValidStatus.None);
  final emailStatus = Rx<TextInputValidStatus>(TextInputValidStatus.None);

  // References
  final _nbClient = NamebaseClient(hsKey: Env.hs_key, hsSecret: Env.hs_secret);
  late ValueNotifier<double> panelNotifier;
  late PageController introPageController;
  late PageController setupPageController;
  late PageController permissionsPageController;

  // * Constructer * //
  @override
  onInit() {
    // Initialize Intro View
    panelNotifier = ValueNotifier<double>(0);
    introPageController = PageController(
      initialPage: 0,
      viewportFraction: 0.9,
    )..addListener(_onPanelScroll);

    // Initialize Setup View
    setupPageController = PageController(
      initialPage: 0,
      viewportFraction: 1.0,
    );

    // Initialize Permissions View
    permissionsPageController = PageController(
      initialPage: 0,
      viewportFraction: 1.0,
    );

    // Get Records
    refreshRecords();
    super.onInit();
  }

  double checkName(String name) {
    sName(name);
    validateName();
    final size = name.size(DisplayTextStyle.Paragraph, fontSize: 24);
    return size.width;
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
      if (nameStatus.value != NewSNameStatus.Returning) {
        // Check Valid
        if (result.value.isValidName(sName.value)) {
          var genMnemomic = bip39.generateMnemonic();
          var result = await signUser(sName.value, genMnemomic);

          // Logging
          Logger.info(
            "Prefix: ${result.signedPrefix} \n Mnemonic: $genMnemomic \n Fingerprint: ${result.signedFingerprint} \n Identity: ${result.publicIdentity}",
          );

          // Add UserRecord Domain
          await _nbClient.addRecord(
              HSRecord.newAuth(result.signedPrefix, sName.value, result.signedFingerprint), HSRecord.newName(sName.value, result.publicIdentity));

          // Analytics
          Logger.event(
            name: 'createUsername',
            controller: 'RegisterController',
            parameters: {
              'username': sName.value,
            },
          );

          // Update Status
          mnemonic(genMnemomic);
          nextPage(RegisterPageType.Backup);
        }
      } else {
        nextPage(RegisterPageType.Location);
      }
    }
  }

  /// @ Next Info Panel
  void nextPanel(InfoPanelType type) {
    panelNotifier.value = type.page;
    introPageController.animateToPage(
      type.index,
      duration: 400.milliseconds,
      curve: Curves.easeIn,
    );
  }

  /// @ Next Page
  void nextPage(RegisterPageType type) {
    status(type);
    status.refresh();

    // Setup Page
    if (type.isSetup) {
      // Validate Not Last
      if (!type.isFirst) {
        setupPageController.animateToPage(
          type.indexGroup,
          duration: 400.milliseconds,
          curve: Curves.easeIn,
        );
      }
    }

    // Permissions Page
    if (type.isPermissions) {
      // Validate Not Last
      if (!type.isFirst) {
        permissionsPageController.animateToPage(
          type.indexGroup,
          duration: 400.milliseconds,
          curve: Curves.easeIn,
        );
      }
    }
  }

  /// @ Submits Contact
  setContact() async {
    // Get Contact from Values
    var contact = Contact(
        profile: Profile(
      firstName: firstName.value,
      lastName: lastName.value,
      sName: sName.value,
    ));

    // Create User
    await ContactService.newContact(contact);

    // Process data
    if (DeviceService.isMobile) {
      // Remove Textfield Focus
      FocusScopeNode currentFocus = FocusScope.of(Get.context!);
      if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
        FocusManager.instance.primaryFocus!.unfocus();
      }

      // Change Status
      nextPage(RegisterPageType.Location);
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
      await ContactService.newContact(contact);

      // Connect to Network
      Sonr.to.connect();
      AppPage.Home.off(args: HomeArguments(isFirstLoad: true));
    }
  }

  /// @ Validates SName as Valid characters
  Future<bool> validateName() async {
    // Check Alphabet Only
    if (!sName.value.isAlphabetOnly) {
      nameStatus(NewSNameStatus.InvalidCharacters);
      return false;
    } else {
      // Update Status
      if (sName.value.length > 3) {
        // Check Available
        if (result.value.checkName(
          NameCheckType.Unavailable,
          sName.value,
        )) {
          nameStatus(NewSNameStatus.Unavailable);
          return false;
        }
        // Check Unblocked
        else if (result.value.checkName(
          NameCheckType.Blocked,
          sName.value,
        )) {
          nameStatus(NewSNameStatus.Blocked);
          return false;
        }
        // Check Unrestricted
        else if (result.value.checkName(
          NameCheckType.Restricted,
          sName.value,
        )) {
          nameStatus(NewSNameStatus.Restricted);
          return false;
        }
        // Check Valid
        else {
          // Update Values
          nameStatus(NewSNameStatus.Available);
          return true;
        }
      } else {
        nameStatus(NewSNameStatus.TooShort);
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
    var response = await Sonr.verify(request);
    return response.isVerified;
  }

  // Helper Method to Generate Prefix
  static Future<AuthResponse> signUser(String username, String mnemonic) async {
    // Create New Prefix
    var request = Request.newSignature(username, mnemonic);
    var response = await Sonr.sign(request);
    Logger.info(response.toString());

    // Check Result
    return response;
  }

  // @ Helper: Handle Scroll
  void _onPanelScroll() {
    if (introPageController.page!.toInt() == introPageController.page) {}
    panelNotifier.value = introPageController.page!.toDouble();
  }
}
