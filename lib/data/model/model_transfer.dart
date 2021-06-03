import 'package:sonr_app/style/style.dart';
import 'package:sonr_plugin/sonr_plugin.dart';

/// @ Peer Status
enum PeerStatus { Default, Pending, Accepted, Declined, Complete }

extension PeerStatusUtils on PeerStatus {
  bool get isIdle => this == PeerStatus.Default;
  bool get isPending => this == PeerStatus.Pending;
  bool get isAccepted => this == PeerStatus.Accepted;
  bool get isDeclined => this == PeerStatus.Declined;
  bool get isComplete => this == PeerStatus.Complete;
}

/// @ Transfer Status Enum
enum SessionStatus {
  Default,
  Pending,
  Invited,
  Accepted,
  Denied,
  InProgress,
  Completed,
}

/// @ Transfer Direction Enum
enum SessionDirection { None, Incoming, Outgoing }

/// @ TransferStatusUtil: Helper Methods for Status
extension TransferStatusUtil on SessionStatus {
  /// Check for None
  bool get isNone => this == SessionStatus.Default;

  /// Check for Pending
  bool get isPending => this == SessionStatus.Pending;

  /// Check for Invited
  bool get isInvited => this == SessionStatus.Invited;

  /// Check for Accepted
  bool get isAccepted => this == SessionStatus.Accepted;

  /// Check for Denied
  bool get isDenied => this == SessionStatus.Denied;

  /// Check for InProgress
  bool get isInProgress => this == SessionStatus.InProgress;

  /// Check for Completed
  bool get isCompleted => this == SessionStatus.Completed;

  /// Check if Status is EQUAL TO Given Status
  bool equals(SessionStatus given) => this == given;

  /// Check if Status is NOT Given Status
  bool isNot(SessionStatus given) => this != given;
}

/// @ Class for Transfer Session
class RxSession {
  // @ Constants
  /// Incoming or Outgoing Session
  SessionDirection direction = SessionDirection.None;

  /// Session Payload
  Payload payload = Payload.NONE;

  /// Session Peer
  Peer peer = Peer();

  // @ Properties
  /// Current Session Status
  final status = SessionStatus.Default.obs;

  /// Current Progress
  final progress = (0.0).obs;

  /// Received Transfer
  final transfer = Transfer().obs;

  // @ References
  /// Getter to check if Session is Valid
  bool get isValid => status.value.isNot(SessionStatus.Default) && payload != Payload.NONE && direction != SessionDirection.None;

  /// Getter for Session ID
  String get id => peer.idPeer;

  // @ Constructer
  /// Create Incoming Session from AuthInvite Request
  void incoming(AuthInvite invite) {
    this.direction = SessionDirection.Incoming;
    this.payload = invite.payload;
    this.peer = invite.from;
    status(SessionStatus.Invited);
  }

  /// Create Outgoing Session from AuthInvite request
  void outgoing(AuthInvite invite) {
    this.direction = SessionDirection.Outgoing;
    this.payload = invite.payload;
    this.peer = invite.to;
    status(SessionStatus.Pending);
  }

  // @ Methods
  /// Checks wether this session is for this peer
  bool isForPeer(Peer other) {
    return this.peer.idPeer == other.idPeer;
  }

  /// User Sent Reply
  void onReply(AuthReply reply) {
    if (reply.decision) {
      status(SessionStatus.Accepted);
    } else {
      if (direction == SessionDirection.Outgoing) {
        status(SessionStatus.Denied);
      } else {
        reset();
      }
    }
  }

  /// Progress Update In transfer
  void onProgress(double data) {
    // Update Status
    if (status.value.isNot(SessionStatus.InProgress)) {
      status(SessionStatus.InProgress);
    }

    // Set Progress
    progress(data);
  }

  /// On Transfer Completed
  void onComplete(Transfer data) {
    transfer(data);
    status(SessionStatus.Completed);
  }

  /// Reset Session
  void reset() {
    // Reset Reactive
    status(SessionStatus.Default);
    progress(0);
    transfer(Transfer());

    // Reset Defaults
    this.direction = SessionDirection.None;
    this.payload = Payload.NONE;
    this.peer = Peer();
  }
}
