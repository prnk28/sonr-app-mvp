enum DetailPageType {
  CardsList,
  CardsGrid,
  DetailContact,
  DetailFile,
  DetailMedia,
  DetailUrl,
  ErrorConnection,
  ErrorPermissions,
  ErrorTransfer,
}

extension DetailPageTypeUtils on DetailPageType {
  /// Check if PageType is for Cards View
  bool get isCards => this == DetailPageType.CardsGrid || this == DetailPageType.CardsList;

  /// Check if PageType is for Detail View
  bool get isDetail =>
      this == DetailPageType.DetailContact ||
      this == DetailPageType.DetailFile ||
      this == DetailPageType.DetailMedia ||
      this == DetailPageType.DetailUrl;

  /// Check if PageType is for Error View
  bool get isError => this == DetailPageType.ErrorConnection || this == DetailPageType.ErrorPermissions || this == DetailPageType.ErrorTransfer;
}

