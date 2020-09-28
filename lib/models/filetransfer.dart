import 'package:path/path.dart';
import 'package:sonar_app/bloc/bloc.dart';
import 'package:sonar_app/core/core.dart';
import 'package:sonar_app/repository/repository.dart';

class FileTransfer {
  // Default Properties
  int size;
  String name;
  FileType type;

  // Transfer Variables
  File file;

  // Chunking Variables
  int chunksTotal;
  int currentChunkNum;
  int remainingChunks;
  double progress;
  double lastProgress;

  // Constructor
  FileTransfer({String info, File localFile}) {
    // Initialize
    currentChunkNum = 0;
    lastProgress = 0.0;
    progress = 0.0;

    // File is being Transmitted
    if (localFile != null) {
      // Set Properties
      file = localFile;
      type = getFileTypeFromPath(localFile.path);
      name = basename(file.path);
      size = file.lengthSync();

      // Set Total Chunks
      var temp = size / CHUNK_SIZE;
      chunksTotal = temp.ceil();
      remainingChunks = chunksTotal;

      log.i("FileTransfer Created");
    }
    // File is being Received
    else {
      // Info Provided
      if (info != null) {
        // Convert to Map
        var infoData = json.decode(info);

        // Set File Properties
        size = infoData["size"];
        name = infoData["name"];
        chunksTotal = infoData["chunksTotal"];

        // Set Type from String
        type =
            FileType.values.firstWhere((e) => e.toString() == infoData["type"]);
      }
      log.e("No File or Info Provided");
    }
  }

  getInfo() {
    // Return as JSON Map
    return json.encode({
      "size": size,
      "name": name,
      "type": type.toString(),
      "chunksTotal": chunksTotal
    });
  }
}
