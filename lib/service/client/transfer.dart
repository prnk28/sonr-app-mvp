import 'package:sonr_app/style/style.dart';
import 'package:file_picker/file_picker.dart';

/// @ Class for Managing Files
class TransferService extends GetxService {
  // Status
  static bool get isRegistered => Get.isRegistered<TransferService>();
  static TransferService get to => Get.find<TransferService>();

  // Properties
  final _hasPayload = false.obs;
  final _payload = Payload.NONE.obs;
  final _inviteRequest = AuthInvite().obs;
  final _file = SonrFile().obs;
  final _thumbStatus = ThumbnailStatus.None.obs;

  // Property Accessors
  static Rx<Payload> get payload => to._payload;
  static Rx<AuthInvite> get inviteRequest => to._inviteRequest;
  static Rx<SonrFile> get file => to._file;
  static Rx<ThumbnailStatus> get thumbStatus => to._thumbStatus;
  static RxBool get hasPayload => to._hasPayload;

  /// @ Initialize Service
  Future<TransferService> init() async {
    return this;
  }

  // @ Use Camera for Media File //
  static Future<bool> chooseCamera({bool withRedirect = true}) async {
    // Move to View
    CameraView.open(onMediaSelected: (SonrFile file) async {
      await _handlePayload(Payload.MEDIA, file: file);
      // Shift Pages
      Get.offNamed("/transfer");
    });
    return true;
  }

  // @ Set User Contact for Transfer //
  static Future<bool> chooseContact({bool withRedirect = true}) async {
    await _handlePayload(Payload.CONTACT);

    // Shift Pages
    if (withRedirect) {
      Get.offNamed("/transfer");
    }
    return true;
  }

  // @ Select Media File //
  static Future<bool> chooseMedia({bool withRedirect = true}) async {
    // Load Picker
    var result = await _handleSelectRequest(FileType.media);

    // Check File
    if (result != null) {
      var file = result.toSonrFile(payload: Payload.MEDIA);
      await _handlePayload(file.payload, file: file);

      // Shift Pages
      if (withRedirect) {
        Get.offNamed("/transfer");
      }
      return true;
    }
    return false;
  }

  // @ Select Other File //
  static Future<bool> chooseFile({bool withRedirect = true}) async {
    // Load Picker
    var result = await _handleSelectRequest(FileType.any);

    // Check File
    if (result != null) {
      var file = result.toSonrFile(payload: Payload.FILE);
      await _handlePayload(file.payload, file: file);

      // Shift Pages
      if (withRedirect) {
        Get.offNamed("/transfer");
      }
      return true;
    }
    return false;
  }

  // @ Select Other File //
  static Future<bool> chooseFileAndSend(Peer peer) async {
    // Load Picker
    var result = await _handleSelectRequest(FileType.any);

    // Check File
    if (result != null) {
      var file = result.toSonrFile(payload: Payload.FILE);
      await _handlePayload(file.payload, file: file);
      sendInviteToPeer(peer);
      return true;
    }
    return false;
  }

  /// @ Resets Transfer Service
  static Future<void> reset() async {
    //
  }

  // @ Select Media File //
  static Future<void> setUrl(String url) async {
    await _handlePayload(Payload.URL, url: url);

    // Shift Pages
    Get.offNamed("/transfer");
  }

  // @ Select Media File //
  static Future<void> setMedia(SonrFile file, {bool withRedirect = true}) async {
    await _handlePayload(file.payload, file: file);

    // Shift Pages
    if (withRedirect) {
      Get.offNamed("/transfer");
    }
  }

  /// @ Send Invite with Peer
  static void sendInviteToPeer(Peer peer) {
    // Check if Payload Set
    if (to._hasPayload.value) {
      // Update Request
      to._inviteRequest.setPeer(peer);

      // Send Invite
      SonrService.invite(to._inviteRequest.value);
    }
  }

  /// @ Sets File from Other Source
  static Future<bool> setFile(SonrFile file, {bool withRedirect = true}) async {
    // Handle File Payload
    await _handlePayload(file.payload, file: file);

    // Shift Pages
    if (withRedirect) {
      Get.offNamed("/transfer");
    }
    return true;
  }

  /// Set Transfer Payload for File
  static Future<void> _handlePayload(Payload payload, {SonrFile? file, String? url}) async {
    // Initialize Request
    to._payload(payload);

    // Check for File
    if (to._payload.value.isTransfer && file != null) {
      file.update();
      to._inviteRequest.init(payload, file: file);
      to._file(file);

      // Check for Media
      if (to._inviteRequest.isMedia) {
        // Set File Item
        to._thumbStatus(ThumbnailStatus.Loading);
        await to._file.value.setThumbnail();

        // Check Result
        if (to._file.value.single.hasThumbnail()) {
          to._thumbStatus(ThumbnailStatus.Complete);
        } else {
          to._thumbStatus(ThumbnailStatus.None);
        }
      }
    }
    // Check for Contact
    else if (to._payload.value == Payload.CONTACT) {
      to._inviteRequest.init(payload, contact: UserService.contact.value);
    }
    // Check for URL
    else if (to._payload.value == Payload.URL) {
      to._inviteRequest.init(payload, url: url!);
    }

    // Set Has Payload
    to._hasPayload(true);
  }

  // # Generic Method for Different File Types
  static Future<FilePickerResult?> _handleSelectRequest(FileType type) async {
    // @ Check if File Already Queued
    // Check Type for Custom Files
    if (type == FileType.any) {
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
