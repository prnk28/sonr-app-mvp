import 'package:get/get.dart';
import 'package:sonr_app/data/data.dart';
import 'package:sonr_core/sonr_core.dart';
import '../theme.dart';

// ^ Builds Overlay Based Positional Dropdown Menu ^ //
class SonrDropdown extends StatelessWidget {
  // Properties
  final int selectedFlex;
  final NeumorphicStyle style;

  // Overlay Properties
  final double overlayHeight;
  final double overlayWidth;
  final EdgeInsets overlayMargin;
  final WidgetPosition selectedIconPosition;

  // References
  final List<SonrDropdownItem> items;
  final SonrDropdownItem initial;
  final RxInt index;

  // * Builds Social Media Dropdown * //
  factory SonrDropdown.social(List<Contact_SocialTile_Provider> data,
      {@required RxInt index, EdgeInsets margin = const EdgeInsets.only(left: 14, right: 14), double width, double height = 60}) {
    var items = List<SonrDropdownItem>.generate(data.length, (index) {
      return SonrDropdownItem(true, data[index].toString(), icon: data[index].icon(IconType.Gradient));
    });
    return SonrDropdown(
      items,
      SonrDropdownItem(false, "Choose..."),
      index,
      overlayWidth: 20,
      overlayHeight: -80,
      selectedFlex: 6,
      selectedIconPosition: WidgetPosition.Left,
      style: SonrStyle.dropDownFlat,
    );
  }

  SonrDropdown(this.items, this.initial, this.index,
      {this.overlayHeight, this.overlayWidth, this.overlayMargin, this.selectedIconPosition = WidgetPosition.Right, this.selectedFlex, this.style});
  @override
  Widget build(BuildContext context) {
    GlobalKey _dropKey = LabeledGlobalKey("Sonr_Dropdown");
    items.removeWhere((value) => value == null);
    return Obx(() {
      return Container(
        key: _dropKey,
        child: NeumorphicButton(
            margin: EdgeInsets.symmetric(horizontal: 3),
            style: style,
            child: AnimatedSlideSwitcher.slideUp(child: Container(key: ValueKey<int>(index.value), child: _buildSelected(index.value))),
            onPressed: () {
              SonrPositionedOverlay.dropdown(items, _dropKey, (newIdx) {
                index(newIdx);
                index.refresh();
              }, height: overlayHeight, width: overlayWidth, margin: overlayMargin);
            }),
      );
    });
  }

  Widget _buildSelected(int index) {
    // @ Default Widget
    if (index == -1) {
      return Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
        Spacer(),
        initial.hasIcon ? initial.icon : Container(),
        Padding(padding: EdgeInsets.all(4)),
        initial.text.h6,
        Spacer(flex: selectedFlex),
        Get.find<SonrPositionedOverlay>().overlays.length == 0
            ? SonrIcon.normal(Icons.arrow_upward_rounded, color: UserService.isDarkMode ? Colors.white : SonrColor.Black)
            : SonrIcon.normal(Icons.arrow_downward_rounded, color: UserService.isDarkMode ? Colors.white : SonrColor.Black),
        Spacer(),
      ]);
    }

    // @ Selected Widget
    else {
      var item = items[index];
      if (selectedIconPosition == WidgetPosition.Left) {
        return Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
          Spacer(),
          item.hasIcon ? item.icon : Container(),
          Padding(padding: EdgeInsets.only(right: 10)),
          item.text.headSix(color: SonrColor.Grey),
          Spacer(flex: selectedFlex),
          Get.find<SonrPositionedOverlay>().overlays.length == 0
              ? SonrIcon.normal(Icons.arrow_upward_rounded, color: UserService.isDarkMode ? Colors.white : SonrColor.Black)
              : SonrIcon.normal(Icons.arrow_downward_rounded, color: UserService.isDarkMode ? Colors.white : SonrColor.Black),
          Spacer(),
        ]);
      } else {
        return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, crossAxisAlignment: CrossAxisAlignment.center, children: [
          item.text.headSix(color: SonrColor.Grey),
          Padding(padding: EdgeInsets.only(right: 6)),
          item.hasIcon ? item.icon : Container(),
          Get.find<SonrPositionedOverlay>().overlays.length == 0
              ? SonrIcon.normal(Icons.arrow_upward_rounded, color: UserService.isDarkMode ? Colors.white : SonrColor.Black)
              : SonrIcon.normal(Icons.arrow_downward_rounded, color: UserService.isDarkMode ? Colors.white : SonrColor.Black),
        ]);
      }
    }
  }
}

// ^ Builds Dropdown Menu Item Widget ^ //
class SonrDropdownItem extends StatelessWidget {
  final Widget icon;
  final String text;
  final bool hasIcon;

