import 'icons.dart';

enum DesignIcons {
  /// ### [Uni_icons: Design] - CircleAndSquare
  /// !["Icon of CircleAndSquare"](/Users/prad/Sonr/tools/icons/assets/solid/Design/circle-and-square.svg)
  CircleAndSquare,

  /// ### [Uni_icons: Design] - CropTool
  /// !["Icon of CropTool"](/Users/prad/Sonr/tools/icons/assets/solid/Design/crop-tool.svg)
  CropTool,

  /// ### [Uni_icons: Design] - Grid
  /// !["Icon of Grid"](/Users/prad/Sonr/tools/icons/assets/solid/Design/grid.svg)
  Grid,

  /// ### [Uni_icons: Design] - ImageAddOut
  /// !["Icon of ImageAddOut"](/Users/prad/Sonr/tools/icons/assets/solid/Design/image-add-ou-lc.svg)
  ImageAddOut,

  /// ### [Uni_icons: Design] - Eraser
  /// !["Icon of Eraser"](/Users/prad/Sonr/tools/icons/assets/solid/Design/eraser.svg)
  Eraser,

  /// ### [Uni_icons: Design] - ImageDownloadOut
  /// !["Icon of ImageDownloadOut"](/Users/prad/Sonr/tools/icons/assets/solid/Design/image-download-ou-lc.svg)
  ImageDownloadOut,

  /// ### [Uni_icons: Design] - ImageEditOut
  /// !["Icon of ImageEditOut"](/Users/prad/Sonr/tools/icons/assets/solid/Design/image-edit-ou-lc.svg)
  ImageEditOut,

  /// ### [Uni_icons: Design] - ImageExportOut
  /// !["Icon of ImageExportOut"](/Users/prad/Sonr/tools/icons/assets/solid/Design/image-export-ou-lc.svg)
  ImageExportOut,

  /// ### [Uni_icons: Design] - ImageFavouriteOut
  /// !["Icon of ImageFavouriteOut"](/Users/prad/Sonr/tools/icons/assets/solid/Design/image-favourite-ou-lc.svg)
  ImageFavouriteOut,

  /// ### [Uni_icons: Design] - ImageImportOut
  /// !["Icon of ImageImportOut"](/Users/prad/Sonr/tools/icons/assets/solid/Design/image-import-ou-lc.svg)
  ImageImportOut,

  /// ### [Uni_icons: Design] - ImageLockedOut
  /// !["Icon of ImageLockedOut"](/Users/prad/Sonr/tools/icons/assets/solid/Design/image-locked-ou-lc.svg)
  ImageLockedOut,

  /// ### [Uni_icons: Design] - ImageOff
  /// !["Icon of ImageOff"](/Users/prad/Sonr/tools/icons/assets/solid/Design/image-off.svg)
  ImageOff,

  /// ### [Uni_icons: Design] - ImageRemoveOut
  /// !["Icon of ImageRemoveOut"](/Users/prad/Sonr/tools/icons/assets/solid/Design/image-remove-ou-lc.svg)
  ImageRemoveOut,

  /// ### [Uni_icons: Design] - ImageSubtractOut
  /// !["Icon of ImageSubtractOut"](/Users/prad/Sonr/tools/icons/assets/solid/Design/image-subtract-ou-lc.svg)
  ImageSubtractOut,

  /// ### [Uni_icons: Design] - ImageUploadOut
  /// !["Icon of ImageUploadOut"](/Users/prad/Sonr/tools/icons/assets/solid/Design/image-upload-ou-lc.svg)
  ImageUploadOut,

  /// ### [Uni_icons: Design] - ImageSearchOut
  /// !["Icon of ImageSearchOut"](/Users/prad/Sonr/tools/icons/assets/solid/Design/image-search-ou-lc.svg)
  ImageSearchOut,

  /// ### [Uni_icons: Design] - ImageCheckOut
  /// !["Icon of ImageCheckOut"](/Users/prad/Sonr/tools/icons/assets/solid/Design/image-check-ou-lc.svg)
  ImageCheckOut,
}

extension DesignUtils on DesignIcons {
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
