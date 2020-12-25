import 'dart:io';
import 'package:get/get.dart';
import 'package:sonar_app/data/model_card.dart';
import 'package:sonar_app/service/sql_service.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

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

  // ^ Converts File in Assets to File Object ^ //
  Future<File> getAssetFileByPath(String path) async {
    var directory = await getApplicationDocumentsDirectory();
    var dbPath = join(directory.path, basename(path));
    var data = await rootBundle.load(path);
    var bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
    return await File(dbPath).writeAsBytes(bytes);
  }
}
