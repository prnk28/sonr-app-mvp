import 'dart:io';
import 'package:share_plus/share_plus.dart';
import 'package:sonr_app/data/data.dart';
import 'package:sonr_app/data/services/services.dart';
import 'package:sonr_app/style/style.dart';
import 'package:bip39/bip39.dart' as bip39;
import 'models/intro.dart';
import 'models/type.dart';

class RegisterController extends GetxController {
  // Properties
  final nameStatus = NameStatus.Default.obs;
  final mnemonic = "".obs;
  final sName = "".obs;
  final firstName = "".obs;
  final lastName = "".obs;
  final status = Rx<RegisterPageType>(RegisterPageType.Intro);
  final auth = Rx<DNSRecord>(DNSRecord.blank());

  // Error Status
  final firstNameStatus = Rx<TextInputValidStatus>(TextInputValidStatus.None);
  final lastNameStatus = Rx<TextInputValidStatus>(TextInputValidStatus.None);
  final emailStatus = Rx<TextInputValidStatus>(TextInputValidStatus.None);

  // References
  late ValueNotifier<double> panelNotifier;
  late PageController introPageController;
  late PageController setupPageController;
  late PageController permissionsPageController;
  final ScrollController contactScrollController = ScrollController();

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

  /// #### Next Info Panel
  void nextPanel(IntroPageType type) {
    panelNotifier.value = type.page;
    introPageController.animateToPage(
      type.index,
      duration: 400.milliseconds,
      curve: Curves.easeIn,
    );
  }

  /// #### Next Page
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

  Future<void> setName() async {
    // Refresh Records
    final result = await Namebase.refresh();
    sName(sName.value.toLowerCase());

    // Validate
    if (await validateName()) {
      if (nameStatus.value != NameStatus.Returning) {
        // Check Valid
        if (result.isValidName(sName.value)) {
          // Generate Authentication
          var genMnemomic = bip39.generateMnemonic();
          var result = await signUser(sName.value, genMnemomic);
          ContactService.newAuth(genMnemomic, sName.value, result);

          // Update Status
          mnemonic(genMnemomic);
          nextPage(RegisterPageType.Backup);
        }
      } else {
        nextPage(RegisterPageType.Location);
      }
    }
  }

  /// #### Submits Contact
  setContact() async {
    // Get Contact from Values
    var contact = Contact(
        profile: Profile(
      firstName: firstName.value.capitalizeFirst,
      lastName: lastName.value.capitalizeFirst,
      sName: sName.value.toLowerCase(),
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
        lastName: DeviceService.device.platform.toString(),
      ));

      // Create User
      await ContactService.newContact(contact);

      // Connect to Network
      NodeService.to.connect();
      AppPage.Home.off(args: HomeArguments(isFirstLoad: true));
    }
  }

  /// #### Validates SName as Valid characters
  Future<bool> validateName() async {
    nameStatus(await Namebase.validateName(sName.value));
    return nameStatus.value.isValid;
  }

  /// #### Checks if Username matches device id and prefix from records
  static Future<bool> validateUser(String n, String mnemonic) async {
    var request = API.newVerifyText(original: mnemonic, signature: mnemonic);
    var response = await NodeService.verify(request);
    return response.success;
  }

  // Helper Method to Generate Prefix
  static Future<AuthResponse> signUser(String username, String mnemonic) async {
    // Create New Prefix
    var request = API.newSignature(username, mnemonic);
    var response = await NodeService.sign(request);
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
