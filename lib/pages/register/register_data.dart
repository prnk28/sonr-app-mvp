import 'package:dots_indicator/dots_indicator.dart';
import 'package:sonr_app/style.dart';
import 'package:sonr_app/style/buttons/utility.dart';

import 'register_controller.dart';

enum InfoPanelType {
  Welcome,
  Universal,
  Secure,
  Start,
}

extension InfoPanelTypeUtils on InfoPanelType {
  /// Returns Total Panels
  int get total => InfoPanelType.values.length;

  /// Returns this Panels Index
  int get index => InfoPanelType.values.indexOf(this);

  /// Returns this InfoPanels page value
  double get page => this.index.toDouble();

  /// Return Next Info Panel
  InfoPanelType get next => InfoPanelType.values[this.index + 1];

  /// Return Previous Info Panel
  InfoPanelType get previous => InfoPanelType.values[this.index - 1];

  /// Checks if this Panel is Last Panel
  bool get isLast => this.index + 1 == this.total;

  /// Checks if this Panel is Last Panel
  bool get isNotLast => this.index + 1 != this.total;

  /// Returns this Panels Title as Heading Widget
  Widget title() {
    final color = SonrColor.White;
    switch (this) {
      case InfoPanelType.Welcome:
        return 'Welcome'.heading(color: color);
      case InfoPanelType.Universal:
        return 'Universal'.heading(color: color);
      case InfoPanelType.Secure:
        return 'Security First'.heading(color: color);
      case InfoPanelType.Start:
        return 'Get Started'.heading(color: color);
    }
  }

  /// Returns this Panels Description as Rich Text
  Widget description() {
    final color = SonrColor.White;
    final size = 20.0;
    switch (this) {
      case InfoPanelType.Welcome:
        return [
          'Sonr has '.paragraphSpan(fontSize: size, color: color),
          'NO '.lightSpan(fontSize: size, color: color),
          'File Size Limits. Works like Airdrop Nearby and like Email when nobody is around.'.paragraphSpan(
            fontSize: size,
            color: color,
          )
        ].rich();
      case InfoPanelType.Universal:
        return ['Runs Natively on iOS, Android, MacOS, Windows and Linux.'.paragraphSpan(fontSize: size, color: color)].rich();
      case InfoPanelType.Secure:
        return ['Completely Encrypted Communication. All data is verified and signed.'.paragraphSpan(fontSize: size, color: color)].rich();
      case InfoPanelType.Start:
        return ['Lets Continue by selecting your Sonr Name.'.paragraphSpan(fontSize: size, color: color)].rich();
    }
  }

  /// Builds Child for this Info Panel
  Widget footer() {
    // Build Dots
    if (this.isNotLast) {
      return Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              DotsIndicator(
                dotsCount: InfoPanelType.values.length,
                position: index.toDouble(),
                decorator: DotsDecorator(
                  size: const Size.square(8.0),
                  activeSize: const Size(16.0, 8.0),
                  activeShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: ActionButton(
                  onPressed: () {
                    Get.find<RegisterController>().nextPanel(this.next);
                  },
                  iconData: SonrIcons.Forward,
                ),
              )
            ],
          ));
    } else {
      return Container(
          padding: EdgeInsets.only(top: 36),
          alignment: Alignment.bottomCenter,
          child: ColorButton(
            decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(ButtonUtility.K_BORDER_RADIUS),
                border: Border.all(width: 2, color: Color(0xffE7E7E7))),
            onPressed: () {
              Get.find<RegisterController>().nextPage(RegisterPageType.Name);
            },
            pressedScale: 1.1,
            child: "Continue".heading(
              fontSize: 20,
              color: SonrColor.White,
            ),
          ));
    }
  }
}

enum NewSNameStatus {
  Default,
  Returning,
  TooShort,
  Available,
  Unavailable,
  Blocked,
  Restricted,
  DeviceRegistered,
  InvalidCharacters,
}

