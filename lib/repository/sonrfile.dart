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

  // Transmission
  BytesBuilder _writer;

  // ** Constructer ** //
  SonrFile(this.owner, {this.metadata, this.raw}) {
    // Generate MetaData from Raw File
    if (this.raw != null) {
      // Init Metadata
      this.metadata = new Metadata(raw);
    } else {
      // Initialize Writer for File
      _writer = new BytesBuilder();
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

    // Get Identifier
    String type = '/' + enumAsString(this.metadata.type);

    // Get Directory - Reset when app deleted
    Directory localDir = await getApplicationDocumentsDirectory();

    // Set Path
    this.metadata.path =
        localDir.path + type + '_' + uuid.v1() + "_" + this.metadata.name;
    this.metadata.received = DateTime.now();
    this.metadata.owner = owner.profile;

    // Save to Database
    MetadataProvider metadataProvider = new MetadataProvider();
    await metadataProvider.open();
    await metadataProvider.insert(this.metadata);

    // Get Buffer
    final buffer = data.buffer;

    // Create File
    await new File(this.metadata.path).create(recursive: true);

    // Write to File
    var file = await new File(this.metadata.path).writeAsBytes(
        buffer.asUint8List(data.offsetInBytes, data.lengthInBytes));

    // Set File
    this.raw = file;
  }

  // ** Set thumbnail for file ** //
  setPreview() async {
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
