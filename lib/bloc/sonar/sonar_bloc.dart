import 'dart:async';
import 'dart:math';
import 'dart:typed_data';
import 'package:bloc/bloc.dart';
import 'package:flutter/services.dart';
import 'package:flutter_webrtc/webrtc.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sonar_app/data/data.dart';
import 'package:sonar_app/models/models.dart';
import 'package:sonar_app/repositories/repositories.dart';
import '../bloc.dart';
import 'package:sonar_app/core/core.dart';
import 'dart:io';
import 'package:chunked_stream/chunked_stream.dart';

// ***********************
// ** Sonar Bloc Class ***
// ***********************
const CHUNK_SIZE = 16000; // Maximum Transmission Unit in Bytes
const CHUNKS_PER_ACK = 64;

class SonarBloc extends Bloc<SonarEvent, SonarState> {
  // Data Provider
  Session session;
  Connection connection;
  Device device;
  RTCDataChannel dataChannel;
  Circle circle;

  // File Properties
  int _chunksTotal;
  File _file;
  Uint8List _block;

  // Transmission Private Properties
  bool _isComplete;
  String peerId;
  int _currentChunkNum;

  // Public Properties
  int receivedChunkNum;
  double sendingProgress;
  double receivingProgress;
  FileType type;

  // Constructer
  SonarBloc() : super(null) {
    // ** RTC::Initialization **
    session = new Session();
    connection = new Connection(this);
    circle = new Circle();
    device = new Device(this);

    session.onDataChannel = (channel) {
      dataChannel = channel;
    };

    // ** RTC::Data Message **
    session.onDataChannelMessage = (dc, RTCDataChannelMessage data) async {
      if (data.isBinary) {
        log.i("Received Chunk");
      }
      //add(Received(data));
    };
  }

