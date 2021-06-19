// ** ─── Local Status Enum ────────────────────────────────────────────────────────
enum LocalStatus {
  /// When there are No Peers in Local Topic
  Empty,

  /// When there are <= 5 Peers in Local Topic
  Few,

  /// When there are > 5 Peers in Local Topic
  Many
}

/// Extension Class for Local Status
extension LocalStatusUtils on LocalStatus {
  /// Returns Local Status Value based on Lobby Count
  static LocalStatus localStatusFromCount(int count) {
    if (count == 0) {
      return LocalStatus.Empty;
    } else if (count > 0 && count <= 5) {
      return LocalStatus.Few;
    } else {
      return LocalStatus.Many;
    }
  }

  /// Checks if Status is Empty
  bool get isEmpty => this == LocalStatus.Empty;

  /// Checks if Status is Few
  bool get isFew => this == LocalStatus.Few;

  /// Checks if Status is Few
  bool get isMany => this == LocalStatus.Many;
}
