import 'package:flutter_svg/flutter_svg.dart';
import 'package:sonr_app/style/style.dart';

enum IntricateIcons {
  SecureKeys,
  Book,
  HandShake,
  Mail,
  Video,
  Article,
  PowerpointDocument,
  ExcelDocument,
  MobileConnection,
  ViralPost,
  UserSocialEngineering,
  Diamond,
  SecurityLock,
  Search,
  Clip,
  Calendar,
  Presentation,
  PeopleSearch,
  CreditCard,
  Apple,
  LocationPin,
  Earth,
  Camera,
  DocumentsBox,
  AdminGroup,
  UserContact,
  Eye,
  Anchor,
  DesktopBrowser,
  UserPortfolio,
  Document,
  LobbyGroup,
  InternetOfThings,
  ArGlasses,
  DesktopLink,
  ArEarth,
  PdfDocument,
  LockedFolder,
  Internet,
  ContactCard,
  MediaSelect,
  AppleWatch,
  AndroidWear,
  OldIPhone,
  CurrentIPhone,
  AndroidPhone,
  IPad,
  Laptop,
  Desktop,
  Devices,
  Oculus,
  NintendoSwitch,
  Xbox,
  Playstation,
}

extension IntricateIconUtils on IntricateIcons {
  /// Constant Regex Expression for Fuzzy Path
  static final K_PASCAL_REGEX = RegExp(r"(?:[A-Z]+|^)[a-z]*");

  /// Returns Path for this Icon
  String get path {
    // Set Base Path
    var path = 'assets/svg/';

    // Iterate Words
    for (var word in this.pascalWords) {
      if (word != null) {
        path += word.toLowerCase();
      }
    }
    // Return with extension
    return path + '.svg';
  }

  /// ## IntricateIcons: SVG
  /// Returns SVGPicture Widget, contains all Default properties for SVGPicture package.
  SvgPicture svg({
    Key? key,
    double? width,
    double? height,
    BoxFit fit = BoxFit.contain,
    AlignmentGeometry alignment = Alignment.center,
    Color? color,
    Clip clipBehavior = Clip.hardEdge,
  }) {
    return SvgPicture.asset(
      this.path,
      // color: color ?? AppTheme.itemColor,
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

  /// Get the Name of This Value
  String get value => this.toString().substring(this.toString().indexOf('.') + 1);
}
