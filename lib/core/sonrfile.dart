import 'package:sonar_app/bloc/bloc.dart';
import 'package:sonar_app/core/core.dart';
import 'package:sonar_app/models/models.dart';
import 'package:sonar_app/repository/repository.dart';

// **************************** //
// ** Holds Metadata and Raw ** //
// **************************** //
class SonrFile {
  // Accessor Methods
  File file;
  Metadata metadata;

  // Progress Variables
  int _remainingChunks;
  int _currentChunkNum;
  double progress;

  // ** Constructer ** //
  SonrFile({this.metadata, this.file}) {
    // Generate MetaData from Raw File
    if (this.file != null) {
      this.metadata = new Metadata();
      // Calculate File Info
      this.metadata.size = file.lengthSync();
      this.metadata.chunksTotal = (file.lengthSync() / CHUNK_SIZE).ceil();

      // Set File Info
      this.metadata.path = file.path;
      this.metadata.name = basename(this.metadata.path);
      this.metadata.type = getFileTypeFromPath(this.metadata.path);
    }

    // Set Progress Variables
    this.progress = 0.0;
    this._currentChunkNum = 0;
    this._remainingChunks = this.metadata.chunksTotal;
  }

  // ** Update Progress ** //
  addProgress(DataBloc d) {
    // Increase Current Chunk
    var total = this.metadata.chunksTotal;
    this._currentChunkNum += 1;

    // Find Remaining
    this._remainingChunks = total - this._currentChunkNum;

    // Calculate Progress
    this.progress = (total - this._remainingChunks) / total;

    // Update Cubit
    d.progress.update(this.progress);
  }

  // ** Save Bytes to File ** //
  save(Uint8List data) async {
    // Get FilePath
    Directory tempDir = await getTemporaryDirectory();
    var path = tempDir.path + '/file_01.tmp';

    // Set Path
    this.metadata.path = path;
    this.metadata.received = DateTime.now();

    // Get Buffer
    final buffer = data.buffer;

    // Save to File
    this.file = await new File(path).writeAsBytes(
        buffer.asUint8List(data.offsetInBytes, data.lengthInBytes));

    // Return
    return this;
  }

  // ** Read Bytes from SonrFile **
  Future<Uint8List> getBytes() async {
    Uint8List bytes;
    await this.file.readAsBytes().then((value) {
      bytes = Uint8List.fromList(value);
    }).catchError((onError) {
      log.e("Error Reading Bytes");
    });
    return bytes;
  }

  // ** Check if Progress Complete **
  bool isProgressComplete() {
    if (this.progress.round() == 100) {
      return true;
    }
    return false;
  }
}
