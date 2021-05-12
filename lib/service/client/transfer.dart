import 'package:sonr_app/style/style.dart';
import 'package:file_picker/file_picker.dart';

enum ThumbnailStatus { None, Loading, Complete }

/// @ Class for Managing Files
class TransferService extends GetxService {
  // Status
  static bool get isRegistered => Get.isRegistered<TransferService>();
  static TransferService get to => Get.find<TransferService>();

  // Properties
  final _shareTitle = "Sharing".obs;
  final _payload = Payload.NONE.obs;
  final _inviteRequest = InviteRequest().obs;
  final _sonrFile = SonrFile().obs;
  final _thumbStatus = ThumbnailStatus.None.obs;

  // Property Accessors
  static Rx<Payload> get payload => to._payload;
  static Rx<InviteRequest> get inviteRequest => to._inviteRequest;
  static Rx<SonrFile> get file => to._sonrFile;
  static Rx<ThumbnailStatus> get thumbStatus => to._thumbStatus;
  static RxString get shareTitle => to._shareTitle;

  /// @ Initialize Service
  Future<TransferService> init() async {
    return this;
  }

  // @ Use Camera for Media File //
  static Future<void> chooseCamera() async {
    // Move to View
    CameraView.open(onMediaSelected: (SonrFile file) async {
      await _handlePayload(Payload.MEDIA, file: file);
      // Shift Pages
      Get.offNamed("/transfer");
    });
  }

  static void chooseContact() async {
    await _handlePayload(Payload.CONTACT);

    // Shift Pages
    Get.offNamed("/transfer");
  }

  // @ Select Media File //
  static Future<void> chooseMedia() async {
    // Load Picker
    var result = await _handleSelectRequest(FileType.media);

    // Check File
    if (result != null) {
      if (result.isSinglePick) {
        var file = await SonrFileUtils.newWith(payload: Payload.MEDIA, path: result.files.first.path!);
        await _handlePayload(Payload.MEDIA, file: file);
      }
      // Multiple: Iterate Items
      else {
        // Initialize
        var file = SonrFile(direction: SonrFile_Direction.Outgoing, payload: Payload.MULTI_FILES);

        // Add Items
        result.files.forEach((e) {
          file.addItem(path: e.path!);
        });

        await _handlePayload(Payload.MULTI_FILES, file: file);
      }

      // Shift Pages
      Get.offNamed("/transfer");
    }
  }

  // @ Select Media File //
  static Future<void> chooseMediaExternal(SonrFile file) async {
    await _handlePayload(Payload.MEDIA, file: file);

    // Shift Pages
    Get.offNamed("/transfer");
  }

  // @ Select Other File //
  static Future<void> chooseFile() async {
    // Load Picker
    var result = await _handleSelectRequest(FileType.custom);

    // Check File
    if (result != null) {
      // Check If Single
      if (result.isSinglePick) {
        var file = await SonrFileUtils.newWith(payload: Payload.FILE, path: result.files.first.path!);
        await _handlePayload(Payload.FILE, file: file);
      }
      // Multiple: Iterate Items
      else {
        // Initialize
        var file = SonrFile(direction: SonrFile_Direction.Outgoing, payload: Payload.MULTI_FILES);

        // Add Items
        result.files.forEach((e) {
          file.addItem(path: e.path!);
        });

        await _handlePayload(Payload.MULTI_FILES, file: file);
      }
      // Shift Pages
      Get.offNamed("/transfer");
    }
  }

  // @ Select Media File //
  static Future<void> chooseURLExternal(String url) async {
    await _handlePayload(Payload.URL, url: url);

    // Shift Pages
    Get.offNamed("/transfer");
  }

  /// @ Send Invite with Peer
  static void sendPeer(Peer peer) {
    // Update Request
    to._inviteRequest.setPeer(peer);

    // Send Invite
    SonrService.invite(to._inviteRequest.value);
  }

  /// Set Transfer Payload for File
  static Future<void> _handlePayload(Payload payload, {SonrFile? file, String? url}) async {
    // Initialize Request
    to._payload(payload);

    // Check for File
    if (to._payload.value.isTransfer) {
      to._inviteRequest.init(payload, file: file);
      to._sonrFile(file!);
      to._shareTitle("Sharing " + to._sonrFile.value.prettyType());

      // Check for Media
      if (to._inviteRequest.isMedia) {
        // Set File Item
        to._thumbStatus(ThumbnailStatus.Loading);
        await to._sonrFile.value.setThumbnail();

        // Check Result
        if (to._sonrFile.value.single.hasThumbnail()) {
          to._thumbStatus(ThumbnailStatus.Complete);
        } else {
          to._thumbStatus(ThumbnailStatus.None);
        }
      }
    }
    // Check for Contact
    else if (to._payload.value == Payload.CONTACT) {
      to._inviteRequest.init(payload, contact: UserService.contact.value);
      to._shareTitle("Sharing Contact Card");
    }
    // Check for URL
    else if (to._payload.value == Payload.URL) {
      to._inviteRequest.init(payload, url: url!);
      to._shareTitle("Sending Link");
    }
  }

  // # Generic Method for Different File Types
  static Future<FilePickerResult?> _handleSelectRequest(FileType type) async {
    // @ Check if File Already Queued
    // Check Type for Custom Files
    if (type == FileType.custom) {
      return await FilePicker.platform.pickFiles(
        type: FileType.custom,
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
