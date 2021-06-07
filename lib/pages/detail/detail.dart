enum DetailPageType {
  CardsList,
  CardsGrid,
  DetailContact,
  DetailFile,
  DetailMedia,
  DetailUrl,
  ErrorEmptyContacts,
  ErrorEmptyFiles,
  ErrorEmptyLinks,
  ErrorEmptyMedia,
  ErrorPermLocation,
  ErrorPermMedia,
}

extension DetailPageTypeUtils on DetailPageType {
  /// Check if PageType is for Cards View
  bool get isCards => this == DetailPageType.CardsList || this == DetailPageType.CardsGrid;

  /// Check if PageType is for Detail View
  bool get isDetail =>
      this == DetailPageType.DetailContact ||
      this == DetailPageType.DetailFile ||
      this == DetailPageType.DetailMedia ||
      this == DetailPageType.DetailUrl;

  /// Check if PageType is for Error View
  bool get isError =>
      this == DetailPageType.ErrorEmptyContacts ||
      this == DetailPageType.ErrorEmptyFiles ||
      this == DetailPageType.ErrorEmptyLinks ||
      this == DetailPageType.ErrorEmptyMedia ||
      this == DetailPageType.ErrorPermLocation ||
      this == DetailPageType.ErrorPermMedia;

  /// Check if Should build Appbar
  bool get hasAppBar => this.isDetail || this.isCards;

  /// Returns Image Asset Path for Error
  String get errorImageAsset {
    // Initialize Base Path
    final basePath = "assets/illustrations/";
    // Get Path
    switch (this) {
      case DetailPageType.ErrorEmptyContacts:
        return basePath + "NoContacts.png";
      case DetailPageType.ErrorEmptyFiles:
        return basePath + "NoFiles.png";
      case DetailPageType.ErrorEmptyLinks:
        return basePath + "NoLinks.png";
      case DetailPageType.ErrorEmptyMedia:
        return basePath + "NoMedia.png";
      case DetailPageType.ErrorPermLocation:
        return basePath + "LocationPerm.png";
      case DetailPageType.ErrorPermMedia:
        return basePath + "MediaPerm.png";
      default:
        return "";
    }
  }
}
