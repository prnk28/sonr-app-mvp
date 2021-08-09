import 'icons.dart';

enum DateTimeIcons {
  /// ### [Uni_icons: DateTime] - AlarmCheckIn
  /// !["Icon of AlarmCheckIn"](/Users/prad/Sonr/tools/icons/assets/solid/DateTime/alarm-check-in-lc.svg)
  AlarmCheckIn,

  /// ### [Uni_icons: DateTime] - AlarmAddOut
  /// !["Icon of AlarmAddOut"](/Users/prad/Sonr/tools/icons/assets/solid/DateTime/alarm-add-ou-lc.svg)
  AlarmAddOut,

  /// ### [Uni_icons: DateTime] - AlarmCheckOut
  /// !["Icon of AlarmCheckOut"](/Users/prad/Sonr/tools/icons/assets/solid/DateTime/alarm-check-ou-lc.svg)
  AlarmCheckOut,

  /// ### [Uni_icons: DateTime] - AlarmDownloadIn
  /// !["Icon of AlarmDownloadIn"](/Users/prad/Sonr/tools/icons/assets/solid/DateTime/alarm-download-in-lc.svg)
  AlarmDownloadIn,

  /// ### [Uni_icons: DateTime] - AlarmDownloadOut
  /// !["Icon of AlarmDownloadOut"](/Users/prad/Sonr/tools/icons/assets/solid/DateTime/alarm-download-ou-lc.svg)
  AlarmDownloadOut,

  /// ### [Uni_icons: DateTime] - AlarmEditIn
  /// !["Icon of AlarmEditIn"](/Users/prad/Sonr/tools/icons/assets/solid/DateTime/alarm-edit-in-lc.svg)
  AlarmEditIn,

  /// ### [Uni_icons: DateTime] - AlarmEditOut
  /// !["Icon of AlarmEditOut"](/Users/prad/Sonr/tools/icons/assets/solid/DateTime/alarm-edit-ou-lc.svg)
  AlarmEditOut,

  /// ### [Uni_icons: DateTime] - AlarmExportOut
  /// !["Icon of AlarmExportOut"](/Users/prad/Sonr/tools/icons/assets/solid/DateTime/alarm-export-ou-lc.svg)
  AlarmExportOut,

  /// ### [Uni_icons: DateTime] - AlarmFavouriteIn
  /// !["Icon of AlarmFavouriteIn"](/Users/prad/Sonr/tools/icons/assets/solid/DateTime/alarm-favourite-in-lc.svg)
  AlarmFavouriteIn,

  /// ### [Uni_icons: DateTime] - AlarmFavouriteOut
  /// !["Icon of AlarmFavouriteOut"](/Users/prad/Sonr/tools/icons/assets/solid/DateTime/alarm-favourite-ou-lc.svg)
  AlarmFavouriteOut,

  /// ### [Uni_icons: DateTime] - AlarmImportIn
  /// !["Icon of AlarmImportIn"](/Users/prad/Sonr/tools/icons/assets/solid/DateTime/alarm-import-in-lc.svg)
  AlarmImportIn,

  /// ### [Uni_icons: DateTime] - AlarmLockedIn
  /// !["Icon of AlarmLockedIn"](/Users/prad/Sonr/tools/icons/assets/solid/DateTime/alarm-locked-in-lc.svg)
  AlarmLockedIn,

  /// ### [Uni_icons: DateTime] - AlarmLockedOut
  /// !["Icon of AlarmLockedOut"](/Users/prad/Sonr/tools/icons/assets/solid/DateTime/alarm-locked-ou-lc.svg)
  AlarmLockedOut,

  /// ### [Uni_icons: DateTime] - AlarmRemoveIn
  /// !["Icon of AlarmRemoveIn"](/Users/prad/Sonr/tools/icons/assets/solid/DateTime/alarm-remove-in-lc.svg)
  AlarmRemoveIn,

  /// ### [Uni_icons: DateTime] - AlarmOff
  /// !["Icon of AlarmOff"](/Users/prad/Sonr/tools/icons/assets/solid/DateTime/alarm-off.svg)
  AlarmOff,

  /// ### [Uni_icons: DateTime] - AlarmExportIn
  /// !["Icon of AlarmExportIn"](/Users/prad/Sonr/tools/icons/assets/solid/DateTime/alarm-export-in-lc.svg)
  AlarmExportIn,

  /// ### [Uni_icons: DateTime] - AlarmImportOut
  /// !["Icon of AlarmImportOut"](/Users/prad/Sonr/tools/icons/assets/solid/DateTime/alarm-import-ou-lc.svg)
  AlarmImportOut,
}

extension DateTimeUtils on DateTimeIcons {
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
