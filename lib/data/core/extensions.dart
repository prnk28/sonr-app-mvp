import 'dart:math';

extension ListUtils<T> on List<T> {
  random() {
    final rand = Random();
    return this[rand.nextInt(this.length)];
  }

  void swap(int index1, int index2) {
    var length = this.length;
    RangeError.checkValidIndex(index1, this, "index1", length);
    RangeError.checkValidIndex(index2, this, "index2", length);
    if (index1 != index2) {
      var tmp1 = this[index1];
      this[index1] = this[index2];
      this[index2] = tmp1;
    }
  }
}

extension StringUtils on String {
  /// Check if this String is any of the Given list of Strings
  bool isAny(List<String> opts) => opts.any((element) => element == this);
}