  // Initial State
  SonarState get initialState => Initial();
// *********************************
// ** Map Events to State Method ***
// *********************************
  @override
  Stream<SonarState> mapEventToState(
    SonarEvent event,
  ) async* {
    // Device Can See Updates
    if (event is Initialize) {
      yield* _mapInitializeToState(event);
    } else if (event is Send) {
      yield* _mapSendToState(event);
    } else if (event is Receive) {
      yield* _mapReceiveToState(event);
    } else if (event is Update) {
      yield* _mapUpdateToState(event);
    } else if (event is Refresh) {
      yield* _mapRefreshInputToState(event);
    } else if (event is Invite) {
      yield* _mapInviteToState(event);
    } else if (event is Offered) {
      yield* _mapOfferedToState(event);
    } else if (event is Authorize) {
      yield* _mapAuthorizeToState(event);
    } else if (event is Accepted) {
      yield* _mapAcceptedToState(event);
    } else if (event is Declined) {
      yield* _mapDeclinedToState(event);
    } else if (event is Transfer) {
      yield* _mapTransferToState(event);
    } else if (event is Received) {
      yield* _mapReceivedToState(event);
    } else if (event is Completed) {
      yield* _mapCompletedToState(event);
    } else if (event is Reset) {
      yield* _mapResetToState(event);
    }
  }

// ***********************
// ** Initialize Event ***
// ***********************
  Stream<SonarState> _mapInitializeToState(Initialize initializeEvent) async* {
    // Check Status
    if (connection.needSetup()) {
// Initialize Variables
      Location fakeLocation = Location.fakeLocation();
      // Emit to Socket.io
      socket.emit("INITIALIZE",
          [fakeLocation.toMap(), initializeEvent.userProfile.toMap()]);
      connection.initialized = true;

      // Device Pending State
      yield Ready();
    }
  }

// *****************
// ** Send Event ***
// *****************
  Stream<SonarState> _mapSendToState(Send sendEvent) async* {
    // Check Init Status
    if (connection.ready()) {
      // Emit Send
      const delay = const Duration(milliseconds: 500);
      new Timer(
          delay,
          () => {
                socket.emit("SENDING", [device.lastDirection.toSendMap()])
              });
    }

    // Set Suspend state with lastState
    if (sendEvent.map != null) {
      yield Sending(
          matches: sendEvent.map,
          currentMotion: device.currentMotion,
          currentDirection: device.lastDirection);
    } else {
      yield Sending(
          currentMotion: device.currentMotion,
          currentDirection: device.lastDirection);
    }
  }

// ********************
// ** Receive Event ***
// ********************
  Stream<SonarState> _mapReceiveToState(Receive receiveEvent) async* {
    // Check Init Status
    if (connection.ready()) {
      const delay = const Duration(milliseconds: 750);
      new Timer(
          delay,
          () => {
                // Emit Receive
                socket.emit("RECEIVING", [device.lastDirection.toReceiveMap()])
              });
    }

    // Set Suspend state with lastState
    if (receiveEvent.map != null) {
      yield Receiving(
          matches: receiveEvent.map,
          currentMotion: device.currentMotion,
          currentDirection: device.lastDirection);
    } else {
      yield Receiving(
          currentMotion: device.currentMotion,
          currentDirection: device.lastDirection);
    }
  }

// ***********************
// ** Invite Event ***
// ***********************
  Stream<SonarState> _mapInviteToState(Invite requestEvent) async* {
    // Check Status
    if (connection.ready()) {
      // Emit to Socket.io
      connection.invited = true;

      // Create Offer and Emit
      session.invite(circle.closest()["id"]);

      // Device Pending State
      yield Pending("SENDER", match: circle.closest());
    }
  }

// ***********************
// ** Offered Event ***
// ***********************
  Stream<SonarState> _mapOfferedToState(Offered offeredEvent) async* {
    // Check Status
    if (connection.ready()) {
      // Set Offered
      connection.offered = true;

      // Device Pending State
      yield Pending("RECEIVER",
          match: offeredEvent.profileData,
          file: offeredEvent.fileData,
          offer: offeredEvent.offer);
    }
  }

// **********************
// ** Authorize Event ***
// **********************
  Stream<SonarState> _mapAuthorizeToState(Authorize authorizeEvent) async* {
    // Check Status
    if (connection.initialized) {
      // Yield Receiver Decision
      if (authorizeEvent.decision) {
        // Create Answer
        session.handleOffer(authorizeEvent.offer);
        yield Transferring();
      }
      // Receiver Declined
      else {
        socket.emit("DECLINE", authorizeEvent.matchId);
        add(Reset(0));
      }
    }
  }

// **********************
// ** Accepted Event ***
// **********************
  Stream<SonarState> _mapAcceptedToState(Accepted acceptedEvent) async* {
    // Check Status
    if (connection.initialized) {
      session.handleAnswer(acceptedEvent.answer);
      // Emit Decision to Server
      yield PreTransfer(
          profile: acceptedEvent.profile, matchId: acceptedEvent.matchId);
    }
  }

// **********************
// ** Declined Event ***
// **********************
  Stream<SonarState> _mapDeclinedToState(Declined declinedEvent) async* {
    // Check Status
    if (connection.initialized) {
      // Emit Decision to Server
      yield Failed(
          profile: declinedEvent.profile, matchId: declinedEvent.matchId);
    }
  }

// *********************
// ** Transfer Event ***
// *********************
  Stream<SonarState> _mapTransferToState(Transfer transferEvent) async* {
    // Check Status
    if (connection.initialized) {
      // Audio as bytes

      //ByteData bytes = await rootBundle.load('assets/images/headers/1.jpg');
      sendBlock(0);
      // Emit Decision to Server
      yield Transferring();
    }
  }

// *********************
// ** Received Event ***
// *********************
  Stream<SonarState> _mapReceivedToState(Received receivedEvent) async* {
    // Check Status
    if (connection.initialized) {
      // Read Data
      if (receivedEvent.data.isBinary) {
        //addChunk(receivedEvent.data.binary.buffer, _currentChunkNum);
        log.i(receivedEvent.data.binary.buffer.lengthInBytes.toString());
        print("Received Chunk");
      } else {
        // Set New Chunk
        _currentChunkNum = int.parse(receivedEvent.data.text);
        log.i(receivedEvent.data.text);
      }
      // Emit Completed

      // Emit Decision to Server
      yield Complete("RECEIVER", file: receivedEvent.data.binary);
    }
  }

// *********************
// ** Completed Event ***
// *********************
  Stream<SonarState> _mapCompletedToState(Completed completedEvent) async* {
    // Check Status
    if (connection.initialized) {
      // Emit Decision to Server
      yield Complete("SENDER");
    }
  }

// *********************
// ** Reset Event ***
// *********************
  Stream<SonarState> _mapResetToState(Reset resetEvent) async* {
    // Check Status
    if (connection.initialized) {
      // Reset Connection
      connection.reset();

      // Reset RTC
      session.close();

      // Set Delay
      await new Future.delayed(Duration(seconds: resetEvent.secondDelay));

      // Yield Ready
      yield Ready();
    } else {
      add(Initialize());
    }
  }

// ********************
// ** Update Event ***
// ********************
  Stream<SonarState> _mapUpdateToState(Update updateEvent) async* {
    if (connection.initialized) {
      if (updateEvent.map.status == "Sender") {
        add(Send(map: updateEvent.map));
      } else {
        add(Receive(map: updateEvent.map));
      }
      yield Loading();
    }
  }

// **************************
// ** Refresh Input Event ***
// **************************
  Stream<SonarState> _mapRefreshInputToState(Refresh updateSensors) async* {
// Check Status
    if (connection.noContact()) {
      // Check State
      if (device.isSearching()) {
        // Check Directions
        if (device.lastDirection != updateSensors.newDirection) {
          // Set as new direction
          device.lastDirection = updateSensors.newDirection;
        }
        // Check State
        if (device.isSending()) {
          // Post Update
          add(Update(
              currentDirection: device.lastDirection,
              currentMotion: device.currentMotion,
              map: circle));
        }
        // Receive State
        else if (device.isReceiving()) {
          // Post Update
          add(Update(
              currentDirection: device.lastDirection,
              currentMotion: device.currentMotion,
              map: circle));
        }
        // Pending State
      } else {
        yield Ready(
            currentDirection: updateSensors.newDirection,
            currentMotion: device.currentMotion);
      }
    }
  }

