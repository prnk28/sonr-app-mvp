import 'package:sonar_app/core/core.dart';
import 'package:sonar_app/data/data.dart';

// *****************************
// ** Download File from URL ***
// *****************************
downloadFile(String url, {String filename}) async {
  var httpClient = Client();
  var request = new Request('GET', Uri.parse(url));
  var response = httpClient.send(request);
  String dir = (await getApplicationDocumentsDirectory()).path;

  List<List<int>> chunks = new List();
  int downloaded = 0;

  response.asStream().listen((StreamedResponse r) {
    r.stream.listen((List<int> chunk) {
      // Display percentage of completion
      log.v('downloadPercentage: ${downloaded / r.contentLength * 100}');

      chunks.add(chunk);
      downloaded += chunk.length;
    }, onDone: () async {
      // Display percentage of completion
      log.v('downloadPercentage: ${downloaded / r.contentLength * 100}');

      // Save the file
      File file = new File('$dir/$filename');
      final Uint8List bytes = Uint8List(r.contentLength);
      int offset = 0;
      for (List<int> chunk in chunks) {
        bytes.setRange(offset, offset + chunk.length, chunk);
        offset += chunk.length;
      }
      await file.writeAsBytes(bytes);
      return;
    });
  });
}

// ********************************
// ** Read Local Data of Assets ***
// ********************************
Future<Uint8List> getBytesFromPath(String path) async {
  Uri myUri = Uri.parse(path);
  File audioFile = new File.fromUri(myUri);
  Uint8List bytes;
  await audioFile.readAsBytes().then((value) {
    bytes = Uint8List.fromList(value);
    log.i('reading of bytes is completed');
  }).catchError((onError) {
    log.w(
        'Exception Error while reading audio from path:' + onError.toString());
  });
  return bytes;
}

// ****************************************
// ** Get File Object from Assets Folder **
// ****************************************
Future<File> getAssetFileByPath(String path) async {
  // Get Application Directory
  Directory directory = await getApplicationDocumentsDirectory();

  // Get File Extension and Set Temp DB Extenstion
  var dbPath = join(directory.path, "temp" + extension(path));

  // Get Byte Data
  ByteData data = await rootBundle.load(path);

  // Get Bytes as Int
  List<int> bytes =
      data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);

  // Return File Object
  return await File(dbPath).writeAsBytes(bytes);
}
