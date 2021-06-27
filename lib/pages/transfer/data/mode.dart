// Flat Mode Durations
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
