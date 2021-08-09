import 'icons.dart';

enum UIIcons {
  /// ### [Uni_icons: UI] - Bell
  /// !["Icon of Bell"](/Users/prad/Sonr/tools/icons/assets/solid/UI/bell.svg)
  Bell,

  /// ### [Uni_icons: UI] - BookmarkCheck
  /// !["Icon of BookmarkCheck"](/Users/prad/Sonr/tools/icons/assets/solid/UI/bookmark-check.svg)
  BookmarkCheck,

  /// ### [Uni_icons: UI] - BookmarkOff
  /// !["Icon of BookmarkOff"](/Users/prad/Sonr/tools/icons/assets/solid/UI/bookmark-off.svg)
  BookmarkOff,

  /// ### [Uni_icons: UI] - BookmarkAdd
  /// !["Icon of BookmarkAdd"](/Users/prad/Sonr/tools/icons/assets/solid/UI/bookmark-add.svg)
  BookmarkAdd,

  /// ### [Uni_icons: UI] - BookmarkSubtract
  /// !["Icon of BookmarkSubtract"](/Users/prad/Sonr/tools/icons/assets/solid/UI/bookmark-subtract.svg)
  BookmarkSubtract,

  /// ### [Uni_icons: UI] - CheckSqFr
  /// !["Icon of CheckSqFr"](/Users/prad/Sonr/tools/icons/assets/solid/UI/check-sq-fr.svg)
  CheckSqFr,

  /// ### [Uni_icons: UI] - BookmarkRemove
  /// !["Icon of BookmarkRemove"](/Users/prad/Sonr/tools/icons/assets/solid/UI/bookmark-remove.svg)
  BookmarkRemove,

  /// ### [Uni_icons: UI] - Bookmark
  /// !["Icon of Bookmark"](/Users/prad/Sonr/tools/icons/assets/solid/UI/bookmark.svg)
  Bookmark,

  /// ### [Uni_icons: UI] - CheckCrFr
  /// !["Icon of CheckCrFr"](/Users/prad/Sonr/tools/icons/assets/solid/UI/check-cr-fr.svg)
  CheckCrFr,

  /// ### [Uni_icons: UI] - ChevronDownCrFr
  /// !["Icon of ChevronDownCrFr"](/Users/prad/Sonr/tools/icons/assets/solid/UI/chevron-down-cr-fr.svg)
  ChevronDownCrFr,

  /// ### [Uni_icons: UI] - ChevronDownSqFr
  /// !["Icon of ChevronDownSqFr"](/Users/prad/Sonr/tools/icons/assets/solid/UI/chevron-down-sq-fr.svg)
  ChevronDownSqFr,

  /// ### [Uni_icons: UI] - ChevronLeftCrFr
  /// !["Icon of ChevronLeftCrFr"](/Users/prad/Sonr/tools/icons/assets/solid/UI/chevron-left-cr-fr.svg)
  ChevronLeftCrFr,

  /// ### [Uni_icons: UI] - ChevronLeftSqFr
  /// !["Icon of ChevronLeftSqFr"](/Users/prad/Sonr/tools/icons/assets/solid/UI/chevron-left-sq-fr.svg)
  ChevronLeftSqFr,

  /// ### [Uni_icons: UI] - ChevronRightCrFr
  /// !["Icon of ChevronRightCrFr"](/Users/prad/Sonr/tools/icons/assets/solid/UI/chevron-right-cr-fr.svg)
  ChevronRightCrFr,

  /// ### [Uni_icons: UI] - ChevronRightSqFr
  /// !["Icon of ChevronRightSqFr"](/Users/prad/Sonr/tools/icons/assets/solid/UI/chevron-right-sq-fr.svg)
  ChevronRightSqFr,

  /// ### [Uni_icons: UI] - ChevronUpCrFr
  /// !["Icon of ChevronUpCrFr"](/Users/prad/Sonr/tools/icons/assets/solid/UI/chevron-up-cr-fr.svg)
  ChevronUpCrFr,

  /// ### [Uni_icons: UI] - ChevronUpSqFr
  /// !["Icon of ChevronUpSqFr"](/Users/prad/Sonr/tools/icons/assets/solid/UI/chevron-up-sq-fr.svg)
  ChevronUpSqFr,
}

extension UIUtils on UIIcons {
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
      color: AppTheme.ItemColorInversed,
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
