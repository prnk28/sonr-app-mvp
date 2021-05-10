import 'package:sonr_app/style/style.dart';
import 'package:file_picker/file_picker.dart';

enum ThumbnailStatus { None, Loading, Complete }

/// @ Class for Managing Files
class TransferService extends GetxService {
  // Status
  static bool get isRegistered => Get.isRegistered<TransferService>();
  static TransferService get to => Get.find<TransferService>();

  // Properties
  final _payload = Payload.NONE.obs;
  final _inviteRequest = InviteRequest().obs;
  final _sonrFile = SonrFile().obs;
  final _thumbStatus = ThumbnailStatus.None.obs;

  // Property Accessors
  static Rx<Payload> get payload => to._payload;
  static Rx<InviteRequest> get inviteRequest => to._inviteRequest;
  static Rx<SonrFile> get file => to._sonrFile;
  static Rx<ThumbnailStatus> get thumbStatus => to._thumbStatus;

  /// @ Initialize Service
  Future<TransferService> init() async {
    return this;
  }

  // @ Use Camera for Media File //
  static Future<void> chooseCamera() async {
    // Move to View
    Get.to(CameraView.withPreview(onMediaSelected: (SonrFile file) {
      _handlePayload(Payload.MEDIA, file: file);
      Get.offNamed("/transfer", arguments: TransferArguments(TransferService.payload.value, file: TransferService.file.value));
    }), transition: Transition.downToUp);
  }

  static void chooseContact() async {
    _handlePayload(Payload.CONTACT);
  }

  // @ Select Media File //
  static Future<void> chooseMedia() async {
    // Load Picker
    var result = await _handleSelectRequest(FileType.media);

    // Check File
    if (result != null) {
      var file = await SonrFileUtils.newWith(payload: Payload.MEDIA, path: result.files.first.path!);
      _handlePayload(Payload.MEDIA, file: file);
    }
  }

  // @ Select Media File //
  static Future<void> chooseMediaExternal(SonrFile file) async {
    _handlePayload(Payload.MEDIA, file: file);
  }

  // @ Select Other File //
  static Future<void> chooseFile() async {
    // Load Picker
    var result = await _handleSelectRequest(FileType.custom);

    // Check File
    if (result != null) {
      // Check If Single
      if (result.isSinglePick) {
        var file = await SonrFileUtils.newWith(payload: Payload.MEDIA, path: result.files.first.path!);
        _handlePayload(Payload.FILE, file: file);
      }
      // Multiple: Iterate Items
      else {
        // Initialize
        var file = SonrFile(direction: SonrFile_Direction.Outgoing, payload: Payload.MULTI_FILES);

        // Add Items
        result.files.forEach((e) {
          file.addItem(path: e.path!);
        });

        _handlePayload(Payload.MULTI_FILES, file: file);
      }

      Get.offNamed("/transfer", arguments: TransferArguments(TransferService.payload.value, file: TransferService.file.value));
    }
  }

  // @ Select Media File //
  static Future<void> chooseURLExternal(String url) async {
    _handlePayload(Payload.URL, url: url);
  }

  /// @ Send Invite with Peer
  static void sendPeer(Peer peer) {
    // Update Request
    to._inviteRequest.setPeer(peer);

    // Send Invite
    SonrService.invite(to._inviteRequest.value);
  }

  /// Set Transfer Payload for File
  static void _handlePayload(Payload payload, {SonrFile? file, String? url}) async {
    // Initialize Request
    to._payload(payload);

    // Check for File
    if (to._payload.value.isTransfer) {
      to._inviteRequest.initValues(payload, file: file);
      to._sonrFile(file!);

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
      to._inviteRequest.initValues(payload, contact: UserService.contact.value);
    }
    // Check for URL
    else if (to._payload.value == Payload.URL) {
      to._inviteRequest.initValues(payload, url: url!);
    }

    // Shift Pages
    Get.offNamed("/transfer");
  }

  // # Generic Method for Different File Types
  static Future<FilePickerResult?> _handleSelectRequest(FileType type) async {
    // @ Check if File Already Queued
    // Check Type for Custom Files
    if (type == FileType.custom) {
      return await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: K_ALLOWED_FILE_TYPES,
        withData: true,
      );
    }

    // For Media/Audio Files
    else {
      return await FilePicker.platform.pickFiles(
        type: FileType.media,
        withData: true,
      );
    }
  }
}
