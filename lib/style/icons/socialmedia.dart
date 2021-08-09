import 'icons.dart';

enum SocialMediaIcons {
  /// ### [Uni_icons: SocialMedia] - Behance
  /// !["Icon of Behance"](/Users/prad/Sonr/tools/icons/assets/solid/SocialMedia/behance.svg)
  Behance,

  /// ### [Uni_icons: SocialMedia] - Dribbble
  /// !["Icon of Dribbble"](/Users/prad/Sonr/tools/icons/assets/solid/SocialMedia/dribbble.svg)
  Dribbble,

  /// ### [Uni_icons: SocialMedia] - Facebook
  /// !["Icon of Facebook"](/Users/prad/Sonr/tools/icons/assets/solid/SocialMedia/facebook.svg)
  Facebook,

  /// ### [Uni_icons: SocialMedia] - Figma
  /// !["Icon of Figma"](/Users/prad/Sonr/tools/icons/assets/solid/SocialMedia/figma.svg)
  Figma,

  /// ### [Uni_icons: SocialMedia] - Foursquare
  /// !["Icon of Foursquare"](/Users/prad/Sonr/tools/icons/assets/solid/SocialMedia/foursquare.svg)
  Foursquare,

  /// ### [Uni_icons: SocialMedia] - Instagram
  /// !["Icon of Instagram"](/Users/prad/Sonr/tools/icons/assets/solid/SocialMedia/instagram.svg)
  Instagram,

  /// ### [Uni_icons: SocialMedia] - Apple
  /// !["Icon of Apple"](/Users/prad/Sonr/tools/icons/assets/solid/SocialMedia/apple.svg)
  Apple,

  /// ### [Uni_icons: SocialMedia] - Netflix
  /// !["Icon of Netflix"](/Users/prad/Sonr/tools/icons/assets/solid/SocialMedia/netflix.svg)
  Netflix,

  /// ### [Uni_icons: SocialMedia] - Messenger
  /// !["Icon of Messenger"](/Users/prad/Sonr/tools/icons/assets/solid/SocialMedia/messenger.svg)
  Messenger,

  /// ### [Uni_icons: SocialMedia] - Linkedin
  /// !["Icon of Linkedin"](/Users/prad/Sonr/tools/icons/assets/solid/SocialMedia/linkedin.svg)
  Linkedin,

  /// ### [Uni_icons: SocialMedia] - ProductHunt
  /// !["Icon of ProductHunt"](/Users/prad/Sonr/tools/icons/assets/solid/SocialMedia/product-hunt.svg)
  ProductHunt,

  /// ### [Uni_icons: SocialMedia] - Sketch
  /// !["Icon of Sketch"](/Users/prad/Sonr/tools/icons/assets/solid/SocialMedia/sketch.svg)
  Sketch,

  /// ### [Uni_icons: SocialMedia] - Soundcloud
  /// !["Icon of Soundcloud"](/Users/prad/Sonr/tools/icons/assets/solid/SocialMedia/soundcloud.svg)
  Soundcloud,

  /// ### [Uni_icons: SocialMedia] - Pinterest
  /// !["Icon of Pinterest"](/Users/prad/Sonr/tools/icons/assets/solid/SocialMedia/pinterest.svg)
  Pinterest,

  /// ### [Uni_icons: SocialMedia] - Twitter
  /// !["Icon of Twitter"](/Users/prad/Sonr/tools/icons/assets/solid/SocialMedia/twitter.svg)
  Twitter,

  /// ### [Uni_icons: SocialMedia] - Trello
  /// !["Icon of Trello"](/Users/prad/Sonr/tools/icons/assets/solid/SocialMedia/trello.svg)
  Trello,

  /// ### [Uni_icons: SocialMedia] - Tiktok
  /// !["Icon of Tiktok"](/Users/prad/Sonr/tools/icons/assets/solid/SocialMedia/tiktok.svg)
  Tiktok,
}

extension SocialMediaUtils on SocialMediaIcons {
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
