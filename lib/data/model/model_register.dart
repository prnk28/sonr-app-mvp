enum TextInputValidStatus { None, Valid, Invalid }

extension TextInputValidStatusUtils on TextInputValidStatus {
  static TextInputValidStatus fromValidBool(bool val) {
    if (val) {
      return TextInputValidStatus.Valid;
    } else {
      return TextInputValidStatus.Invalid;
    }
  }

  static TextInputValidStatus fromInvalidBool(bool val) {
    if (val) {
      return TextInputValidStatus.Invalid;
    } else {
      return TextInputValidStatus.Valid;
    }
  }
}