  const SonrDropdownItem(this.hasIcon, this.text, {this.icon, Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    if (hasIcon) {
      return Row(children: [
        Neumorphic(
          child: icon,
          style: SonrStyle.indented,
          padding: EdgeInsets.all(10),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: text.h6,
        )
      ]);
    } else {
      return Row(children: [Padding(padding: EdgeInsets.all(4)), text.h6]);
    }
  }
}

// ^ Builds Albums Dropdown Widget ^ //
class AlbumsDropdown extends StatelessWidget {
  final Widget leading;
  final Function() onConfirmed;
  final RxBool hasSelected;
  final RxInt index;
  final EdgeInsets margin;
  final double height = 60;
  AlbumsDropdown(
      {@required this.index,
      @required this.hasSelected,
      @required this.onConfirmed,
      this.margin = const EdgeInsets.only(left: 12, right: 12),
      this.leading});
  @override
  Widget build(BuildContext context) {
    return ObxValue<RxBool>(
        (selected) => Container(
                child: Row(children: [
              AnimatedContainer(
                  margin: margin,
                  width: selected.value ? Get.width - 150 : Get.width - 100,
                  height: height,
                  duration: 250.milliseconds,
                  child: _buildDropdown()),
              AnimatedContainer(
                  duration: 250.milliseconds, width: selected.value ? height : 0, height: selected.value ? height : 0, child: _buildConfirmButton()),
            ])),
        hasSelected);
  }

  // @ Build Sonr Dropdown
  Widget _buildDropdown() {
    return SonrDropdown(
        _buildAlbumItems(MediaService.albums),
        SonrDropdownItem(true, "All",
            icon: SonrIcon.gradient(
                Icons.all_inbox_rounded, UserService.isDarkMode ? FlutterGradientNames.premiumWhite : FlutterGradientNames.premiumDark,
                size: 20)),
        index,
        style: SonrStyle.dropDownCurved,
        overlayWidth: 70,
        overlayHeight: 100,
        selectedFlex: 2,
        selectedIconPosition: WidgetPosition.Left);
  }

  // @ Build Confirm Button
  Widget _buildConfirmButton() {
    return PlainButton(
      onPressed: onConfirmed,
      icon: SonrIcon.accept,
    );
  }

  // # Build Media Album Items
  List<SonrDropdownItem> _buildAlbumItems(List<MediaAlbum> data) {
    return List<SonrDropdownItem>.generate(data.length, (index) {
      if (data[index].name != null) {
        // Initialize
        var collection = data[index];
        var hasIcon = false;
        var icon;

        // @ Set Icon for Generated Albums
        var adjName = collection.name.toLowerCase();
        // All
        if (adjName == 'all') {
          hasIcon = true;
          icon = SonrIcon.gradient(
              Icons.all_inbox_rounded, UserService.isDarkMode ? FlutterGradientNames.premiumWhite : FlutterGradientNames.premiumDark,
              size: 20);
        }
        // Sonr
        else if (adjName == 'sonr') {
          hasIcon = true;
          icon = SonrIcon.sonr;
        }
        // Download
        else if (adjName == 'download') {
          hasIcon = true;
          icon = SonrIcon.gradient(Icons.download_rounded, FlutterGradientNames.orangeJuice, size: 20);
        }
        // Screenshots
        else if (adjName == 'screenshots') {
          hasIcon = true;
          icon = SonrIcon.screenshots;
        }
        // Favorites
        else if (adjName == 'favorites') {
          hasIcon = true;
          icon = SonrIcon.gradient(Icons.star_half_rounded, FlutterGradientNames.fruitBlend, size: 20);
        }
        // Panoramas
        else if (adjName == 'panoramas') {
          hasIcon = true;
          icon = SonrIcon.panorama;
        }
        // Pictures
        else if (adjName == 'pictures') {
          hasIcon = true;
          icon = SonrIcon.photos;
        }
        // Videos
        else if (adjName == 'movies' || adjName == 'videos') {
          hasIcon = true;
          icon = SonrIcon.gradient(Icons.movie_creation_outlined, FlutterGradientNames.lilyMeadow, size: 20);
        }
        // Recents
        else if (adjName == 'recent' || adjName == 'recents') {
          hasIcon = true;
          icon = SonrIcon.gradient(Icons.timelapse, FlutterGradientNames.crystalline, size: 20);
        }

        // Other
        else {
          hasIcon = true;
          icon = SonrIcon.gradient(Icons.album_rounded, FlutterGradientNames.sugarLollipop, size: 20);
        }
        // Return Item
        return SonrDropdownItem(hasIcon, collection.name, icon: icon);
      } else {
        return null;
      }
    });
  }
}
