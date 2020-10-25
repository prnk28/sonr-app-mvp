import 'package:sonar_app/core/core.dart';
import 'package:sonar_app/models/models.dart';
import 'package:sonar_app/repository/repository.dart';

// * Chunking Constants **
const CHUNK_SIZE = 16000;
const CHUNKS_PER_ACK = 64;

// **************************** //
// ** Holds Metadata and Raw ** //
// **************************** //
class SonrFile {
  // Identity
  Node owner;

  // Accessor Methods
  File file;
  Metadata metadata;

  // Progress Variables
  int remainingChunks;
  int currentChunkNum;

  // Transmission
  BytesBuilder _writer;

  // ** Constructer ** //
  SonrFile(this.owner, {this.metadata, this.file}) {
    // Generate MetaData from Raw File
    if (this.file != null) {
      // Init Metadata
      this.metadata = new Metadata();

      // Calculate File Info
      this.metadata.size = file.lengthSync();
      this.metadata.chunksTotal = (file.lengthSync() / CHUNK_SIZE).ceil();

      // Set File Info
      this.metadata.path = file.path;
      this.metadata.name = basename(this.metadata.path);
      this.metadata.type = getFileTypeFromPath(this.metadata.path);
    } else {
      // Initialize Writer for File
      _writer = new BytesBuilder();
    }

    // Set Progress Variables
    this.currentChunkNum = 0;
    this.remainingChunks = this.metadata.chunksTotal;
  }

  // ** Chunk Received from Data Channel ** //
  addChunk(Uint8List chunk) {
    // Add to Builder and Update Progress
    _writer.add(chunk);
  }

  // ** Update Progress ** //
  double progress() {
    // Increase Current Chunk
    var total = this.metadata.chunksTotal;
    this.currentChunkNum += 1;

    // Find Remaining
    this.remainingChunks = total - this.currentChunkNum;

    // Calculate Progress
    return (total - this.remainingChunks) / total;
  }

  // ** Save Bytes to File ** //
  save() async {
    // Get Data
    Uint8List data = _writer.takeBytes();

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
  bool isComplete() {
    return (this.remainingChunks == 0);
  }
}
