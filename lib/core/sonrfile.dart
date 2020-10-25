import 'package:sonar_app/bloc/bloc.dart';
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
  final RTCDataChannel _channel;
  BytesBuilder _writer;

  // ** Constructer ** //
  SonrFile(this._channel, this.owner, {this.metadata, this.file}) {
    // Generate MetaData from Raw File
    if (this.file != null) {
      // Get Metadata
      this.metadata = new Metadata(file: file);
    } else {
      // Initialize Writer for File
      _writer = new BytesBuilder();
    }

    // Set Progress Variables
    this.currentChunkNum = 0;
    this.remainingChunks = this.metadata.chunksTotal;
  }

  // ** Chunk Receiver from Data Channel ** //
  double addChunk(Uint8List chunk) {
    // Add to Builder and Update Progress
    _writer.add(chunk);
    var currProgress = progress();

    // Check if Complete
    if (this.isComplete()) {
      // Request next chunk
      _channel.send(RTCDataChannelMessage("NEXT_CHUNK"));
    } else {
      // Tell Sender Complete
      _channel.send(RTCDataChannelMessage("SEND_COMPLETE"));
    }

    // Return Progress
    return currProgress;
  }

  // ** Chunk Receiver from Data Channel ** //
  Future<double> sendChunk() async {
    // Get Start/End Byte Number
    int start = currentChunkNum * CHUNK_SIZE;
    int end = start + CHUNK_SIZE;

    // End Of List
    if (remainingChunks > 0) {
      // Read Specified Bytes
      RandomAccessFile raf = file.openSync(mode: FileMode.read);
      raf.setPositionSync(start);
      Uint8List chunk = raf.readSync(end);

      // Send on Channel
      _channel.send(RTCDataChannelMessage.fromBinary(chunk));
    }

    // Update Progress
    return progress();
  }

  // ** Update Progress ** //
  double progress() {
    // Increase Current Chunk
    var total = this.metadata.chunksTotal;
    this.currentChunkNum += 1;

    // Find Remaining
    this.remainingChunks = total - this.currentChunkNum;

    // Log Chunks Remaining
    log.i("Remaining Chunks: " + this.remainingChunks.toString());

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
