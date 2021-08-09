import 'icons.dart';

enum FormattingIcons {
  /// ### [Uni_icons: Formatting] - AlignBoxBottomLeft
  /// !["Icon of AlignBoxBottomLeft"](/Users/prad/Sonr/tools/icons/assets/solid/Formatting/align-box-bottom-left.svg)
  AlignBoxBottomLeft,

  /// ### [Uni_icons: Formatting] - AlignBoxMiddleLeft
  /// !["Icon of AlignBoxMiddleLeft"](/Users/prad/Sonr/tools/icons/assets/solid/Formatting/align-box-middle-left.svg)
  AlignBoxMiddleLeft,

  /// ### [Uni_icons: Formatting] - AlignBoxMiddleRight
  /// !["Icon of AlignBoxMiddleRight"](/Users/prad/Sonr/tools/icons/assets/solid/Formatting/align-box-middle-right.svg)
  AlignBoxMiddleRight,

  /// ### [Uni_icons: Formatting] - AlignBoxMiddleCenter
  /// !["Icon of AlignBoxMiddleCenter"](/Users/prad/Sonr/tools/icons/assets/solid/Formatting/align-box-middle-center.svg)
  AlignBoxMiddleCenter,

  /// ### [Uni_icons: Formatting] - AlignBoxTopCenter
  /// !["Icon of AlignBoxTopCenter"](/Users/prad/Sonr/tools/icons/assets/solid/Formatting/align-box-top-center.svg)
  AlignBoxTopCenter,

  /// ### [Uni_icons: Formatting] - AlignBoxTopLeft
  /// !["Icon of AlignBoxTopLeft"](/Users/prad/Sonr/tools/icons/assets/solid/Formatting/align-box-top-left.svg)
  AlignBoxTopLeft,

  /// ### [Uni_icons: Formatting] - AlignHorizontalCenter
  /// !["Icon of AlignHorizontalCenter"](/Users/prad/Sonr/tools/icons/assets/solid/Formatting/align-horizontal-center.svg)
  AlignHorizontalCenter,

  /// ### [Uni_icons: Formatting] - AlignBoxTopRight
  /// !["Icon of AlignBoxTopRight"](/Users/prad/Sonr/tools/icons/assets/solid/Formatting/align-box-top-right.svg)
  AlignBoxTopRight,

  /// ### [Uni_icons: Formatting] - AlignBoxBottomRight
  /// !["Icon of AlignBoxBottomRight"](/Users/prad/Sonr/tools/icons/assets/solid/Formatting/align-box-bottom-right.svg)
  AlignBoxBottomRight,

  /// ### [Uni_icons: Formatting] - AlignHorizontalLeft
  /// !["Icon of AlignHorizontalLeft"](/Users/prad/Sonr/tools/icons/assets/solid/Formatting/align-horizontal-left.svg)
  AlignHorizontalLeft,

  /// ### [Uni_icons: Formatting] - AlignHorizontalRight
  /// !["Icon of AlignHorizontalRight"](/Users/prad/Sonr/tools/icons/assets/solid/Formatting/align-horizontal-right.svg)
  AlignHorizontalRight,

  /// ### [Uni_icons: Formatting] - AlignVerticalBottom
  /// !["Icon of AlignVerticalBottom"](/Users/prad/Sonr/tools/icons/assets/solid/Formatting/align-vertical-bottom.svg)
  AlignVerticalBottom,

  /// ### [Uni_icons: Formatting] - AlignVerticalTop
  /// !["Icon of AlignVerticalTop"](/Users/prad/Sonr/tools/icons/assets/solid/Formatting/align-vertical-top.svg)
  AlignVerticalTop,

  /// ### [Uni_icons: Formatting] - DistributeVertical
  /// !["Icon of DistributeVertical"](/Users/prad/Sonr/tools/icons/assets/solid/Formatting/distribute-vertical.svg)
  DistributeVertical,

  /// ### [Uni_icons: Formatting] - DistributeHorizontal
  /// !["Icon of DistributeHorizontal"](/Users/prad/Sonr/tools/icons/assets/solid/Formatting/distribute-horizontal.svg)
  DistributeHorizontal,

  /// ### [Uni_icons: Formatting] - ListBoxes
  /// !["Icon of ListBoxes"](/Users/prad/Sonr/tools/icons/assets/solid/Formatting/list-boxes.svg)
  ListBoxes,

  /// ### [Uni_icons: Formatting] - AlignVerticalCenter
  /// !["Icon of AlignVerticalCenter"](/Users/prad/Sonr/tools/icons/assets/solid/Formatting/align-vertical-center.svg)
  AlignVerticalCenter,
}

extension FormattingUtils on FormattingIcons {
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
