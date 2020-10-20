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
  double _progress;

  // ** Constructer ** //
  SonrFile({this.metadata, this.file}) {
    // Set Progress Variables
    this._progress = 0.0;
    this._currentChunkNum = 0;
    this._remainingChunks = this.metadata.chunksTotal;

    // Generate MetaData from Raw File
    if (this.file != null) {
      this.metadata = Metadata.fromFile(file);
    }
  }

  // ** Update Progress ** //
  addProgress(DataBloc d, Role role) {
    // Increase Current Chunk
    this._currentChunkNum += 1;
    var total = this.metadata.chunksTotal;

    // Find Remaining
    this._remainingChunks = total - this._currentChunkNum;

    // Calculate Progress
    this._progress = (total - this._remainingChunks) / total;

    // Logging
    log.i(enumAsString(role) +
        "Current= " +
        this._currentChunkNum.toString() +
        ". Remaining= " +
        this._remainingChunks.toString() +
        "-- " +
        (this._progress * 100).toString() +
        "%");

    // Update Cubit
    d.progress.update(this._progress);
  }

  // ** Save Bytes to File ** //
  save(Uint8List data, String path) async {
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

  // ** Check if Both Fields Provided ** //
  bool isComplete() {
    return file != null && metadata != null;
  }
}
