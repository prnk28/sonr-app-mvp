import 'dart:io';
import 'package:get/get.dart';
import 'package:sonar_app/data/model_card.dart';
import 'package:sonar_app/service/sonr_service.dart';
import 'package:sonar_app/service/sql_service.dart';
import 'package:flutter/services.dart';
import 'package:sonr_core/models/models.dart';
import 'package:image_picker/image_picker.dart';

class HomeController extends GetxController {
  // Properties
  final allCards = List<CardModel>().obs;
  final isShareExpanded = false.obs;
  final imagePicker = ImagePicker();

  @override
  void onInit() {
    // Fetch File Data
    Get.find<SQLService>().fetchFiles().then(
        (data) => data.forEach((m) => allCards.add(CardModel.fromMetaSQL(m))));

    // Fetch Contact Data
    Get.find<SQLService>().fetchContacts().then((data) =>
        data.forEach((c) => allCards.add(CardModel.fromContactSQL(c))));
    allCards.refresh();

    super.onInit();
  }

  // ^ Toggles Expanded Share Button ^ //
  void toggleExpand() {
    HapticFeedback.heavyImpact();
    isShareExpanded(!isShareExpanded.value);
  }

  // ^ Opens File Picker ^ //
  void openCamera() async {
    // Show Picker
    final pickedFile = await imagePicker.getImage(source: ImageSource.camera);

    // Retreive File and Process
    if (pickedFile != null) {
      // Queue
      Get.find<SonrService>()
          .process(Payload.FILE, file: File(pickedFile.path));

      // Go to Transfer
      Get.offNamed("/transfer");
    }
  }

  // ^ Opens File Picker ^ //
  void openFilePicker() async {
    // Show Picker
    final pickedFile = await imagePicker.getImage(source: ImageSource.gallery);

    // Retreive File and Process
    if (pickedFile != null) {
      Get.find<SonrService>()
          .process(Payload.FILE, file: File(pickedFile.path));

      // Go to Transfer
      Get.offNamed("/transfer");
    }
  }

  // ^ Queues a Contact for Transfer ^ //
  void queueContact() {
    Get.find<SonrService>().process(Payload.CONTACT);

    // Go to Transfer
    Get.offNamed("/transfer");
  }

  // ^ Adds a Card to Screen ^ //
  void addCard(CardModel card) {
    allCards.add(card);
    allCards.refresh();
  }

  // ^ Opens Card with Hero ^ //
  void openCard(CardModel card) {
    // TODO
  }
}
