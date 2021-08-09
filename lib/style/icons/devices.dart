import 'icons.dart';

enum DeviceIcons {
  /// ### [Uni_icons: Devices] - BatteryEmpty
  /// !["Icon of BatteryEmpty"](/Users/prad/Sonr/tools/icons/assets/solid/Devices/battery-empty.svg)
  BatteryEmpty,

  /// ### [Uni_icons: Devices] - BatteryHalf
  /// !["Icon of BatteryHalf"](/Users/prad/Sonr/tools/icons/assets/solid/Devices/battery-half.svg)
  BatteryHalf,

  /// ### [Uni_icons: Devices] - BatteryLow
  /// !["Icon of BatteryLow"](/Users/prad/Sonr/tools/icons/assets/solid/Devices/battery-low.svg)
  BatteryLow,

  /// ### [Uni_icons: Devices] - Bluetooth
  /// !["Icon of Bluetooth"](/Users/prad/Sonr/tools/icons/assets/solid/Devices/bluetooth.svg)
  Bluetooth,

  /// ### [Uni_icons: Devices] - ComputerMouse
  /// !["Icon of ComputerMouse"](/Users/prad/Sonr/tools/icons/assets/solid/Devices/computer-mouse.svg)
  ComputerMouse,

  /// ### [Uni_icons: Devices] - Controller
  /// !["Icon of Controller"](/Users/prad/Sonr/tools/icons/assets/solid/Devices/controller.svg)
  Controller,

  /// ### [Uni_icons: Devices] - BatteryFull
  /// !["Icon of BatteryFull"](/Users/prad/Sonr/tools/icons/assets/solid/Devices/battery-full.svg)
  BatteryFull,

  /// ### [Uni_icons: Devices] - Earphones
  /// !["Icon of Earphones"](/Users/prad/Sonr/tools/icons/assets/solid/Devices/earphones.svg)
  Earphones,

  /// ### [Uni_icons: Devices] - ElectricalPlug
  /// !["Icon of ElectricalPlug"](/Users/prad/Sonr/tools/icons/assets/solid/Devices/electrical-plug.svg)
  ElectricalPlug,

  /// ### [Uni_icons: Devices] - Camera
  /// !["Icon of Camera"](/Users/prad/Sonr/tools/icons/assets/solid/Devices/camera.svg)
  Camera,

  /// ### [Uni_icons: Devices] - Keyboard
  /// !["Icon of Keyboard"](/Users/prad/Sonr/tools/icons/assets/solid/Devices/keyboard.svg)
  Keyboard,

  /// ### [Uni_icons: Devices] - FlashDrive
  /// !["Icon of FlashDrive"](/Users/prad/Sonr/tools/icons/assets/solid/Devices/flash-drive.svg)
  FlashDrive,

  /// ### [Uni_icons: Devices] - Laptop
  /// !["Icon of Laptop"](/Users/prad/Sonr/tools/icons/assets/solid/Devices/laptop.svg)
  Laptop,

  /// ### [Uni_icons: Devices] - LightBulb
  /// !["Icon of LightBulb"](/Users/prad/Sonr/tools/icons/assets/solid/Devices/light-bulb.svg)
  LightBulb,

  /// ### [Uni_icons: Devices] - Lightning
  /// !["Icon of Lightning"](/Users/prad/Sonr/tools/icons/assets/solid/Devices/lightning.svg)
  Lightning,

  /// ### [Uni_icons: Devices] - Microchip
  /// !["Icon of Microchip"](/Users/prad/Sonr/tools/icons/assets/solid/Devices/microchip.svg)
  Microchip,

  /// ### [Uni_icons: Devices] - MobileOne
  /// !["Icon of MobileOne"](/Users/prad/Sonr/tools/icons/assets/solid/Devices/mobile-01.svg)
  MobileOne,
}

extension DevicesUtils on DeviceIcons {
  /// Returns Raw Type of Enum
  String get type => this.toString().substring(0, this.toString().indexOf('.'));

  /// Returns Directory of Category
  String get category => this.type.replaceAll('Icons', '');

  /// Returns Raw Value of Enum Type
  String get value => this.toString().substring(this.toString().indexOf('.') + 1);

  /// Returns this Icons File Name
  String get fileName {
    // Set Base Path
    var path = '';

    // Iterate Words
    bool isFirst = true;
    for (var word in this.pascalWords) {
      // Verify Value
      if (word != null) {
        // Check if first element
        if (isFirst) {
          path += cleanWord(word);
          isFirst = false;
        }
        // Add Hyphen for consecutive words
        else {
          path += "-${cleanWord(word)}";
        }
      }
    }

    return path;
  }

  /// Returns Path for this Icon by Fill
  String path(IconFill fill) {
    return 'assets/icons/${category}/${this.fileName}@${fill.name}.svg';
  }

  /// ## (SVG) ChartIcons:DuoTone
  /// Returns SVGPicture Widget, contains all Default properties for SVGPicture package.
  SvgPicture duoTone({
    Key? key,
    double? width,
    double? height,
    Color? color,
    BoxFit fit = BoxFit.contain,
    AlignmentGeometry alignment = Alignment.center,
    Clip clipBehavior = Clip.hardEdge,
  }) {
    return SvgPicture.asset(
      this.path(IconFill.DuoTone),
      color: Get.isDarkMode ? Color(0xffC2C2C2) : null,
      bundle: rootBundle,
      key: key,
      clipBehavior: clipBehavior,
      fit: fit,
      width: width,
      height: height,
      colorBlendMode: BlendMode.overlay,
      alignment: alignment,
    );
  }

  /// ## (SVG) ChartIcons:Line
  /// Returns SVGPicture Widget, contains all Default properties for SVGPicture package.
  SvgPicture line({
    Key? key,
    double? width,
    double? height,
    BoxFit fit = BoxFit.contain,
    AlignmentGeometry alignment = Alignment.center,
    Color? color,
    Clip clipBehavior = Clip.hardEdge,
  }) {
    return SvgPicture.asset(
      this.path(IconFill.Line),
      color: Get.isDarkMode ? Color(0xffC2C2C2) : null,
      bundle: rootBundle,
      key: key,
      clipBehavior: clipBehavior,
      fit: fit,
      width: width,
      height: height,
      alignment: alignment,
    );
  }

  /// ## (SVG) ChartIcons:Solid
  /// Returns SVGPicture Widget, contains all Default properties for SVGPicture package.
  SvgPicture solid({
    Key? key,
    double? width,
    double? height,
    BoxFit fit = BoxFit.contain,
    AlignmentGeometry alignment = Alignment.center,
    Color? color,
    Clip clipBehavior = Clip.hardEdge,
  }) {
    return SvgPicture.asset(
      this.path(IconFill.Solid),
      color: Get.isDarkMode ? Color(0xffC2C2C2) : null,
      bundle: rootBundle,
      key: key,
      clipBehavior: clipBehavior,
      fit: fit,
      width: width,
      height: height,
      alignment: alignment,
    );
  }

  /// Get All pascal words in Enum Value
  List<String?> get pascalWords => K_PASCAL_REGEX.allMatches(this.value).map((m) => m[0]).toList();

  /// #### Constant Regex Expression for Fuzzy Path
  static final K_PASCAL_REGEX = RegExp(r"(?:[A-Z]+|^)[a-z]*");
}
