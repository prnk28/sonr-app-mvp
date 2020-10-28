import 'package:sonar_app/core/core.dart';
import 'package:sonar_app/models/models.dart';
import 'package:sonar_app/repository/repository.dart';
import 'package:image/image.dart';
import 'package:file/memory.dart';

// * Chunking Constants **
const CHUNK_SIZE = 65536; // 64 KiB
const CHUNKS_PER_ACK = 64;

// **************************** //
// ** Holds Metadata and Raw ** //
// **************************** //
class SonrFile {
  // Identity
  Node owner;

  // Accessor Methods
  File raw;
  Metadata metadata;

  // Progress Variables
  int totalRemainingChunks;
  int blockRemainingChunks;
  int blocksRemaining;
  int currentChunkNum;
  double progress;

  // Transmission

  IOSink _sink;
  ChunkedStreamIterator<int> _reader;
  List<int> _currentBlock;

  // ** Constructer ** //
  SonrFile(this.owner, {this.metadata, this.raw}) {
    // Generate MetaData from Raw File
    if (this.raw != null) {
      // Init Metadata
      this.metadata = new Metadata(raw);

      // Setup Chunked Stream
      this._reader = ChunkedStreamIterator(raw.openRead());
    }

    // Set Progress Variables
    this.currentChunkNum = 0;
    this.totalRemainingChunks = this.metadata.chunksTotal;
    this.blocksRemaining = this.metadata.blocksTotal;
    this.blockRemainingChunks = min(totalRemainingChunks, CHUNKS_PER_ACK);
  }

  SonrFile.fromSaved(Metadata meta) {
    // Set Required Fields
    this.owner = new Node(meta.owner);
    this.metadata = meta;

    // Create File from Path
    this.raw = new File(meta.path);
  }

  // ** Add chunk to current block ** //
  addChunk(Uint8List chunk) async {
    // Get Bytes
    var bytes = chunk.toList();

    // Add Bytes to Block
    _currentBlock.addAll(bytes);

    // Progress Forward
    this.progress = _updateProgress();
  }

  // ** Setup file for Transfer/Receive ** //
  initialize(Role role) async {
    // ** If Receiver **
    if (role == Role.Receiver) {
      // Get Identifier
      String type = '/' + enumAsString(this.metadata.type);

      // Get Directory - Reset when app deleted
      Directory localDir = await getApplicationDocumentsDirectory();

      // Set Path
      this.metadata.path =
          localDir.path + type + '_' + uuid.v1() + "_" + this.metadata.name;
      this.metadata.received = DateTime.now();
      this.metadata.owner = owner.profile;

      // Create File
      await new File(this.metadata.path).create(recursive: true);

      // Set Sink and Block
      _sink = new File(this.metadata.path).openWrite();
      _currentBlock = new List<int>();
    }
    // ** If Sender **
    else {
      // Create Receive Port
      ReceivePort receivePort = ReceivePort();

      // Compress if Image for Preview
      if (this.metadata.type == FileType.Image) {
        // Isolate to avoid stalling the main UI
        await Isolate.spawn(
            Squeeze.imageForBytes, SqueezeParam(raw, receivePort.sendPort));

        // Get the processed image from the isolate.
        Image thumbnail = await receivePort.first;

        // Save the thumbnail in memory as a PNG.
        File thumbFile = MemoryFileSystem().file('thumbnail.jpg')
          ..writeAsBytesSync(encodeJpg(thumbnail, quality: 50));

        // Set Thumbnail
        metadata.thumbnail = await thumbFile.readAsBytes();
      } else {
        log.w("No compression for non-images yet");
      }
      // Close Port
      receivePort.close();
    }
  }

  // ** Get Current Chunk ** //
  getChunk() async {
    // read one CHUNK
    var data = await _reader.read(CHUNK_SIZE);
    var chunk = Uint8List.fromList(data);

    // Progress Forward
    this.progress = _updateProgress();

    // Check if Complete
    if (data.length > 0) {
      return chunk;
    } else {
      // Return Nothing
      return null;
    }
  }

  // ** Add current block to File and reset ** //
  saveBlock() async {
    // Add to Sink
    _sink.add(_currentBlock);

    // Wait for File to accept data
    await _sink.flush();

    // Reset Current Block
    _currentBlock.clear();
  }

  // ** Save Bytes to File ** //
  saveFile() async {
    // Save to Database
    MetadataProvider metadataProvider = new MetadataProvider();
    await metadataProvider.open();
    await metadataProvider.insert(this.metadata);

    // Close
    await _sink.close();
  }

  shiftBlock() {
    // Get Total Blocks
    var totalBlocks = this.metadata.blocksTotal;

    // Update Blocks Remaining
    if (this.isBlockComplete()) {
      this.blocksRemaining = totalBlocks - 1;
    }

    // Reset Remaining Blocks
    this.blockRemainingChunks = min(totalRemainingChunks, CHUNKS_PER_ACK);
  }

  // ** Update Progress ** //
  double _updateProgress() {
    // Increase Current Chunk
    var totalChunks = this.metadata.chunksTotal;
    this.currentChunkNum += 1;

    // Find Block Remaining in Chunk
    this.blockRemainingChunks =
        this.blockRemainingChunks - this.currentChunkNum;

    // Find Total Remaining
    this.totalRemainingChunks = totalChunks - this.currentChunkNum;

    // Calculate Progress
    return (totalChunks - this.totalRemainingChunks) / totalChunks;
  }

  // ** Read Bytes from SonrFile **
  Future<Uint8List> getBytes() async {
    // Init
    Uint8List bytes;

    // Read Bytes
    await this.raw.readAsBytes().then((value) {
      bytes = Uint8List.fromList(value);
    })
        // Error Reading Bytes
        .catchError((onError) {
      // Log
      log.e("Error Reading Bytes");

      // Return Nothing
      return null;
    });

    // Return Bytes
    return bytes;
  }

  // ** Check if File Complete **
  bool isComplete() {
    return (this.totalRemainingChunks == 0);
  }

  // ** Check if Block Complete **
  bool isBlockComplete() {
    return (this.blockRemainingChunks == 0);
  }
}
