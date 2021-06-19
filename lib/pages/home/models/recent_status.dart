enum RecentsViewStatus { Default, Search }

extension RecentsViewStatusUtil on RecentsViewStatus {
  /// Checks if Status is Search
  bool get isSearching => this == RecentsViewStatus.Search;

  /// Checks if Status is Default
  bool get isDefault => this == RecentsViewStatus.Default;
}
