import 'package:sonr_app/pages/register/register_controller.dart';
import 'package:sonr_app/style/style.dart';

enum RegisterPageType {
  Intro,
  Name,
  Backup,
  Contact,
  Location,
  Gallery,
  Notifications,
}

extension RegisterPageTypeUtils on RegisterPageType {
  /// Returns ValueKey for Type
  Key? get key => ValueKey<RegisterPageType>(this);

  /// Checks to Use Intro View
  bool get isIntro => this == RegisterPageType.Intro;

  /// Checks to Use Setup View
  bool get isSetup => this == RegisterPageType.Name || this == RegisterPageType.Backup || this == RegisterPageType.Contact;

  /// Checks to User Permissions View
  bool get isPermissions => this == RegisterPageType.Location || this == RegisterPageType.Gallery || this == RegisterPageType.Notifications;

  /// Checks if Page is First in Grouped List
  bool get isFirst {
    if (this.isPermissions) {
      return RegisterPageTypeUtils.permissionsPageTypes.indexOf(this) == 0;
    } else if (this.isSetup) {
      return RegisterPageTypeUtils.setupPageTypes.indexOf(this) == 0;
    }
    return false;
  }

  /// Checks if Page is First in Grouped List
  bool get isLast {
    if (this.isPermissions) {
      return RegisterPageTypeUtils.permissionsPageTypes.indexOf(this) + 1 == 3;
    } else if (this.isSetup) {
      return RegisterPageTypeUtils.setupPageTypes.indexOf(this) + 1 == 3;
    }
    return false;
  }

  /// Return Index of this Page
  int get index => RegisterPageType.values.indexOf(this);

  /// Return Index Within Group
  int get indexGroup {
    if (this.isPermissions) {
      return RegisterPageTypeUtils.permissionsPageTypes.indexOf(this);
    } else if (this.isSetup) {
      return RegisterPageTypeUtils.setupPageTypes.indexOf(this);
    }
    return -1;
  }

  /// Returns Intro Pages
  static List<RegisterPageType> get introPageTypes => [RegisterPageType.Intro];

  /// Returns Setup Pages
  static List<RegisterPageType> get setupPageTypes => [
        RegisterPageType.Name,
        RegisterPageType.Backup,
        RegisterPageType.Contact,
      ];

  /// Returns Permissions Pages
  static List<RegisterPageType> get permissionsPageTypes => [
        RegisterPageType.Location,
        RegisterPageType.Gallery,
        RegisterPageType.Notifications,
      ];

  /// Returns Left Button for Setup Page
  Widget leftButton() {
    if (this == RegisterPageType.Backup) {
      return ColorButton.neutral(onPressed: Get.find<RegisterController>().exportCode, text: "Save");
    } else if (this == RegisterPageType.Contact) {
      return ColorButton.neutral(onPressed: () => Get.find<RegisterController>().nextPage(RegisterPageType.Location), text: "Later");
    } else {
      return Container();
    }
  }

  /// Returns Right Button for Setup Page
  Widget rightButton() {
    if (this == RegisterPageType.Backup) {
      return ColorButton.primary(onPressed: () => Get.find<RegisterController>().nextPage(RegisterPageType.Contact), text: "Next");
    } else if (this == RegisterPageType.Contact) {
      return ColorButton.primary(onPressed: () => Get.find<RegisterController>().nextPage(RegisterPageType.Location), text: "Confirm");
    } else {
      return Container();
    }
  }

  /// Returns Permissions Button Text
  String permissionsButtonText() {
    final value = this.toString().substring(this.toString().indexOf(".") + 1);
    return isPermissions ? "Grant $value" : "";
  }

  /// Returns Button Text Color for Permissions
  Color permissionsButtonColor() {
    if (this.indexGroup == 0) {
      return AppColor.Black;
    }
    return AppColor.White;
  }

  /// Returns Image Path for Permissions
  String permissionsImagePath() {
    if (isPermissions) {
      if (this == RegisterPageType.Location) {
        return "assets/images/illustrations/LocationPerm.png";
      } else if (this == RegisterPageType.Gallery) {
        return "assets/images/illustrations/MediaPerm.png";
      } else {
        return "assets/images/illustrations/NotificationsPerm.png";
      }
    } else {
      return "";
    }
  }

  /// Returns Checks for Title Bar Gradient Text
  bool get isGradient => this == RegisterPageType.Name;

  /// Returns Setup Title
  String get title {
    switch (this) {
      case RegisterPageType.Name:
        return "SName";
      case RegisterPageType.Backup:
        return "Backup Code";
      case RegisterPageType.Contact:
        return "Profile";
      default:
        return "";
    }
  }

  /// Returns Setup Instruction
  String get instruction {
    switch (this) {
      case RegisterPageType.Name:
        return "Choose Your";
      case RegisterPageType.Backup:
        return "Secure Your";
      case RegisterPageType.Contact:
        return "Edit Your";
      default:
        return "";
    }
  }
}
