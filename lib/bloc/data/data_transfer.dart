part of 'data_bloc.dart';

class TransferFile extends Cubit<double> {
  // Transmission
  BytesBuilder _block;
  ChunkedStreamIterator<int> _reader;
  IOSink _sink;

  // Transfer Variables
  int _currentChunkNum;
  int _remainingChunksInBlock;
  int _remainingTotalBlocks;
  int _remainingTotalChunks;
  int _totalChunks;
  int _totalBlocks;
  int _totalChunksInBlock;

  // Checker Bools
  bool isBlockComplete;
  bool isTransferComplete;

  // Reference
  Metadata metadata;
  String path;
  double progress;

  // ** Constructer **
  TransferFile(this.metadata) : super(0) {
    // Set Progress Variables
    _totalChunks = (this.metadata.size / CHUNK_SIZE).ceil();
    _totalBlocks = (_totalChunks / CHUNKS_PER_ACK).ceil();

    // Set Pointers
    _currentChunkNum = 0;
    _remainingTotalChunks = _totalChunks;

    // Set Block Variables
    _totalChunksInBlock = min(_remainingTotalChunks, CHUNKS_PER_ACK);
    _remainingTotalBlocks = _totalBlocks;
    _remainingChunksInBlock = _totalChunksInBlock;

    // Set Path
    path = metadata.path;
  }

  // ** Current File Set **
  Future<bool> initialize(Role role) async {
    // Setup SonrFile for Receiving
    if (role == Role.Receiver) {
      // Initialize File
      await metadata.createFile();

      // Set Sink and Block
      _sink = new File(path).openWrite();
      _block = new BytesBuilder(copy: false);
      return true;
    }

    // Setup SonrFile for Sending
    else if (role == Role.Sender) {
      // Initialize Thumbnail
      await metadata.createThumbnail();

      // Set Chunked Stream
      _reader = ChunkedStreamIterator(new File(path).openRead());
      return true;
    }
    // Cubit only for transfer
    else {
      // Change State
      emit(null);
      return false;
    }
  }

  // ** Add to Block ** //
  void addChunk(Uint8List chunk) {
    // Get Bytes
    var bytes = chunk.toList();

    // Add Bytes to Block
    _block.add(bytes);

    // Update State
    this._update(File(path));
  }

  // ** Add current block to File and reset ** //
  Future<bool> saveBlock() async {
    // Add to Sink
    _sink.add(_block.takeBytes());

    // Await for Sink to Accepts
    bool status;
    _sink.flush().then((value) {
      // Update State
      this._update(File(path));

      // Return Success
      status = true;
    },
        // Sink Error
        onError: () {
      status = false;
    });

    // Return Status
    return status;
  }

  // ** Send Current Block of Chunks ** //
  Future<bool> sendBlock(RTCDataChannel channel) async {
    // Loop until block complete
    for (int currChunkInBlock = 0;
        currChunkInBlock < _totalChunksInBlock;
        currChunkInBlock++) {
      // Get one chunk
      var data = await _reader.read(CHUNK_SIZE);
      var chunk = Uint8List.fromList(data);

      // Send Chunk
      if (data.length > 0) {
        // Sends and Updates Progress
        channel.send(RTCDataChannelMessage.fromBinary(chunk));

        // Update Progress
        this._update(new File(path));
      } else {
        // Return Status
        return false;
      }
    }

    // Update Remaining Blocks
    this._updateBlock(new File(path));

    // Return Status
    return true;
  }

  // ** Updates Progress ** //
  _update(File file) {
    // Find Total Remaining
    _remainingTotalChunks = _totalChunks - _currentChunkNum;

    // Calculate Progress
    progress = (_totalChunks - _remainingTotalChunks) / _totalChunks;

    // Update Pointers
    _currentChunkNum += 1;
    _remainingChunksInBlock -= 1;

    // Update Checkers
    isBlockComplete = (_remainingChunksInBlock == 0);
    isTransferComplete = (_remainingTotalChunks == 0);

    // Update State
    emit(progress);
  }

  // ** Update Block Variables ** //
  _updateBlock(File file) {
    // Check if Block Complete
    if (_remainingChunksInBlock == 0) {
      // Update Blocks Remaining
      _remainingTotalBlocks = _totalBlocks - 1;

      // Reset Block Variables
      _totalChunksInBlock = min(_remainingTotalChunks, CHUNKS_PER_ACK);

      // Logging
      print("Blocks Remaining: " + _remainingTotalBlocks.toString());
      print("Chunks in Block: " + _totalChunksInBlock.toString());
      print("Total Progress: " + (progress * 100).toString() + "%");

      // Update State
      emit(progress);
    } else {
      log.e("Update Block called before Block finished");
    }
  }

  // ** Clear the Current File **
  Future<Map> complete() async {
    // Close Sink
    await _sink.close();

    // Save File
    MetadataProvider metadataProvider = new MetadataProvider();
    await metadataProvider.insert(metadata);

    // Create Map of Data
    return {'file': new File(path), 'metadata': this.metadata};
  }
}