  // ** BOOL: Add Chunk received from Sender
  bool addChunk(ByteBuffer chunk, int receivedChunkNum) {
    // Verify Receiver
    // Set Variables
    // int nextChunkNum = receivedChunkNum + 1;
    // bool lastChunkInFile = receivedChunkNum == this._chunksTotal - 1;
    // bool lastChunkInBlock =
    //     receivedChunkNum > 0 && (receivedChunkNum + 1) % CHUNKS_PER_ACK == 0;
    // receivedChunkNum = receivedChunkNum + 1;

    // // Add Chunk to Block
    // _block.addAll(chunk.asInt8List());

    // // Append the File
    // if (lastChunkInFile || lastChunkInBlock) {
    //   _fileLocal.writeAsBytes(_block).then((value) => {
    //         if (lastChunkInFile)
    //           {_isComplete = true}
    //         else
    //           {
    //             socket.emit("BLOCK_REQUEST", [peerId, nextChunkNum])
    //           }
    //       });
    // }

    throw ("Cannot Add Chunk, User is sender.");
  }

  // ** BUFFER: Get Next Chunk to send to Receiver
  Future<void> sendBlock(int beginChunkNum) async {
    // Set Variables
    //int remainingChunks = this._chunksTotal - beginChunkNum;
    //int chunksToSend = [remainingChunks, CHUNKS_PER_ACK].reduce(min);
    //int endChunkNum = beginChunkNum + chunksToSend - 1;
    //int blockBegin = beginChunkNum * CHUNK_SIZE;
    // int blockEnd = (endChunkNum * CHUNK_SIZE) + CHUNK_SIZE;

    // Aids method to convert file from assets into File Object
    Directory directory = await getApplicationDocumentsDirectory();
    var dbPath = join(directory.path, "img.jpg");
    ByteData data = await rootBundle.load("assets/images/headers/4.jpg");
    List<int> bytes =
        data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
    File file = await File(dbPath).writeAsBytes(bytes);

    // Open File in Reader and Send Data pieces as chunks
    final reader = ChunkedStreamIterator(file.openRead());
    // While the reader has a next byte
    while (true) {
      // read one CHUNK
      var data = await reader.read(CHUNK_SIZE);
      var chunk = Uint8List.fromList(data);

      // Send Binary in WebRTC Data Channel
      dataChannel.send(RTCDataChannelMessage.fromBinary(chunk));

      // End of List
      if (data.length <= 0) {
        socket.emit("SEND_COMPLETE");
        _isComplete = true;
        add(Completed(null, null));
        break;
      }
      print('next byte: ${data[0]}');
    }
  }
}
