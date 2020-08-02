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
  int currentChunkNum;
  int remainingChunks;
  double progress;
  double lastProgress;

  // Constructor
  TransferFile({String info, File localFile}) {
    // Initialize
    currentChunkNum = 0;
    progress = 0.0;
    lastProgress = 0.0;
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

  addChunk(Uint8List chunk, SonarBloc bloc) {
    // Add Chunk to Block
    block.add(chunk);

    // Update Chunks
    currentChunkNum += 1;
    remainingChunks = chunksTotal - currentChunkNum;

    // Update Progress
    progress = (chunksTotal - remainingChunks) / chunksTotal;

    // Log Progress
    log.i("Receive Progress: " + (progress * 100).toString() + "%");

    // Update Progress UI
    //bloc.add(Progress(progress));
  }

  updateChunkInfo(SonarBloc bloc) {
    // Set Variables
    currentChunkNum = currentChunkNum += 1;
    remainingChunks = chunksTotal - currentChunkNum;

    // Update Progress
    progress = (chunksTotal - remainingChunks) / chunksTotal;

    // Update Progress Cubit
    ProgressCubit()
      ..increment(progress - lastProgress)
      ..close();

    // Update Last Progress
    lastProgress = progress;
  }

  writeToDisk() async {
    // Convert Uint8List to File
    Uint8List data = block.takeBytes();

    // Get App Directory
    Directory tempDir = await getApplicationDocumentsDirectory();

    // Save File at Path
    return new File(tempDir.path + this.type.toString() + this.name)
        .writeAsBytes(data);
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
