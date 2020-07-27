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
  Uint8List block;

  // Chunking Variables
  int chunkNum;
  double progress;
  bool completed;

  // Constructor
  TransferFile({dynamic info, File localFile}) {
    // Initialize
    completed = false;
    chunkNum = 0;
    progress = 0.0;

    // File is being Transmitted
    if (localFile != null) {
      // Set Properties
      file = localFile;
      block = null;
      type = getFileTypeFromPath(localFile.path);
      name = basename(file.path);
      size = file.lengthSync();
      chunksTotal = (size / CHUNK_SIZE).ceil();
    }
    // File is being Received
    else {
      // Info Provided
      if (info != null) {
        size = info["size"];
        type = info["type"];
        chunksTotal = info["chunksTotal"];
      }
      log.e("No File or Info Provided");
    }
  }

  addChunk(Uint8List chunk) {
    // Check Completed
    if (!completed) {
      // Add Chunk to Block
      block.addAll(chunk);

      // Set Remaining Chunks
      var remainingChunks = chunksTotal - chunkNum + 1;

      // Set Progress
      progress = (chunksTotal - remainingChunks) / chunksTotal;

      // Check completed
      if (remainingChunks == 0) {
        log.i("Transfer Complete");
      }
    }
  }

  updateChunkInfo(dynamic chunkInfo) {
    chunkNum = chunkInfo["receivedChunkNum"];
  }

  getChunkInfo() {
    // Set Variables
    var remainingChunks = chunksTotal - chunkNum;
    var chunksToSend = [remainingChunks, CHUNKS_PER_ACK].reduce(min);

    // Update Current Chunk Number and Progress
    chunkNum = chunkNum += 1;
    progress = (chunksTotal - remainingChunks) / chunksTotal;

    // Log Progress
    log.i("Send Progress: " + (progress * 100).toString() + "%");

    // Return JSON
    return {
      "remainingChunks": remainingChunks,
      "chunksToSend": chunksToSend,
      "progress": progress,
      "receivedChunkNum": chunkNum
    };
  }

  getInfo() {
    // Return as JSON Map
    return {
      "size": size,
      "name": name,
      "type": type,
      "chunksTotal": chunksTotal
    };
  }
}
