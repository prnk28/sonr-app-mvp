import 'dart:io';
import 'package:get/get.dart';
import 'package:sonar_app/data/model_card.dart';
import 'package:sonar_app/service/sonr_service.dart';
import 'package:sonar_app/service/sql_service.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sonr_core/models/models.dart';

class HomeController extends GetxController {
  // Properties
  RxList<CardModel> allCards = List<CardModel>().obs;

  // ^ Retreives Cards from SQL Service ^ //
  void fetch() async {
    // Fetch File Data
    Get.find<SQLService>().fetchFiles().then(
        (data) => data.forEach((m) => allCards.add(CardModel.fromMetaSQL(m))));

    // Fetch Contact Data
    Get.find<SQLService>().fetchContacts().then((data) =>
        data.forEach((c) => allCards.add(CardModel.fromContactSQL(c))));
    allCards.refresh();
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

  // @ Testing Purposes File Transfer
  void queueTest() async {
    // Get Test File Path
    File file = await _getAssetFileByPath("assets/images/test.jpg");

    // Queue File
    Get.find<SonrService>().queue(Payload_Type.FILE, file: file);

    // Go to Transfer
    Get.offNamed("/transfer");
  }

  // @ Testing Purposes Large File Transfer
  void queueFatTest() async {
    // Get Test File Path
    File testFile = await _getAssetFileByPath("assets/images/fat_test.jpg");

    // Queue File
    Get.find<SonrService>().queue(Payload_Type.FILE, file: testFile);

    // Go to Transfer
    Get.offNamed("/transfer");
  }

  // ^ Queues a Contact for Transfer ^ //
  void queueContact() {
    Get.find<SonrService>().queue(Payload_Type.CONTACT);

    // Go to Transfer
    Get.offNamed("/transfer");
  }

  // ^ Converts File in Assets to File Object ^ //
  Future<File> _getAssetFileByPath(String path) async {
    var directory = await getApplicationDocumentsDirectory();
    var dbPath = join(directory.path, basename(path));
    var data = await rootBundle.load(path);
    var bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
    return await File(dbPath).writeAsBytes(bytes);
  }
}
