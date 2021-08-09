import 'icons.dart';

enum NavigationIcons {
  /// ### [Uni_icons: Navigation] - Campsite
  /// !["Icon of Campsite"](/Users/prad/Sonr/tools/icons/assets/solid/Navigation/campsite.svg)
  Campsite,

  /// ### [Uni_icons: Navigation] - Globe
  /// !["Icon of Globe"](/Users/prad/Sonr/tools/icons/assets/solid/Navigation/globe.svg)
  Globe,

  /// ### [Uni_icons: Navigation] - Flag
  /// !["Icon of Flag"](/Users/prad/Sonr/tools/icons/assets/solid/Navigation/flag.svg)
  Flag,

  /// ### [Uni_icons: Navigation] - Gps
  /// !["Icon of Gps"](/Users/prad/Sonr/tools/icons/assets/solid/Navigation/gps.svg)
  Gps,

  /// ### [Uni_icons: Navigation] - LocationAddIn
  /// !["Icon of LocationAddIn"](/Users/prad/Sonr/tools/icons/assets/solid/Navigation/location-add-in-lc.svg)
  LocationAddIn,

  /// ### [Uni_icons: Navigation] - LocationAddOut
  /// !["Icon of LocationAddOut"](/Users/prad/Sonr/tools/icons/assets/solid/Navigation/location-add-ou-lc.svg)
  LocationAddOut,

  /// ### [Uni_icons: Navigation] - LocationArrowOff
  /// !["Icon of LocationArrowOff"](/Users/prad/Sonr/tools/icons/assets/solid/Navigation/location-arrow-off.svg)
  LocationArrowOff,

  /// ### [Uni_icons: Navigation] - LocationArrow
  /// !["Icon of LocationArrow"](/Users/prad/Sonr/tools/icons/assets/solid/Navigation/location-arrow.svg)
  LocationArrow,

  /// ### [Uni_icons: Navigation] - LocationCheckIn
  /// !["Icon of LocationCheckIn"](/Users/prad/Sonr/tools/icons/assets/solid/Navigation/location-check-in-lc.svg)
  LocationCheckIn,

  /// ### [Uni_icons: Navigation] - LocationCheckOut
  /// !["Icon of LocationCheckOut"](/Users/prad/Sonr/tools/icons/assets/solid/Navigation/location-check-ou-lc.svg)
  LocationCheckOut,

  /// ### [Uni_icons: Navigation] - LocationDownloadIn
  /// !["Icon of LocationDownloadIn"](/Users/prad/Sonr/tools/icons/assets/solid/Navigation/location-download-in-lc.svg)
  LocationDownloadIn,

  /// ### [Uni_icons: Navigation] - LocationDownloadOut
  /// !["Icon of LocationDownloadOut"](/Users/prad/Sonr/tools/icons/assets/solid/Navigation/location-download-ou-lc.svg)
  LocationDownloadOut,

  /// ### [Uni_icons: Navigation] - LocationEditIn
  /// !["Icon of LocationEditIn"](/Users/prad/Sonr/tools/icons/assets/solid/Navigation/location-edit-in-lc.svg)
  LocationEditIn,

  /// ### [Uni_icons: Navigation] - LocationEditOut
  /// !["Icon of LocationEditOut"](/Users/prad/Sonr/tools/icons/assets/solid/Navigation/location-edit-ou-lc.svg)
  LocationEditOut,

  /// ### [Uni_icons: Navigation] - LocationExclamationMarkIn
  /// !["Icon of LocationExclamationMarkIn"](/Users/prad/Sonr/tools/icons/assets/solid/Navigation/location-exclamation-mark-in-lc.svg)
  LocationExclamationMarkIn,

  /// ### [Uni_icons: Navigation] - LocationExportIn
  /// !["Icon of LocationExportIn"](/Users/prad/Sonr/tools/icons/assets/solid/Navigation/location-export-in-lc.svg)
  LocationExportIn,

  /// ### [Uni_icons: Navigation] - LocationExportOut
  /// !["Icon of LocationExportOut"](/Users/prad/Sonr/tools/icons/assets/solid/Navigation/location-export-ou-lc.svg)
  LocationExportOut,
}

extension NavigationUtils on NavigationIcons {
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
