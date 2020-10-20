import 'package:sonar_app/models/models.dart';
import 'package:sonar_app/repository/repository.dart';
import 'package:sonar_app/core/core.dart';

// ********************* //
// ** GENERAL Message ** //
// ********************* //
enum GeneralMessage { UPDATED, EXITED, DECLINED, COMPLETED, ERROR }

class General {
  Peer from;
  dynamic error;
  GeneralMessage subject;

  // ** Constructer from Map Data **
  General(dynamic data, String event) {
    // Set Data
    if (event == 'ERROR') {
      error = data;
    } else {
      from = Peer.fromMap(data);
    }
    subject = enumFromString(event, GeneralMessage.values);
  }
}

// ******************* //
// ** OFFER Message ** //
// ******************* //
class Offer {
  Peer from;
  RTCSessionDescription description;
  String sessionId;
  Metadata metadata;

  // ** Constructer from Map Data **
  Offer(dynamic data) {
    // Set Data
    from = Peer.fromMap(data[0]);
    metadata = Metadata.fromMap(data[1]['metadata']);
    sessionId = data[1]['session_id'];
    var desc = data[1]['description'];
    description = new RTCSessionDescription(desc['sdp'], desc['type']);

    // Log Event
    log.i("OFFERED: " + data.toString());
  }

  // ** Method to return map **
  static create(
      Peer from, Peer to, Metadata metadata, RTCSessionDescription s) {
    return [
      from.toMap(),
      to.id,
      {
        'description': {'sdp': s.sdp, 'type': s.type},
        'session_id': from.session.id,
        'metadata': metadata.toMap()
      }
    ];
  }
}

// ******************** //
// ** ANSWER Message ** //
// ******************** //
class Answer {
  Peer from;
  RTCSessionDescription description;
  String sessionId;

  // ** Constructer from Map Data **
  Answer(dynamic data) {
    // Set Data
    from = Peer.fromMap(data[0]);
    sessionId = data[1]['session_id'];
    var desc = data[1]['description'];
    description = new RTCSessionDescription(desc['sdp'], desc['type']);

    // Log Event
    log.i("ANSWERED: " + data.toString());
  }

  // ** Method to return map **
  static create(Peer from, Peer to, RTCSessionDescription s) {
    return [
      from.toMap(),
      to.id,
      {
        'description': {'sdp': s.sdp, 'type': s.type},
        'session_id': from.session.id,
      }
    ];
  }
}
