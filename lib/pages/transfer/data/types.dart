// Flat Mode Durations
import 'package:sonr_app/data/data.dart';
import 'package:sonr_app/style/style.dart';

const K_TRANSLATE_DELAY = Duration(milliseconds: 150);
const K_TRANSLATE_DURATION = Duration(milliseconds: 600);

// Flat Mode States
enum FlatModeState {
  Standby,
  Dragging,
  Empty,
  Outgoing,
  Pending,
  Receiving,
  Incoming,
  Done,
}

extension FlatModeStateUtils on FlatModeState {
  bool get isStandby => this == FlatModeState.Standby;
  bool get isDragging => this == FlatModeState.Dragging;
  bool get isPending => this == FlatModeState.Pending;
  bool get isReceiving => this == FlatModeState.Receiving;
  bool get isIncoming => this == FlatModeState.Incoming;
  bool get isDone => this == FlatModeState.Done;
}

// Flat Mode Transition
enum FlatModeTransition {
  Standby,
  SlideIn,
  SlideOut,
  SlideDown,
  SlideInSingle,
}

enum LobbyFilter { All, Phones, Desktops }

extension LobbyFilterUtils on LobbyFilter {
  static LobbyFilter fromEnabled(bool phones, bool desktops) {
    if (phones && !desktops) {
      return LobbyFilter.Phones;
    } else if (desktops && !phones) {
      return LobbyFilter.Desktops;
    } else {
      return LobbyFilter.All;
    }
  }
}

enum ComposeStatus {
  Initial,
  Checking,
  NonExisting,
  Existing,
}

extension ComposeStatusUtil on ComposeStatus {
  /// Convert this Enum to Animated Status Type
  AnimatedStatusType toAnimatedStatus() {
    switch (this) {
      case ComposeStatus.Initial:
        return AnimatedStatusType.Initial;
      case ComposeStatus.Checking:
        return AnimatedStatusType.Loading;
      case ComposeStatus.NonExisting:
        return AnimatedStatusType.Error;
      case ComposeStatus.Existing:
        return AnimatedStatusType.Success;
    }
  }
}

class ComposeInviteQuery {
  final query = "Nobody Here".obs;
  DNSRecord record = DNSRecord.blank();

  Future<Peer> getPeer() async {
    return Peer(
        sName: query.value,
        id: Peer_ID(
          publicKey: record.publicKey,
        ));
  }
}
