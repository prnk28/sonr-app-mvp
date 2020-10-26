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

    // Get FilePath
    Directory tempDir = await getTemporaryDirectory();
    var path = tempDir.path + '/file_01.tmp';

    // Set Path
    this.metadata.path = path;
    this.metadata.received = DateTime.now();
    this.metadata.owner = owner.profile;

    // Save to Database
    MetadataProvider metadataProvider = new MetadataProvider();
    await metadataProvider.open();
    await metadataProvider.insert(this.metadata);

    // Get Buffer
    final buffer = data.buffer;

    // Save to File
    this.raw = await new File(path).writeAsBytes(
        buffer.asUint8List(data.offsetInBytes, data.lengthInBytes));
  }

  // ** Read Bytes from SonrFile **
  Future<Uint8List> getBytes() async {
    Uint8List bytes;
    await this.raw.readAsBytes().then((value) {
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
