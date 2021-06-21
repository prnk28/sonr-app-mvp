import 'dart:async';
import 'package:file_picker/file_picker.dart';
import 'package:receive_sharing_intent/receive_sharing_intent.dart';
import 'package:sonr_app/data/services/services.dart';
import 'package:sonr_app/style.dart';

class SenderService extends GetxService {
  // Accessors
  static bool get isRegistered => Get.isRegistered<SenderService>();
  static SenderService get to => Get.find<SenderService>();

  // @ Properties
  final _hasSession = false.obs;
  final _incomingMedia = <SharedMediaFile>[].obs;
  final _incomingText = "".obs;
  final Session _session = Session();

  /// Returns Current Session
  static Session get session => to._session;
  static Rx<bool> get hasSession => to._hasSession;

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

  @override
  void onClose() {
    _externalMediaStream.cancel();
    _externalTextStream.cancel();
    super.onClose();
  }

  // * ------------------- Methods ----------------------------
  /// @ Checks for Initial Media/Text to Share
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
  static Future<InviteRequest?> choose(ChooseOption option, {SonrFile? file}) async {
    if (isRegistered) {
      // Log Choice
      option.logChoice();

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
            return await to._handleFileChoice();
          case ChooseOption.File:
            return await to._handleMediaChoice();
        }
      }
    }
  }

  /// @ Send Invite with Peer
  static Session? invite(InviteRequest request) {
    // Verify Request
    if (!request.payload.isNone && request.hasTo()) {
      // Analytics
      Logger.event(
        name: 'selectedPeer',
        controller: 'SenderService',
        parameters: {
          'peerPlatform': request.to.platform.toString(),
        },
      );

      // Send Invite
      NodeService.to.node.invite(request);
      to._session.outgoing(request);
      return to._session;
    }
    return null;
  }

  // * ------------------- Callbacks ----------------------------
  /// Peer has Responded
  void handleReply(InviteResponse data) async {
    // Logging
    Logger.info("Node(Callback) Responded: " + data.toString());

    // Handle Contact Response
    if (data.type == InviteResponse_Type.Contact) {
      await HapticFeedback.heavyImpact();

      // Check if Flat Mode
      data.flatMode ? AppPage.Flat.response(data.transfer.contact) : data.show();
    }

    // For Cancel
    else if (data.type == InviteResponse_Type.Cancel) {
      await HapticFeedback.vibrate();
    } else {
      _session.onReply(data);
    }
  }

  /// User has shared file succesfully
  void handleTransmitted(Transfer data) async {
    // Check for Callback
    _session.onComplete(data);

    // Feedback
    DeviceService.playSound(type: Sounds.Transmitted);
    await HapticFeedback.heavyImpact();

    // Logging Activity
    CardService.addActivity(
      payload: data.payload,
      file: data.file,
      type: ActivityType.Shared,
    );

    // Logging
    Logger.info("Node(Callback) Transmitted: " + data.toString());
    _hasSession(false);
    _session.reset();
  }

  // * ------------------- Helpers ----------------------------
  // @ Helper: Handles CAMERA Choice
  Future<InviteRequest?> _handleCameraChoice() async {
    if (DeviceService.isMobile) {
      // Move to View
      CameraView.open(onMediaSelected: (SonrFile file) async {
        var result = await _handlePayload(Payload.MEDIA, file: file);

        // Analytics
        ChooseOption.Camera.logConfirm();

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
    if (DeviceService.isMobile) {
      FilePickerResult? result = await FilePicker.platform.pickFiles(allowMultiple: true);
      if (result != null) {
        // Analytics
        if (DeviceService.isMobile) {
          ChooseOption.File.logConfirm();
        }

        // Confirm File
        var file = result.toSonrFile(payload: Payload.FILE);
        return await _handlePayload(file.payload, file: file);
      } else {
        var filePath = await NodeService.to.node.pickFile();
        var file = SonrFile(payload: Payload.FILE, items: [SonrFile_Item(path: filePath)], count: 1);
        if (filePath != null) {
          return await _handlePayload(file.payload, file: file);
        }
      }
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
        // Analytics
        if (DeviceService.isMobile) {
          ChooseOption.Media.logConfirm();
        }
        // Convert To File
        var file = result.toSonrFile(payload: Payload.MEDIA);
        return await _handlePayload(file.payload, file: file);
      }
    }
  }

  /// @ Helper: Creates Invite Request from Payload
  Future<InviteRequest> _handlePayload(Payload payload, {SonrFile? file, String? url}) async {
    // Initialize
    InviteRequest invite = InviteRequest();

    // @ Handle Payload
    if (payload.isTransfer && file != null) {
      // Capture File Analytics
      ChooseOption.File.logShared(file: file);

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
      // Capture Analytics
      ChooseOption.Contact.logShared();

      // Initialize Contact
      invite.setContact(ContactService.contact.value);
    }
    // Check for URL
    else if (payload == Payload.URL) {
      // Capture Contact Analytics
      Logger.event(
        name: 'sharedURL',
        controller: 'SenderService',
        parameters: {
          'link': url,
          'payload': Payload.URL.toString(),
        },
      );

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