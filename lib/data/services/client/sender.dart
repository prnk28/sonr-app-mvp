import 'dart:async';
import 'package:file_picker/file_picker.dart';
import 'package:receive_sharing_intent/receive_sharing_intent.dart';
import 'package:sonr_app/data/services/services.dart';
import 'package:sonr_app/style/style.dart';

class SenderService extends GetxService {
  // Accessors
  static bool get isRegistered => Get.isRegistered<SenderService>() && DeviceService.hasInternet;
  static SenderService get to => Get.find<SenderService>();
  static Session get session => to._session;
  static Rx<bool> get hasSession => to._hasSession;
  static Rx<bool> get hasSelected => to._hasSelected;

  // Properties
  final _hasSelected = false.obs;
  final _hasSession = false.obs;
  final _incomingMedia = <SharedMediaFile>[].obs;
  final _incomingText = "".obs;
  final Session _session = Session();

  // References
  late StreamSubscription _externalMediaStream;
  late StreamSubscription _externalTextStream;

  // ^ Constructer ^ //
  Future<SenderService> init() async {
    // @ Setup Mobile
    if (DeviceService.isMobile) {
      ReceiveSharingIntent.getInitialMedia().then((List<SharedMediaFile>? data) {
        if (data != null) {
          _incomingMedia(data);
          _incomingMedia.refresh();
        }
      });
      ReceiveSharingIntent.getInitialText().then((String? text) {
        if (text != null) {
          _incomingText(text);
          _incomingText.refresh();
        }
      });

      // Listen to Incoming Text/File
      _externalTextStream = ReceiveSharingIntent.getTextStream().listen(_handleSharedText);
      _externalMediaStream = ReceiveSharingIntent.getMediaStream().listen(_handleSharedFiles);
    }
    return this;
  }

  // ^ Dispose Closer ^ //
  @override
  void onClose() {
    _externalMediaStream.cancel();
    _externalTextStream.cancel();
    super.onClose();
  }

  // * ------------------- Methods ----------------------------
  /// #### Checks for Initial Media/Text to Share
  static checkInitialShare() async {
    if (DeviceService.isMobile && isRegistered) {
      // @ Check for Media
      if (to._incomingMedia.length > 0 && !Get.isBottomSheetOpen!) {
        // Open Sheet
        await Get.bottomSheet(ShareSheet.media(to._incomingMedia), isDismissible: false);

        // Reset Incoming
        to._incomingMedia.clear();
        to._incomingMedia.refresh();
      }

      // @ Check for Text
      if (to._incomingText.value != "" && GetUtils.isURL(to._incomingText.value) && !Get.isBottomSheetOpen!) {
        var data = await NodeService.getURL(to._incomingText.value);
        // Open Sheet
        await Get.bottomSheet(ShareSheet.url(data), isDismissible: false);

        // Reset Incoming
        to._incomingText("");
        to._incomingText.refresh();
      }
    }
  }

  /// Method to Choose Option to Share
  static Future<InviteRequest?> choose(ChooseOption option, {SFile? file}) async {
    if (isRegistered) {
      // Check for Provided File
      if (file != null) {
        return await to._handlePayload(file.payload, file: file);
      }
      // Continue with Picker
      else {
        // Handle Request
        switch (option) {
          case ChooseOption.Camera:
            return await to._handleCameraChoice();
          case ChooseOption.Contact:
            return await to._handleContactChoice();
          case ChooseOption.Media:
            return await to._handleMediaChoice();
          case ChooseOption.File:
            return await to._handleFileChoice();
        }
      }
    }
  }

  /// #### Sends Invite Link Request with Peer
  static void link(Peer peer, String shortID) {
    NodeService.instance.link(
      LinkRequest(to: peer, type: LinkRequest_Type.SEND, shortID: shortID),
    );
  }

  /// #### Send Invite with Peer
  static Session? invite(InviteRequest request, {bool isLocal = true}) {
    // Verify Request
    if (!request.payload.isNone && request.hasTo()) {
      // Analytics
      Logger.event(event: AppEvent.invited(request));
      Logger.info("Invited: ${request.to.active.id.peer}");

      // Send Invite
      NodeService.instance.invite(request);
      to._session.outgoing(request);
      to._hasSession(true);
      return to._session;
    } else {
      Logger.error("Invite Request is Invalid");
    }
    return null;
  }

