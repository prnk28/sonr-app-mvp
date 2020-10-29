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

    log.i(
        "Transfer Info: Total Chunks= $_totalChunks. Total Blocks= $_totalBlocks. Total Chunks in Block= $_totalChunksInBlock");
  }

  // ** Current File Set **
  Future<bool> initialize(Role role) async {
    // Setup SonrFile for Receiving
    if (role == Role.Receiver) {
      // Set Sink and Block
      _sink = new File(path).openWrite();
      _block = new BytesBuilder();
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
      // Change State
      emit(null);
      return false;
    }
  }

  // ** Add to Block ** //
  bool addChunk(Uint8List chunk) {
    // Add Bytes to Block
    _block.add(chunk.toList());

    // Update Pointers
    _currentChunkNum += 1;
    _remainingChunksInBlock -= 1;

    // Check if Block Complete
    if (_remainingChunksInBlock == 0) {
      return true;
    } else {
      // Update State
      this._update(File(path));
      return false;
    }
  }

  // ** Add current block to File and reset ** //
  saveBlock() {
    // Add to Sink
    _sink.add(_block.takeBytes());
    this._updateBlock(File(path), Role.Receiver);
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
        // Update Pointers
        _remainingChunksInBlock -= 1;
        _currentChunkNum += 1;

        // Sends and Updates Progress
        channel
            .send(RTCDataChannelMessage.fromBinary(Uint8List.fromList(data)));

        // Update Progress
        this._update(new File(path));
      } else {
        // Return Status
        return false;
      }
    }

    // Update Remaining Blocks
    this._updateBlock(new File(path), Role.Sender);

    // Return Status
    return true;
  }

  // ** Updates Progress ** //
  _update(File file) {
    // Find Total Remaining
    _remainingTotalChunks = _totalChunks - _currentChunkNum;

    // Calculate Progress
    progress = (_totalChunks - _remainingTotalChunks) / _totalChunks;

    // Update Checkers
    isTransferComplete = (_remainingTotalChunks == 0);

    // Log Info
    log.i(
        "Current Chunk: $_currentChunkNum. Remaining Chunks in Block:$_remainingChunksInBlock");

    // Update State
    emit(progress);
  }

  // ** Update Block Variables ** //
  _updateBlock(File file, Role type) async {
    // Check if Block Complete
    if (_remainingChunksInBlock == 0) {
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

    // Check if Blocks Complete
    if (_remainingTotalBlocks == 0) {
      switch (type) {
        case Role.Sender:
          await _reader.cancel();
          break;
        case Role.Receiver:
          await _sink.close();
          break;
        case Role.Zero:
          break;
      }
    }
  }

  // ** Clear the Current File **
  Future<void> close() async {
    super.close();
  }
}
