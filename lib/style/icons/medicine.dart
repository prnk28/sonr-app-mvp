import 'icons.dart';

enum MedicalIcons {
  /// ### [Uni_icons: Medicine] - HeartRateMonitor
  /// !["Icon of HeartRateMonitor"](/Users/prad/Sonr/tools/icons/assets/solid/Medicine/heart-rate-monitor.svg)
  HeartRateMonitor,

  /// ### [Uni_icons: Medicine] - Dna
  /// !["Icon of Dna"](/Users/prad/Sonr/tools/icons/assets/solid/Medicine/dna.svg)
  Dna,

  /// ### [Uni_icons: Medicine] - HospitalBuilding
  /// !["Icon of HospitalBuilding"](/Users/prad/Sonr/tools/icons/assets/solid/Medicine/hospital-building.svg)
  HospitalBuilding,

  /// ### [Uni_icons: Medicine] - HeartRate
  /// !["Icon of HeartRate"](/Users/prad/Sonr/tools/icons/assets/solid/Medicine/heart-rate.svg)
  HeartRate,

  /// ### [Uni_icons: Medicine] - IntravenousTherapy
  /// !["Icon of IntravenousTherapy"](/Users/prad/Sonr/tools/icons/assets/solid/Medicine/intravenous-therapy.svg)
  IntravenousTherapy,

  /// ### [Uni_icons: Medicine] - MedicalCase
  /// !["Icon of MedicalCase"](/Users/prad/Sonr/tools/icons/assets/solid/Medicine/medical-case.svg)
  MedicalCase,

  /// ### [Uni_icons: Medicine] - MedicalChart
  /// !["Icon of MedicalChart"](/Users/prad/Sonr/tools/icons/assets/solid/Medicine/medical-chart.svg)
  MedicalChart,

  /// ### [Uni_icons: Medicine] - MedicalCross
  /// !["Icon of MedicalCross"](/Users/prad/Sonr/tools/icons/assets/solid/Medicine/medical-cross.svg)
  MedicalCross,

  /// ### [Uni_icons: Medicine] - MedicalMask
  /// !["Icon of MedicalMask"](/Users/prad/Sonr/tools/icons/assets/solid/Medicine/medical-mask.svg)
  MedicalMask,

  /// ### [Uni_icons: Medicine] - MedicineBottle
  /// !["Icon of MedicineBottle"](/Users/prad/Sonr/tools/icons/assets/solid/Medicine/medicine-bottle.svg)
  MedicineBottle,

  /// ### [Uni_icons: Medicine] - Patch
  /// !["Icon of Patch"](/Users/prad/Sonr/tools/icons/assets/solid/Medicine/patch.svg)
  Patch,

  /// ### [Uni_icons: Medicine] - PetriDish
  /// !["Icon of PetriDish"](/Users/prad/Sonr/tools/icons/assets/solid/Medicine/petri-dish.svg)
  PetriDish,

  /// ### [Uni_icons: Medicine] - Pill
  /// !["Icon of Pill"](/Users/prad/Sonr/tools/icons/assets/solid/Medicine/pill.svg)
  Pill,

  /// ### [Uni_icons: Medicine] - Stethoscope
  /// !["Icon of Stethoscope"](/Users/prad/Sonr/tools/icons/assets/solid/Medicine/stethoscope.svg)
  Stethoscope,

  /// ### [Uni_icons: Medicine] - Syringe
  /// !["Icon of Syringe"](/Users/prad/Sonr/tools/icons/assets/solid/Medicine/syringe.svg)
  Syringe,

  /// ### [Uni_icons: Medicine] - Tablets
  /// !["Icon of Tablets"](/Users/prad/Sonr/tools/icons/assets/solid/Medicine/tablets.svg)
  Tablets,

  /// ### [Uni_icons: Medicine] - TestTube
  /// !["Icon of TestTube"](/Users/prad/Sonr/tools/icons/assets/solid/Medicine/test-tube.svg)
  TestTube,
}

extension MedicineUtils on MedicalIcons {
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
