import 'icons.dart';

enum FoodIcons {
  /// ### [Uni_icons: Food] - Carrot
  /// !["Icon of Carrot"](/Users/prad/Sonr/tools/icons/assets/solid/Food/carrot.svg)
  Carrot,

  /// ### [Uni_icons: Food] - Avocado
  /// !["Icon of Avocado"](/Users/prad/Sonr/tools/icons/assets/solid/Food/avocado.svg)
  Avocado,

  /// ### [Uni_icons: Food] - CupOne
  /// !["Icon of CupOne"](/Users/prad/Sonr/tools/icons/assets/solid/Food/cup-01.svg)
  CupOne,

  /// ### [Uni_icons: Food] - CupTwo
  /// !["Icon of CupTwo"](/Users/prad/Sonr/tools/icons/assets/solid/Food/cup-02.svg)
  CupTwo,

  /// ### [Uni_icons: Food] - Burger
  /// !["Icon of Burger"](/Users/prad/Sonr/tools/icons/assets/solid/Food/burger.svg)
  Burger,

  /// ### [Uni_icons: Food] - CupToGo
  /// !["Icon of CupToGo"](/Users/prad/Sonr/tools/icons/assets/solid/Food/cup-to-go.svg)
  CupToGo,

  /// ### [Uni_icons: Food] - Donut
  /// !["Icon of Donut"](/Users/prad/Sonr/tools/icons/assets/solid/Food/donut.svg)
  Donut,

  /// ### [Uni_icons: Food] - FrenchFries
  /// !["Icon of FrenchFries"](/Users/prad/Sonr/tools/icons/assets/solid/Food/french-fries.svg)
  FrenchFries,

  /// ### [Uni_icons: Food] - Glass
  /// !["Icon of Glass"](/Users/prad/Sonr/tools/icons/assets/solid/Food/glass.svg)
  Glass,

  /// ### [Uni_icons: Food] - HatChef
  /// !["Icon of HatChef"](/Users/prad/Sonr/tools/icons/assets/solid/Food/hat-chef.svg)
  HatChef,

  /// ### [Uni_icons: Food] - IceCream
  /// !["Icon of IceCream"](/Users/prad/Sonr/tools/icons/assets/solid/Food/ice-cream.svg)
  IceCream,

  /// ### [Uni_icons: Food] - ForkAndKnife
  /// !["Icon of ForkAndKnife"](/Users/prad/Sonr/tools/icons/assets/solid/Food/fork-and-knife.svg)
  ForkAndKnife,

  /// ### [Uni_icons: Food] - Lollipop
  /// !["Icon of Lollipop"](/Users/prad/Sonr/tools/icons/assets/solid/Food/lollipop.svg)
  Lollipop,

  /// ### [Uni_icons: Food] - Pear
  /// !["Icon of Pear"](/Users/prad/Sonr/tools/icons/assets/solid/Food/pear.svg)
  Pear,

  /// ### [Uni_icons: Food] - SaltShaker
  /// !["Icon of SaltShaker"](/Users/prad/Sonr/tools/icons/assets/solid/Food/salt-shaker.svg)
  SaltShaker,

  /// ### [Uni_icons: Food] - ServingPlate
  /// !["Icon of ServingPlate"](/Users/prad/Sonr/tools/icons/assets/solid/Food/serving-plate.svg)
  ServingPlate,

  /// ### [Uni_icons: Food] - PizzaSlice
  /// !["Icon of PizzaSlice"](/Users/prad/Sonr/tools/icons/assets/solid/Food/pizza-slice.svg)
  PizzaSlice,
}

extension FoodUtils on FoodIcons {
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
