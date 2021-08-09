import 'icons.dart';

enum SportsIcons {
  /// ### [Uni_icons: Sports] - BasketballBall
  /// !["Icon of BasketballBall"](/Users/prad/Sonr/tools/icons/assets/solid/Sports/basketball-ball.svg)
  BasketballBall,

  /// ### [Uni_icons: Sports] - BasketballHoop
  /// !["Icon of BasketballHoop"](/Users/prad/Sonr/tools/icons/assets/solid/Sports/basketball-hoop.svg)
  BasketballHoop,

  /// ### [Uni_icons: Sports] - BoxingGlove
  /// !["Icon of BoxingGlove"](/Users/prad/Sonr/tools/icons/assets/solid/Sports/boxing-glove.svg)
  BoxingGlove,

  /// ### [Uni_icons: Sports] - Darts
  /// !["Icon of Darts"](/Users/prad/Sonr/tools/icons/assets/solid/Sports/darts.svg)
  Darts,

  /// ### [Uni_icons: Sports] - Fencing
  /// !["Icon of Fencing"](/Users/prad/Sonr/tools/icons/assets/solid/Sports/fencing.svg)
  Fencing,

  /// ### [Uni_icons: Sports] - BowlingBall
  /// !["Icon of BowlingBall"](/Users/prad/Sonr/tools/icons/assets/solid/Sports/bowling-ball.svg)
  BowlingBall,

  /// ### [Uni_icons: Sports] - Flag
  /// !["Icon of Flag"](/Users/prad/Sonr/tools/icons/assets/solid/Sports/flag.svg)
  Flag,

  /// ### [Uni_icons: Sports] - FootballBall
  /// !["Icon of FootballBall"](/Users/prad/Sonr/tools/icons/assets/solid/Sports/football-ball.svg)
  FootballBall,

  /// ### [Uni_icons: Sports] - Scoreboard
  /// !["Icon of Scoreboard"](/Users/prad/Sonr/tools/icons/assets/solid/Sports/scoreboard.svg)
  Scoreboard,

  /// ### [Uni_icons: Sports] - Shorts
  /// !["Icon of Shorts"](/Users/prad/Sonr/tools/icons/assets/solid/Sports/shorts.svg)
  Shorts,

  /// ### [Uni_icons: Sports] - SoccerField
  /// !["Icon of SoccerField"](/Users/prad/Sonr/tools/icons/assets/solid/Sports/soccer-field.svg)
  SoccerField,

  /// ### [Uni_icons: Sports] - Standings
  /// !["Icon of Standings"](/Users/prad/Sonr/tools/icons/assets/solid/Sports/standings.svg)
  Standings,

  /// ### [Uni_icons: Sports] - Medal
  /// !["Icon of Medal"](/Users/prad/Sonr/tools/icons/assets/solid/Sports/medal.svg)
  Medal,

  /// ### [Uni_icons: Sports] - Stopwatch
  /// !["Icon of Stopwatch"](/Users/prad/Sonr/tools/icons/assets/solid/Sports/stopwatch.svg)
  Stopwatch,

  /// ### [Uni_icons: Sports] - TShirt
  /// !["Icon of TShirt"](/Users/prad/Sonr/tools/icons/assets/solid/Sports/t-shirt.svg)
  TShirt,

  /// ### [Uni_icons: Sports] - Trophy
  /// !["Icon of Trophy"](/Users/prad/Sonr/tools/icons/assets/solid/Sports/trophy.svg)
  Trophy,

  /// ### [Uni_icons: Sports] - TableTennis
  /// !["Icon of TableTennis"](/Users/prad/Sonr/tools/icons/assets/solid/Sports/table-tennis.svg)
  TableTennis,
}

extension SportsUtils on SportsIcons {
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
