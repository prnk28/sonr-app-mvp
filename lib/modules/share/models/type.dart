
enum ShareViewType {
  /// For Default State
  None,

  /// For when ShareView Presented from Home Screen.
  Popup,

  /// For when ShareView Presented from Transfer Screen
  Dialog
}

extension ShareViewTypeUtils on ShareViewType {
  /// Checks for Popup Type - Popup is for when in HomeScreen
  bool get isViewPopup => this == ShareViewType.Popup;

  /// Checks for Dialog Type - Dialog is for when in TransferScreen
  bool get isViewDialog => this == ShareViewType.Dialog;
}

/// Row Button Size
const K_ROW_BUTTON_SIZE = 75.0;

/// Row Circle Size
const K_ROW_CIRCLE_SIZE = 95.0;