extension NewSNameStatusUtil on NewSNameStatus {
  /// Checks if NewSNameStatus is Valid
  bool get isValid {
    switch (this) {
      case NewSNameStatus.Available:
        return true;
      default:
        return false;
    }
  }

  /// Returns Icon for Status
  Widget icon() {
    final size = 28.0;
    switch (this) {
      case NewSNameStatus.Default:
        return SonrIcons.ATSign.icon(color: SonrTheme.itemColorInversed, size: size);
      case NewSNameStatus.Available:
        return SonrIcons.Check.icon(color: SonrColor.Tertiary, size: size);
      case NewSNameStatus.Returning:
        return SonrIcons.Zap.icon(color: SonrColor.Secondary, size: size);
      default:
        return SonrIcons.Alert.icon(color: SonrColor.AccentPink, size: size);
    }
  }

  /// Returns Label for Status
  Widget label() {
    final color = SonrTheme.greyColor;
    switch (this) {
      case NewSNameStatus.Default:
        return "Pick Name".light(color: color);
      case NewSNameStatus.Available:
        return "Available!".light(color: color);
      case NewSNameStatus.TooShort:
        return "Too Short".light(color: color);
      case NewSNameStatus.Unavailable:
        return "Unavailable".light(color: color);
      case NewSNameStatus.Blocked:
        return "Blocked".light(color: color);
      case NewSNameStatus.Restricted:
        return "Restricted".light(color: color);
      case NewSNameStatus.DeviceRegistered:
        return "Already Exists".light(color: color);
      case NewSNameStatus.Returning:
        return "Welcome Back!".light(color: color);
      case NewSNameStatus.InvalidCharacters:
        return "Only use a-z letters".light(color: color);
    }
  }

  /// Returns Gradient Data for Status
  Gradient get gradient {
    switch (this) {
      case NewSNameStatus.Default:
        return SonrGradient.Primary;
      case NewSNameStatus.Available:
        return SonrGradient.Tertiary;
      case NewSNameStatus.Returning:
        return SonrGradient.Secondary;
      default:
        return SonrGradient.Critical;
    }
  }
}

enum RegisterPageType {
  Intro,
  Name,
  Backup,
  Contact,
  Location,
  Gallery,
}

extension RegisterPageTypeUtils on RegisterPageType {
  /// Returns ValueKey for Type
  Key? get key => ValueKey<RegisterPageType>(this);

  /// Checks to Use Intro View
  bool get isIntro => this == RegisterPageType.Intro;

  /// Checks to Use Setup View
  bool get isSetup => this == RegisterPageType.Name || this == RegisterPageType.Backup || this == RegisterPageType.Contact;

  /// Checks to User Permissions View
  bool get isPermissions => this == RegisterPageType.Location || this == RegisterPageType.Gallery;

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
      return RegisterPageTypeUtils.permissionsPageTypes.indexOf(this) + 1 == RegisterPageTypeUtils.permissionsPageTypes.length;
    } else if (this.isSetup) {
      return RegisterPageTypeUtils.setupPageTypes.indexOf(this) + 1 == RegisterPageTypeUtils.setupPageTypes.length;
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
      ];

  /// Returns Permissions Button Text
  String permissionsButtonText() {
    final value = this.toString().substring(this.toString().indexOf(".") + 1);
    return isPermissions ? "Grant $value" : "";
  }

  /// Returns Function for Permissions Button
  Function permissionsButtonOnPressed() {
    if (isPermissions) {
      return this == RegisterPageType.Location ? Get.find<RegisterController>().requestLocation : Get.find<RegisterController>().requestGallery;
    } else {
      return print;
    }
  }

  /// Returns Image Path for Permissions
  String permissionsImagePath() {
    if (isPermissions) {
      return this == RegisterPageType.Location ? "assets/illustrations/LocationPerm.png" : "assets/illustrations/MediaPerm.png";
    } else {
      return "";
    }
  }
}