  // * ------------------- Callbacks ----------------------------
  /// Peer has Responded
  void handleReply(InviteResponse data) async {
    // Logging
    Logger.event(event: AppEvent.responded(data));
    Logger.info("Node(Callback) Responded: " + data.toString());

    // Handle Contact Response
    if (data.payload == Payload.CONTACT) {
      await HapticFeedback.heavyImpact();

      // Check if Flat Mode
      data.type == InviteResponse_Type.FLAT ? AppPage.Flat.response(data.transfer.contact) : data.show();
    }

    // For Transfer
    else if (data.payload.isTransfer) {
      _session.onReply(data);
    }
  }

  /// User has shared file succesfully
  void handleTransmitted(Transfer data) async {
    // Check for Callback
    _session.onComplete(data);

    // Feedback
    await Sound.Transmitted.play();
    await HapticFeedback.heavyImpact();

    // Logging Activity
    CardService.addActivity(
      payload: data.payload,
      file: data.file,
      type: ActivityType.Shared,
    );

    // Logging
    Logger.info("Node(Callback) Transmitted: " + data.toString());
    _session.reset();
    _hasSession(false);
    _hasSelected(false);
  }

  // * ------------------- Helpers ----------------------------
  // @ Helper: Handles CAMERA Choice
  Future<InviteRequest?> _handleCameraChoice() async {
    if (DeviceService.isMobile) {
      // Move to View
      AppRoute.camera(onMediaSelected: (SFile file) async {
        var result = await _handlePayload(Payload.MEDIA, file: file);

        // Complete Result
        return result;
      });
    }
    return null;
  }

  // @ Helper: Handles CONTACT Choice
  Future<InviteRequest?> _handleContactChoice() async {
    return await _handlePayload(Payload.CONTACT);
  }

  // @ Helper: Handles FILE Choice
  Future<InviteRequest?> _handleFileChoice() async {
    // Load Picker
    FilePickerResult? result = await FilePicker.platform.pickFiles(allowMultiple: true);
    if (result != null) {
      // Confirm File
      var file = result.toSFile(payload: Payload.FILE);
      return await _handlePayload(file.payload, file: file);
    }
  }

  // @ Helper: Handles MEDIA Choice
  Future<InviteRequest?> _handleMediaChoice() async {
    if (DeviceService.isMobile) {
      // Load Picker
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.media,
        withData: true,
        allowMultiple: true,
        allowCompression: true,
      );

      // Check File
      if (result != null) {
        // Convert To File
        var file = result.toSFile(payload: Payload.MEDIA);
        return await _handlePayload(file.payload, file: file);
      }
    }
  }

  /// #### Helper: Creates Invite Request from Payload
  Future<InviteRequest> _handlePayload(Payload payload, {SFile? file, String? url}) async {
    // Initialize
    _hasSelected(true);
    InviteRequest invite = InviteRequest();

    // @ Handle Payload
    if (payload.isTransfer && file != null) {
      // Check valid File Size Payload
      if (file.size > 0) {
        file.update();
        invite.setFile(file);

        // Check for Media
        if (invite.payload.isMedia) {
          // Set File Item
          await file.setThumbnail();
        }
      }
    }
    // Check for Contact
    else if (payload == Payload.CONTACT) {
      // Initialize Contact
      invite.setContact(ContactService.contact.value);
    }
    // Check for URL
    else if (payload == Payload.URL) {
      // Initialize URL
      invite.setUrl(url!);
    }
    return invite;
  }

  // # Saves Received Media to Gallery
  _handleSharedFiles(List<SharedMediaFile> data) async {
    if (!Get.isBottomSheetOpen!) {
      await Get.bottomSheet(ShareSheet.media(data), isDismissible: false);
    }
  }

  // # Saves Received Media to Gallery
  _handleSharedText(String text) async {
    if (!Get.isBottomSheetOpen! && GetUtils.isURL(text)) {
      // Get Data
      var data = await NodeService.getURL(text);

      // Open Sheet
      await Get.bottomSheet(ShareSheet.url(data), isDismissible: false);
    }
  }
}
