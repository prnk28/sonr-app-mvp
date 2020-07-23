import 'dart:typed_data';
import 'dart:io';

import 'package:http/http.dart';
import 'package:path_provider/path_provider.dart';

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
      print('downloadPercentage: ${downloaded / r.contentLength * 100}');

      chunks.add(chunk);
      downloaded += chunk.length;
    }, onDone: () async {
      // Display percentage of completion
      print('downloadPercentage: ${downloaded / r.contentLength * 100}');

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
