enum UISoundType { Confirmed, Connected, Critical, Deleted, Fatal, Joined, Linked, Received, Swipe, Transmitted, Warning }

extension UISoundTypeUtil on UISoundType {
  String get path {
    return 'assets/sounds/${this.name}.wav';
  }

  String get name {
    return this.toString().substring(this.toString().indexOf('.') + 1);
  }
}
