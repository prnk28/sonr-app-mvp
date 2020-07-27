import 'package:sonar_app/bloc/bloc.dart';
import 'package:sonar_app/bloc/sonar/sonar_bloc.dart';
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
  int chunkNum;
  double progress;
  bool completed;

  // Constructor
  TransferFile({dynamic info, File localFile}) {
    // Initialize
    completed = false;
    chunkNum = 0;
    progress = 0.0;
    block = new BytesBuilder();

    // File is being Transmitted
    if (localFile != null) {
      // Set Properties
      file = localFile;
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
      block.add(chunk);

      // Set Remaining Chunks
      var remainingChunks = chunksTotal - chunkNum;

      // Check completed
      if (remainingChunks == 0) {
        log.i("Transfer Complete");
      }
    }
  }

  complete(SonarBloc bloc) async {
    // Set Completed true
    completed = true;

    // Convert to Uint8List
    Uint8List data = block.takeBytes();
    File file = await writeToFile(data, "file");
    bloc.add(Received(file));
  }

  updateChunkInfo(dynamic chunkInfo) {
    // Set Chunk Info
    chunkNum = chunkInfo["receivedChunkNum"];
    chunksTotal = chunkInfo["chunksTotal"];

    // Log info
    log.i("Chunk Num: " +
        chunkNum.toString() +
        " >-----> " +
        "Chunk Total: " +
        chunksTotal.toString());
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
      "chunksTotal": chunksTotal,
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
