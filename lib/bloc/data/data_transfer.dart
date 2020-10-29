part of 'data_bloc.dart';

class TransferFile extends Cubit<double> {
  // Transmission
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

    log.i(
        "Transfer Info: Total Chunks= $_totalChunks. Total Blocks= $_totalBlocks. Total Chunks in Block= $_totalChunksInBlock");
  }

  // ** Current File Set **
  Future<bool> initialize(Role role) async {
    // Setup SonrFile for Receiving
    if (role == Role.Receiver) {
      // Set Sink and Block
      _sink = new File(path).openWrite();
      return true;
    }

    // Setup SonrFile for Sending
    else if (role == Role.Sender) {
      // Set Chunked Stream
      _reader = ChunkedStreamIterator(new File(path).openRead());
      return true;
    }
    // Cubit only for transfer
    else {
      return false;
    }
  }

  // ** Add to Block ** //
  addChunk(Uint8List chunk) async {
    // Add Bytes to Block
    _sink.add(chunk.toList());

    // Update
    await this._update();
  }

  // ** Add current block to File and reset ** //
  saveBlock() {
    // Add to Sink
    //_sink.add(_block.takeBytes());
    _updateBlock(Role.Receiver);
  }

  // ** Send Current Block of Chunks ** //
  Future<bool> sendBlock(RTCDataChannel channel) async {
    // Loop until block complete
    for (int currChunkInBlock = 0;
        currChunkInBlock < _totalChunksInBlock;
        currChunkInBlock++) {
      // Get one chunk
      var data = await _reader.read(CHUNK_SIZE);

      // Send Chunk
      if (data.length > 0) {
        // Sends and Updates Progress
        channel
            .send(RTCDataChannelMessage.fromBinary(Uint8List.fromList(data)));

        // Update Progress
        await this._update();
      } else {
        // Return Status
        return false;
      }
    }

    // Update Remaining Blocks
    this._updateBlock(Role.Sender);

    // Return Status
    return true;
  }

  // ** Updates Progress ** //
  _update() async {
    // Update Pointers
    _currentChunkNum += 1;
    _remainingChunksInBlock -= 1;

    // Find Total Remaining
    _remainingTotalChunks = _totalChunks - _currentChunkNum;

    // Update Checkers
    isTransferComplete = (_remainingTotalChunks == 0);
    isBlockComplete = (_remainingChunksInBlock == 0 && !isTransferComplete);

    // Calculate Progress
    progress = (_totalChunks - _remainingTotalChunks) / _totalChunks;

    // Close Sink
    if (isTransferComplete && _sink != null) {
      // Check if Blocks Complete
      await _sink.close();
    }

    // Log Info
    log.i(
        "Current Chunk: $_currentChunkNum. Remaining Chunks in Block:$_remainingChunksInBlock");

    // Update State
    emit(progress);
  }

  // ** Update Block Variables ** //
  _updateBlock(Role type) async {
    // Update Blocks Remaining
    _remainingTotalBlocks = _totalBlocks - 1;

    // Reset Block Variables
    _totalChunksInBlock = min(_remainingTotalChunks, CHUNKS_PER_ACK);
    _remainingChunksInBlock = _totalChunksInBlock;

    // Logging
    print("$type -> Blocks Remaining: " + _remainingTotalBlocks.toString());
    print("$type -> Chunks in Block: " + _totalChunksInBlock.toString());
    print("$type -> Total Progress: " + (progress * 100).toString() + "%");

    // Update State
    emit(progress);
  }
}
