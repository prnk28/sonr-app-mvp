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

// Flat Mode Transition
enum FlatModeTransition {
  Standby,
  SlideIn,
  SlideOut,
  SlideDown,
  SlideInSingle,
}
