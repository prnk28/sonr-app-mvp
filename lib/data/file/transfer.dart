import 'package:sonar_app/core/core.dart';
import 'package:sonar_app/data/data.dart';

class TransferFile {
  // Default Properties
  int size;
  String name;
  FileType type;
  int chunksTotal;

  // Transfer Variables
  File file;
  BytesBuilder block;

  // Chunking Variables
  int currentChunkNum;
  int remainingChunks;
  double progress;

  // Constructor
  TransferFile({dynamic info, File localFile}) {
    // Initialize
    currentChunkNum = 0;
    progress = 0.0;
    block = new BytesBuilder();

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
    }
    // File is being Received
    else {
      // Info Provided
      if (info != null) {
        // Set File Properties
        size = info["size"];
        name = info["name"];
        chunksTotal = info["chunksTotal"];

        // Set Type from String
        type = FileType.values.firstWhere((e) => e.toString() == info["type"]);
      }
      log.e("No File or Info Provided");
    }
  }

  addChunk(Uint8List chunk) {
    // Add Chunk to Block
    block.add(chunk);

    // Update Chunks
    currentChunkNum += 1;
    remainingChunks = chunksTotal - currentChunkNum;

    // Update Progress
    progress = (chunksTotal - remainingChunks) / chunksTotal;

    // Log Progress
    log.i("Receive Progress: " + (progress * 100).toString() + "%");
  }

  updateChunkInfo() {
    // Set Variables
    currentChunkNum = currentChunkNum += 1;
    remainingChunks = chunksTotal - currentChunkNum;

    // Update Progress
    progress = (chunksTotal - remainingChunks) / chunksTotal;

    // Log Progress
    log.i("Send Progress: " + (progress * 100).toString() + "%");
  }

  getInfo() {
    // Return as JSON Map
    return {
      "size": size,
      "name": name,
      "type": type.toString(),
      "chunksTotal": chunksTotal
    };
  }
}
