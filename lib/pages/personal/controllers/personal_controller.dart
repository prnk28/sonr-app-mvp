import 'dart:io';
import 'package:camerawesome/camerawesome_plugin.dart';
import 'package:sonr_app/style/style.dart';
import 'package:get/get.dart';
import 'package:sonr_plugin/sonr_plugin.dart';
import '../models/status.dart';
import '../views/add/add_social.dart';

class PersonalController extends GetxController {
  // Properties
  final status = PersonalViewStatus.Viewing.obs;
  // final focused = FocusedTile(-1, false).obs;
  final options = Contact_Social_Media.values;
  final dropdownIndex = (-1).obs;

  // Edited Values
  final editedFirstName = RxString(ContactService.contact.value.firstName);
  final editedLastName = RxString(ContactService.contact.value.lastName);
  final editedPhone = RxString("");

  // Tile Management
  // final step = Rx<TileStep?>(null);
  final cardSelection = ValueNotifier<int>(0);

  // Notifiers
  ValueNotifier<CaptureModes> captureMode = ValueNotifier(CaptureModes.PHOTO);
  ValueNotifier<Size> photoSize = ValueNotifier(Size(142, 142));
  ValueNotifier<Sensors> sensor = ValueNotifier(Sensors.FRONT);

  // Properties
  final result = Rx<File?>(null);

  // References
  late final PictureController _pictureController;

  // ** Initialize Method ** //
  onInit() async {
    _pictureController = PictureController();
    super.onInit();
  }

  /// #### Method to Capture Picture
  captureAvatar() async {
    // Set Path
    var temp = await getApplicationDocumentsDirectory();
    var photoDir = await Directory('${temp.path}/photos').create(recursive: true);
    var path = '${photoDir.path}/${DateTime.now().millisecondsSinceEpoch}.jpg';

    // Capture Photo
    await _pictureController.takePicture(path);
    result(File(path));
    status(PersonalViewStatus.ViewPicture);
  }

  /// #### Method to Confirm New Picture
  confirmAvatar() async {
    if (result.value != null) {
      ContactService.contact.setPicture(result.value!.readAsBytesSync());
    }
    exitToViewing();
  }

  /// #### Start Editing Picture
  void setAddPicture() {
    HapticFeedback.heavyImpact();
    status(PersonalViewStatus.AddPicture);
  }

  /// #### Start Editing for Social Tile
  void setAddTile() {
    HapticFeedback.heavyImpact();
    // step(TileStep(nextStep, previousStep, saveTile));
    Get.dialog(AddTileView(), barrierDismissible: false);
  }

  /// #### End Add/Edit State
  void exitToViewing() {
    HapticFeedback.mediumImpact();
    status(PersonalViewStatus.Viewing);
  }

  /// #### Completed Editing Details
  void saveEditedDetails() {
    // Update Values in Profile Controller
    ContactService.contact.setFirstName(editedFirstName.value);
    ContactService.contact.setLastName(editedLastName.value);
    ContactService.contact.addPhone(editedPhone.value);
    status(PersonalViewStatus.Viewing);
  }

  // @ Method to Request Camera Permissions
  requestCamera() async {
    if (DeviceService.isMobile) {
      status(PersonalViewStatusUtils.statusFromPermissions(await Permissions.Camera.request()));
    }
  }
}
