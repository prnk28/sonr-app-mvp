import 'package:quiver/core.dart';

/// Represents a 2-tuple, or pair.
class Tuple<T1, T2> {
  /// Returns the first item of the tuple
  final T1 item1;

  /// Returns the second item of the tuple
  final T2 item2;

  /// Creates a new tuple value with the specified items.
  const Tuple(this.item1, this.item2);

  /// Create a new tuple value with the specified list [items].
  factory Tuple.fromList(List items) {
    if (items.length != 2) {
      throw ArgumentError('items must have length 2');
    }

    return Tuple<T1, T2>(items[0] as T1, items[1] as T2);
  }

  /// Returns a tuple with the first item set to the specified value.
  Tuple<T1, T2> withItem1(T1 v) => Tuple<T1, T2>(v, item2);

  /// Returns a tuple with the second item set to the specified value.
  Tuple<T1, T2> withItem2(T2 v) => Tuple<T1, T2>(item1, v);

  /// Creates a [List] containing the items of this [Tuple].
  ///
  /// The elements are in item order. The list is variable-length
  /// if [growable] is true.
  List toList({bool growable = false}) => List.from([item1, item2], growable: growable);

  @override
  String toString() => '[$item1, $item2]';

  @override
  bool operator ==(Object other) => other is Tuple && other.item1 == item1 && other.item2 == item2;

  @override
  int get hashCode => hash2(item1.hashCode, item2.hashCode);
}

/// Represents a 3-tuple, or triple.
class Triple<T1, T2, T3> {
  /// Returns the first item of the tuple
  final T1 item1;

  /// Returns the second item of the tuple
  final T2 item2;

  /// Returns the third item of the tuple
  final T3 item3;

  /// Creates a new tuple value with the specified items.
  const Triple(this.item1, this.item2, this.item3);

  /// Create a new tuple value with the specified list [items].
  factory Triple.fromList(List items) {
    if (items.length != 3) {
      throw ArgumentError('items must have length 3');
    }

    return Triple<T1, T2, T3>(items[0] as T1, items[1] as T2, items[2] as T3);
  }

  /// Returns a tuple with the first item set to the specified value.
  Triple<T1, T2, T3> withItem1(T1 v) => Triple<T1, T2, T3>(v, item2, item3);

  /// Returns a tuple with the second item set to the specified value.
  Triple<T1, T2, T3> withItem2(T2 v) => Triple<T1, T2, T3>(item1, v, item3);

  /// Returns a tuple with the third item set to the specified value.
  Triple<T1, T2, T3> withItem3(T3 v) => Triple<T1, T2, T3>(item1, item2, v);

  /// Creates a [List] containing the items of this [Triple].
  ///
  /// The elements are in item order. The list is variable-length
  /// if [growable] is true.
  List toList({bool growable = false}) => List.from([item1, item2, item3], growable: growable);

  @override
  String toString() => '[$item1, $item2, $item3]';

  @override
  bool operator ==(Object other) => other is Triple && other.item1 == item1 && other.item2 == item2 && other.item3 == item3;

  @override
  int get hashCode => hash3(item1.hashCode, item2.hashCode, item3.hashCode);
}

/// Represents a 4-tuple, or quadruple.
class Quadruple<T1, T2, T3, T4> {
  /// Returns the first item of the tuple
  final T1 item1;

  /// Returns the second item of the tuple
  final T2 item2;

  /// Returns the third item of the tuple
  final T3 item3;

  /// Returns the fourth item of the tuple
  final T4 item4;

  /// Creates a new tuple value with the specified items.
  const Quadruple(this.item1, this.item2, this.item3, this.item4);

  /// Create a new tuple value with the specified list [items].
  factory Quadruple.fromList(List items) {
    if (items.length != 4) {
      throw ArgumentError('items must have length 4');
    }

    return Quadruple<T1, T2, T3, T4>(items[0] as T1, items[1] as T2, items[2] as T3, items[3] as T4);
  }

  /// Returns a tuple with the first item set to the specified value.
  Quadruple<T1, T2, T3, T4> withItem1(T1 v) => Quadruple<T1, T2, T3, T4>(v, item2, item3, item4);

  /// Returns a tuple with the second item set to the specified value.
  Quadruple<T1, T2, T3, T4> withItem2(T2 v) => Quadruple<T1, T2, T3, T4>(item1, v, item3, item4);

  /// Returns a tuple with the third item set to the specified value.
  Quadruple<T1, T2, T3, T4> withItem3(T3 v) => Quadruple<T1, T2, T3, T4>(item1, item2, v, item4);

  /// Returns a tuple with the fourth item set to the specified value.
  Quadruple<T1, T2, T3, T4> withItem4(T4 v) => Quadruple<T1, T2, T3, T4>(item1, item2, item3, v);

  /// Creates a [List] containing the items of this [Quadruple].
  ///
  /// The elements are in item order. The list is variable-length
  /// if [growable] is true.
  List toList({bool growable = false}) => List.from([item1, item2, item3, item4], growable: growable);

  @override
  String toString() => '[$item1, $item2, $item3, $item4]';

  @override
  bool operator ==(Object other) =>
      other is Quadruple && other.item1 == item1 && other.item2 == item2 && other.item3 == item3 && other.item4 == item4;

  @override
  int get hashCode => hash4(item1.hashCode, item2.hashCode, item3.hashCode, item4.hashCode);
}
