import 'icons.dart';

enum SelfCareIcons {
  /// ### [Uni_icons: SelfCare] - Cream
  /// !["Icon of Cream"](/Users/prad/Sonr/tools/icons/assets/solid/SelfCare/cream.svg)
  Cream,

  /// ### [Uni_icons: SelfCare] - Bubbles
  /// !["Icon of Bubbles"](/Users/prad/Sonr/tools/icons/assets/solid/SelfCare/bubbles.svg)
  Bubbles,

  /// ### [Uni_icons: SelfCare] - Dispenser
  /// !["Icon of Dispenser"](/Users/prad/Sonr/tools/icons/assets/solid/SelfCare/dispenser.svg)
  Dispenser,

  /// ### [Uni_icons: SelfCare] - Brush
  /// !["Icon of Brush"](/Users/prad/Sonr/tools/icons/assets/solid/SelfCare/brush.svg)
  Brush,

  /// ### [Uni_icons: SelfCare] - Eyedropper
  /// !["Icon of Eyedropper"](/Users/prad/Sonr/tools/icons/assets/solid/SelfCare/eyedropper.svg)
  Eyedropper,

  /// ### [Uni_icons: SelfCare] - Flacon
  /// !["Icon of Flacon"](/Users/prad/Sonr/tools/icons/assets/solid/SelfCare/flacon.svg)
  Flacon,

  /// ### [Uni_icons: SelfCare] - HairDryer
  /// !["Icon of HairDryer"](/Users/prad/Sonr/tools/icons/assets/solid/SelfCare/hair-dryer.svg)
  HairDryer,

  /// ### [Uni_icons: SelfCare] - Hairbrush
  /// !["Icon of Hairbrush"](/Users/prad/Sonr/tools/icons/assets/solid/SelfCare/hairbrush.svg)
  Hairbrush,

  /// ### [Uni_icons: SelfCare] - Lipstick
  /// !["Icon of Lipstick"](/Users/prad/Sonr/tools/icons/assets/solid/SelfCare/lipstick.svg)
  Lipstick,

  /// ### [Uni_icons: SelfCare] - Mirror
  /// !["Icon of Mirror"](/Users/prad/Sonr/tools/icons/assets/solid/SelfCare/mirror.svg)
  Mirror,

  /// ### [Uni_icons: SelfCare] - Mascara
  /// !["Icon of Mascara"](/Users/prad/Sonr/tools/icons/assets/solid/SelfCare/mascara.svg)
  Mascara,

  /// ### [Uni_icons: SelfCare] - NailPolish
  /// !["Icon of NailPolish"](/Users/prad/Sonr/tools/icons/assets/solid/SelfCare/nail-polish.svg)
  NailPolish,

  /// ### [Uni_icons: SelfCare] - Palette
  /// !["Icon of Palette"](/Users/prad/Sonr/tools/icons/assets/solid/SelfCare/palette.svg)
  Palette,

  /// ### [Uni_icons: SelfCare] - Perfume
  /// !["Icon of Perfume"](/Users/prad/Sonr/tools/icons/assets/solid/SelfCare/perfume.svg)
  Perfume,

  /// ### [Uni_icons: SelfCare] - Razor
  /// !["Icon of Razor"](/Users/prad/Sonr/tools/icons/assets/solid/SelfCare/razor.svg)
  Razor,

  /// ### [Uni_icons: SelfCare] - Scissors
  /// !["Icon of Scissors"](/Users/prad/Sonr/tools/icons/assets/solid/SelfCare/scissors.svg)
  Scissors,

  /// ### [Uni_icons: SelfCare] - Shower
  /// !["Icon of Shower"](/Users/prad/Sonr/tools/icons/assets/solid/SelfCare/shower.svg)
  Shower,
}

extension SelfCareUtils on SelfCareIcons {
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
