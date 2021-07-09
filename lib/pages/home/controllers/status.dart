import 'package:sonr_app/style/style.dart';
import 'package:sonr_app/modules/peer/peer.dart';

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
        return isSelected ? SimpleIcons.HomeActive : SimpleIcons.HomeInactive;
      case HomeView.Contact:
        return isSelected ? SimpleIcons.PersonalActive : SimpleIcons.PersonalInactive;
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

extension CompareLobbyResultUtil on CompareLobbyResult {
  List<Widget> mapNearby() {
    if (this.current != null) {
      if (hasMoreThanVisible) {
        final firstValues = this.current!.peers.values.take(4).toList();
        return firstValues.map<Widget>((value) => PeerItem.bubble(value)).toList();
      } else {
        return this.current!.peers.values.map<Widget>((value) => PeerItem.bubble(value)).toList();
      }
    } else {
      return [];
    }
  }

  Widget text() {
    if (!this.hasStayed) {
      return FadeIn(
        animate: true,
        child: this.differenceCount.toString().light(
              color: this.hasJoined ? SonrColor.Tertiary : SonrColor.Critical,
            ),
      );
    } else {
      return Container();
    }
  }

  Widget icon() {
    if (this.hasJoined) {
      return Center(
        child: FadeInUp(
          animate: true,
          duration: 300.milliseconds,
          child: SimpleIcons.Up.icon(
            color: AppTheme.ItemColor,
            size: 14,
          ),
        ),
      );
    } else if (this.hasLeft) {
      return Center(
        child: FadeInDown(
          animate: true,
          from: 40,
          duration: 300.milliseconds,
          child: SimpleIcons.Down.icon(
            color: SonrColor.Critical,
            size: 14,
          ),
        ),
      );
    } else {
      return Container();
    }
  }
}
