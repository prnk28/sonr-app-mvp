import 'dart:io';
import 'package:get/get.dart';
import 'package:sonar_app/data/model_card.dart';
import 'package:sonar_app/service/sonr_service.dart';
import 'package:sonar_app/service/sql_service.dart';
import 'package:flutter/services.dart';
import 'package:sonar_app/theme/theme.dart';
import 'package:sonr_core/models/models.dart';
import 'package:image_picker/image_picker.dart';

enum ToggleFilter { All, Media, Contact }

class HomeController extends GetxController {
  // Properties
  final cards = List<CardModel>().obs;
  final allCards = List<CardModel>().obs;
  // final contactCards = List<CardModel>().obs;
  // final mediaCards = List<CardModel>().obs;

  // Widget Elements
  final isExpanded = false.obs;
  final pageIndex = 0.obs;
  final toggleIndex = 0.obs;

  // References
  final category = Rx<ToggleFilter>(ToggleFilter.All);
  final imagePicker = ImagePicker();

  @override
  void onInit() {
    // Fetch File Data
    Get.find<SQLService>().fetchFiles().then((data) {
      data.forEach((m) => allCards.add(CardModel.fromMetaSQL(m)));
      // data.forEach((m) => mediaCards.add(CardModel.fromMetaSQL(m)));
    });

    // Fetch Contact Data
    Get.find<SQLService>().fetchContacts().then((data) {
      data.forEach((c) => allCards.add(CardModel.fromContactSQL(c)));
      // data.forEach((c) => contactCards.add(CardModel.fromContactSQL(c)));
    });

    // Refresh Cards
    allCards.refresh();
    super.onInit();
  }

  // HomeController() {
  //   category.listen((cat) {
  //     switch (cat) {
  //       case ToggleFilter.All:
  //         cards(allCards);
  //         cards.refresh();
  //         break;
  //       case ToggleFilter.Media:
  //         cards(mediaCards);
  //         cards.refresh();
  //         break;
  //       case ToggleFilter.Contact:
  //         cards(contactCards);
  //         cards.refresh();
  //         break;
  //     }
  //   });
  // }

  // ^ Helper Method for Category Filter ^ //
  SonrText getToggleCategory() {
    if (toggleIndex.value == 0) {
      category(ToggleFilter.All);
      return SonrText.normal("All");
    } else if (toggleIndex.value == 1) {
      category(ToggleFilter.Media);
      return SonrText.normal("Media");
    } else {
      category(ToggleFilter.Contact);
      return SonrText.normal("Contact");
    }
  }

  // ^ Toggles Expanded Share Button ^ //
  void toggleShareExpand() {
    HapticFeedback.heavyImpact();
    isExpanded(!isExpanded.value);
  }

  // ^ Opens Camera Picker ^ //
  void openCamera() async {
    // Show Picker
    final pickedFile = await imagePicker.getImage(source: ImageSource.camera);

    // Retreive File and Process
    if (pickedFile != null) {
      // Queue
      Get.find<SonrService>()
          .process(Payload.FILE, file: File(pickedFile.path));

      // Close Share Button
      Get.find<HomeController>().toggleShareExpand();

      // Go to Transfer
      Get.offNamed("/transfer");
    }
  }

  // ^ Opens File Picker ^ //
  void openPicker() async {
    // Show Picker
    final pickedFile = await imagePicker.getImage(source: ImageSource.gallery);

    // Retreive File and Process
    if (pickedFile != null) {
      // Queue
      Get.find<SonrService>()
          .process(Payload.FILE, file: File(pickedFile.path));

      // Close Share Button
      Get.find<HomeController>().toggleShareExpand();

      // Go to Transfer
      Get.offNamed("/transfer");
    }
  }

  // ^ Queues a Contact for Transfer ^ //
  void queueContact() {
    Get.find<SonrService>().process(Payload.CONTACT);

    // Close Share Button
    Get.find<HomeController>().toggleShareExpand();

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
