import 'package:sonr_app/style/style.dart';

enum HomeView { Dashboard, Contact, Explorer, Search }

/// @ Home View Enum Extension
extension HomeViewUtils on HomeView {
  /// ### Default View
  bool get isDefault => this == HomeView.Dashboard;

  /// ### Search View
  bool get isSearch => this == HomeView.Search;

  /// ### Returns IconData for Type
  IconData iconData(bool isSelected) {
    switch (this) {
      case HomeView.Dashboard:
        return isSelected ? SonrIcons.HomeActive : SonrIcons.HomeInactive;
      case HomeView.Contact:
        return isSelected ? SonrIcons.PersonalActive : SonrIcons.PersonalInactive;
      default:
        return Icons.deck;
    }
  }

  /// ### Returns Icon Size
  double get iconSize {
    switch (this) {
      case HomeView.Dashboard:
        return 32;
      case HomeView.Contact:
        return 32;
      default:
        return 32;
    }
  }

  String get title {
    if (this == HomeView.Dashboard) {
      return "Welcome";
    } else {
      return this.toString().substring(this.toString().indexOf('.') + 1);
    }
  }

  bool get isNotFirst {
    var i = HomeView.values.indexOf(this);
    return i != 0;
  }

  bool get isNotLast {
    var i = HomeView.values.indexOf(this);
    return i != HomeView.values.length - 1;
  }

  HomeView get pageBefore {
    var i = HomeView.values.indexOf(this);
    return this.isNotFirst ? HomeView.values[i - 1] : this;
  }

  HomeView get pageNext {
    var i = HomeView.values.indexOf(this);
    return this.isNotLast ? HomeView.values[i + 1] : this;
  }

  // # Return State for Int
  static HomeView fromIndex(int i) {
    return HomeView.values[i];
  }
}
