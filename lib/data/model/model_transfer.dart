import 'package:sonr_app/style.dart';
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
class Session {
  // @ Constants
  /// Incoming or Outgoing Session
  SessionDirection direction = SessionDirection.None;

  /// Session Payload
  Payload payload = Payload.NONE;

  /// Session Sending Peer
  Peer from = Peer();

  /// Session Receiving Peer
  Peer to = Peer();

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

  // @ Constructer
  /// Create Incoming Session from InviteRequest Request
  void incoming(InviteRequest invite) {
    this.direction = SessionDirection.Incoming;
    this.payload = invite.payload;
    this.to = invite.to;
    this.from = invite.from;
    status(SessionStatus.Invited);
  }

  /// Create Outgoing Session from InviteRequest request
  void outgoing(InviteRequest invite) {
    this.direction = SessionDirection.Outgoing;
    this.payload = invite.payload;
    this.to = invite.to;
    this.from = invite.from;
    status(SessionStatus.Pending);
  }

  // @ Methods
  /// Return InviteResponse based on Invite Type
  InviteResponse buildReply({required bool decision}) {
    // Get Reply Type
    InviteResponse_Type replyType;
    if (this.payload.isTransfer) {
      replyType = InviteResponse_Type.Transfer;
    } else if (this.payload.isContact) {
      replyType = InviteResponse_Type.Contact;
    } else if (this.payload.isFlatContact) {
      replyType = InviteResponse_Type.FlatContact;
    } else {
      replyType = InviteResponse_Type.None;
    }

    // Return Reply
    return InviteResponse(decision: decision, to: this.from, from: this.to, type: replyType);
  }

  /// User Sent Reply
  void onReply(InviteResponse reply) {
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
    this.from = Peer();
    this.to = Peer();
  }
}
