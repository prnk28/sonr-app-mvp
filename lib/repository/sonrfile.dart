import 'package:sonar_app/core/core.dart';
import 'package:sonar_app/models/models.dart';
import 'package:sonar_app/repository/repository.dart';
import 'package:image/image.dart';
import 'package:file/memory.dart';

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
  File raw;
  Metadata metadata;

  // Progress Variables
  int remainingChunks;
  int currentChunkNum;
  double progress;

  // Transmission
  IOSink _sink;
  ChunkedStreamIterator<int> _reader;

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
    this.remainingChunks = this.metadata.chunksTotal;
  }

  SonrFile.fromSaved(Metadata meta) {
    // Set Required Fields
    this.owner = new Node(meta.owner);
    this.metadata = meta;

    // Create File from Path
    this.raw = new File(meta.path);
  }

  // ** Chunk Received from Data Channel ** //
  addChunk(Uint8List chunk) async {
    // Get Bytes
    var bytes = chunk.toList();

    // Add to Sink
    _sink.add(bytes);

    // Progress Forward
    this.progress = updateProgress();
  }

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

      // Set Sink
      _sink = new File(this.metadata.path).openWrite();
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
    this.progress = updateProgress();

    // Check if Complete
    if (data.length > 0) {
      return chunk;
    } else {
      // Close Reader
      await _reader.cancel();

      // Return Nothing
      return null;
    }
  }

  // ** Save Bytes to File ** //
  save() async {
    // Save to Database
    MetadataProvider metadataProvider = new MetadataProvider();
    await metadataProvider.open();
    await metadataProvider.insert(this.metadata);

    // Close
    await _sink.close();
  }

  // ** Update Progress ** //
  double updateProgress() {
    // Increase Current Chunk
    var total = this.metadata.chunksTotal;
    this.currentChunkNum += 1;

    // Find Remaining
    this.remainingChunks = total - this.currentChunkNum;

    // Calculate Progress
    return (total - this.remainingChunks) / total;
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

  // ** Check if Progress Complete **
  bool isComplete() {
    return (this.remainingChunks == 0);
  }
}
