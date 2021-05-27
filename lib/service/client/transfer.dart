import 'package:sonr_app/style/style.dart';
import 'package:file_picker/file_picker.dart';

/// @ Class for Managing Files
class TransferService extends GetxService {
  // Status
  static bool get isRegistered => Get.isRegistered<TransferService>();
  static TransferService get to => Get.find<TransferService>();

  // Properties
  final _sharedItem = ShareItem.blank().obs;
  final _file = SonrFile().obs;

  // Property Accessors
  static Rx<ShareItem> get sharedItem => to._sharedItem;
  static Rx<SonrFile> get file => to._file;

  /// @ Initialize Service
  Future<TransferService> init() async {
    return this;
  }

  // @ Use Camera for Media File //
  static Future<void> chooseCamera({bool withRedirect = true}) async {
    // Move to View
    CameraView.open(onMediaSelected: (SonrFile file) async {
      to._sharedItem(await ShareItem.fromFile(file));

      // Shift Pages
      if (withRedirect) {
        Get.offNamed("/transfer");
      }
    });
  }

  // @ Set Contact Card as Payload //
  static void chooseContact({bool withRedirect = true}) async {
    to._sharedItem(await ShareItem.fromContact(UserService.contact.value));

    // Shift Pages
    if (withRedirect) {
      Get.offNamed("/transfer");
    }
  }

  // @ Select Media File //
  static Future<void> chooseMedia({bool withRedirect = true}) async {
    // Load Picker
    var result = await _handleSelectRequest(FileType.media);

    // Check File
    if (result != null) {
      // Set File
      to._sharedItem(await ShareItem.fromFile(result.toSonrFile(payload: Payload.MEDIA)));

      // Shift Pages
      if (withRedirect) {
        Get.offNamed("/transfer");
      }
    }
  }

  // @ Select Other File //
  static Future<void> chooseFile({bool withRedirect = true}) async {
    // Load Picker
    var result = await _handleSelectRequest(FileType.custom);

    // Check File
    if (result != null) {
      var file = result.toSonrFile(payload: Payload.MEDIA);
      // Handle File Payload
      to._sharedItem(await ShareItem.fromFile(file));

      // Shift Pages
      if (withRedirect) {
        Get.offNamed("/transfer");
      }
    }
  }

  // @ Select Media File //
  static Future<void> chooseMediaExternal(SonrFile file) async {
    // Handle File Payload
    to._sharedItem(await ShareItem.fromFile(file));

    // Shift Pages
    Get.offNamed("/transfer");
  }

  // @ Select Media File //
  static Future<void> chooseURLExternal(String url) async {
    // Handle File Payload
    to._sharedItem(await ShareItem.fromUrl(url));

    // Shift Pages
    Get.offNamed("/transfer");
  }

  /// @ Send Invite with Peer
  static void sendPeer(Peer peer) {
    // Check if Has Transfer
    if (to._sharedItem.value.exists) {
      // Send Invite
      SonrService.invite(to._sharedItem.value.invite(peer));
    } else {
      SonrSnack.missing("No Transfer Set");
    }
  }

  /// @ Sets File from Other Source
  static Future<void> setFile(SonrFile file, {bool withRedirect = true}) async {
    // Handle File Payload
    to._sharedItem(await ShareItem.fromFile(file));

    // Shift Pages
    if (withRedirect) {
      Get.offNamed("/transfer");
    }
  }

  // # Generic Method for Different File Types
  static Future<FilePickerResult?> _handleSelectRequest(FileType type) async {
    // @ Check if File Already Queued
    // Check Type for Custom Files
    if (type == FileType.custom) {
      return await FilePicker.platform.pickFiles(
        withData: true,
        allowMultiple: true,
        allowCompression: true,
      );
    }

    // For Media/Audio Files
    else {
      return await FilePicker.platform.pickFiles(
        type: FileType.media,
        withData: true,
        allowMultiple: true,
        allowCompression: true,
      );
    }
  }
}
