import 'icons.dart';

enum ChartIcons {
  /// ### [Uni_icons: Charts] - BarOneUp
  /// !["Icon of BarOneUp"](/Users/prad/Sonr/tools/icons/assets/solid/Charts/bar-01-up.svg)
  BarOneUp,

  /// ### [Uni_icons: Charts] - BarTwoDown
  /// !["Icon of BarTwoDown"](/Users/prad/Sonr/tools/icons/assets/solid/Charts/bar-02-down.svg)
  BarTwoDown,

  /// ### [Uni_icons: Charts] - BarTwoAverage
  /// !["Icon of BarTwoAverage"](/Users/prad/Sonr/tools/icons/assets/solid/Charts/bar-02-average.svg)
  BarTwoAverage,

  /// ### [Uni_icons: Charts] - BubbleRace
  /// !["Icon of BubbleRace"](/Users/prad/Sonr/tools/icons/assets/solid/Charts/bubble-race.svg)
  BubbleRace,

  /// ### [Uni_icons: Charts] - CandlesticksDown
  /// !["Icon of CandlesticksDown"](/Users/prad/Sonr/tools/icons/assets/solid/Charts/candlesticks-down.svg)
  CandlesticksDown,

  /// ### [Uni_icons: Charts] - ChartMaximum
  /// !["Icon of ChartMaximum"](/Users/prad/Sonr/tools/icons/assets/solid/Charts/chart-maximum.svg)
  ChartMaximum,

  /// ### [Uni_icons: Charts] - CandlesticksUp
  /// !["Icon of CandlesticksUp"](/Users/prad/Sonr/tools/icons/assets/solid/Charts/candlesticks-up.svg)
  CandlesticksUp,

  /// ### [Uni_icons: Charts] - ChartMinimum
  /// !["Icon of ChartMinimum"](/Users/prad/Sonr/tools/icons/assets/solid/Charts/chart-minimum.svg)
  ChartMinimum,

  /// ### [Uni_icons: Charts] - CircularTwo
  /// !["Icon of CircularTwo"](/Users/prad/Sonr/tools/icons/assets/solid/Charts/circular-02.svg)
  CircularTwo,

  /// ### [Uni_icons: Charts] - CircularThree
  /// !["Icon of CircularThree"](/Users/prad/Sonr/tools/icons/assets/solid/Charts/circular-03.svg)
  CircularThree,

  /// ### [Uni_icons: Charts] - BarTwoUp
  /// !["Icon of BarTwoUp"](/Users/prad/Sonr/tools/icons/assets/solid/Charts/bar-02-up.svg)
  BarTwoUp,

  /// ### [Uni_icons: Charts] - ColumnOneDown
  /// !["Icon of ColumnOneDown"](/Users/prad/Sonr/tools/icons/assets/solid/Charts/column-01-down.svg)
  ColumnOneDown,

  /// ### [Uni_icons: Charts] - ColumnTwoAverage
  /// !["Icon of ColumnTwoAverage"](/Users/prad/Sonr/tools/icons/assets/solid/Charts/column-02-average.svg)
  ColumnTwoAverage,

  /// ### [Uni_icons: Charts] - ColumnOneUp
  /// !["Icon of ColumnOneUp"](/Users/prad/Sonr/tools/icons/assets/solid/Charts/column-01-up.svg)
  ColumnOneUp,

  /// ### [Uni_icons: Charts] - ColumnTwoUp
  /// !["Icon of ColumnTwoUp"](/Users/prad/Sonr/tools/icons/assets/solid/Charts/column-02-up.svg)
  ColumnTwoUp,

  /// ### [Uni_icons: Charts] - ColumnTwoDown
  /// !["Icon of ColumnTwoDown"](/Users/prad/Sonr/tools/icons/assets/solid/Charts/column-02-down.svg)
  ColumnTwoDown,

  /// ### [Uni_icons: Charts] - CircularOne
  /// !["Icon of CircularOne"](/Users/prad/Sonr/tools/icons/assets/solid/Charts/circular-01.svg)
  CircularOne,
}

extension ChartIconUtils on ChartIcons {
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
