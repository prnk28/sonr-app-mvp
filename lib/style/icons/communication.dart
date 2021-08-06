import 'icons.dart';

enum CommunicationIcons {
  /// ### [Uni_icons: Communication] - ChatDots
  /// !["Icon of ChatDots"](/Users/prad/Sonr/tools/icons/assets/solid/Communication/chat-dots.svg)
  ChatDots,

  /// ### [Uni_icons: Communication] - Chat
  /// !["Icon of Chat"](/Users/prad/Sonr/tools/icons/assets/solid/Communication/chat.svg)
  Chat,

  /// ### [Uni_icons: Communication] - MailAddOut
  /// !["Icon of MailAddOut"](/Users/prad/Sonr/tools/icons/assets/solid/Communication/mail-add-ou-lc.svg)
  MailAddOut,

  /// ### [Uni_icons: Communication] - ChatText
  /// !["Icon of ChatText"](/Users/prad/Sonr/tools/icons/assets/solid/Communication/chat-text.svg)
  ChatText,

  /// ### [Uni_icons: Communication] - MailDownloadOut
  /// !["Icon of MailDownloadOut"](/Users/prad/Sonr/tools/icons/assets/solid/Communication/mail-download-ou-lc.svg)
  MailDownloadOut,

  /// ### [Uni_icons: Communication] - MailEditOut
  /// !["Icon of MailEditOut"](/Users/prad/Sonr/tools/icons/assets/solid/Communication/mail-edit-ou-lc.svg)
  MailEditOut,

  /// ### [Uni_icons: Communication] - MailExportOut
  /// !["Icon of MailExportOut"](/Users/prad/Sonr/tools/icons/assets/solid/Communication/mail-export-ou-lc.svg)
  MailExportOut,

  /// ### [Uni_icons: Communication] - MailFavouriteOut
  /// !["Icon of MailFavouriteOut"](/Users/prad/Sonr/tools/icons/assets/solid/Communication/mail-favourite-ou-lc.svg)
  MailFavouriteOut,

  /// ### [Uni_icons: Communication] - MailImportOut
  /// !["Icon of MailImportOut"](/Users/prad/Sonr/tools/icons/assets/solid/Communication/mail-import-ou-lc.svg)
  MailImportOut,

  /// ### [Uni_icons: Communication] - MailLockedOut
  /// !["Icon of MailLockedOut"](/Users/prad/Sonr/tools/icons/assets/solid/Communication/mail-locked-ou-lc.svg)
  MailLockedOut,

  /// ### [Uni_icons: Communication] - MailRemoveOut
  /// !["Icon of MailRemoveOut"](/Users/prad/Sonr/tools/icons/assets/solid/Communication/mail-remove-ou-lc.svg)
  MailRemoveOut,

  /// ### [Uni_icons: Communication] - MailSearchOut
  /// !["Icon of MailSearchOut"](/Users/prad/Sonr/tools/icons/assets/solid/Communication/mail-search-ou-lc.svg)
  MailSearchOut,

  /// ### [Uni_icons: Communication] - MailUploadOut
  /// !["Icon of MailUploadOut"](/Users/prad/Sonr/tools/icons/assets/solid/Communication/mail-upload-ou-lc.svg)
  MailUploadOut,

  /// ### [Uni_icons: Communication] - MailViewOut
  /// !["Icon of MailViewOut"](/Users/prad/Sonr/tools/icons/assets/solid/Communication/mail-view-ou-lc.svg)
  MailViewOut,

  /// ### [Uni_icons: Communication] - Mail
  /// !["Icon of Mail"](/Users/prad/Sonr/tools/icons/assets/solid/Communication/mail.svg)
  Mail,

  /// ### [Uni_icons: Communication] - MailCheckOut
  /// !["Icon of MailCheckOut"](/Users/prad/Sonr/tools/icons/assets/solid/Communication/mail-check-ou-lc.svg)
  MailCheckOut,

  /// ### [Uni_icons: Communication] - MailSubtractOut
  /// !["Icon of MailSubtractOut"](/Users/prad/Sonr/tools/icons/assets/solid/Communication/mail-subtract-ou-lc.svg)
  MailSubtractOut,
}

extension CommunicationUtils on CommunicationIcons {
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
