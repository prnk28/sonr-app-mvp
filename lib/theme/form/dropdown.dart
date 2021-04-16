import 'package:get/get.dart';
import 'package:sonr_core/sonr_core.dart';
import 'theme.dart';

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
      return SonrDropdownItem(true, data[index].toString(), icon: data[index].gradient());
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
            ? UserService.isDarkMode
                ? SonrIcons.Up.black
                : SonrIcons.Up.white
            : UserService.isDarkMode
                ? SonrIcons.Down.black
                : SonrIcons.Down.white,
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
              ? UserService.isDarkMode
                  ? SonrIcons.Up.black
                  : SonrIcons.Up.white
              : UserService.isDarkMode
                  ? SonrIcons.Down.black
                  : SonrIcons.Down.white,
          Spacer(),
        ]);
      } else {
        return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, crossAxisAlignment: CrossAxisAlignment.center, children: [
          item.text.headSix(color: SonrColor.Grey),
          Padding(padding: EdgeInsets.only(right: 6)),
          item.hasIcon ? item.icon : Container(),
          Get.find<SonrPositionedOverlay>().overlays.length == 0
              ? UserService.isDarkMode
                  ? SonrIcons.Up.white
                  : SonrIcons.Up.black
              : UserService.isDarkMode
                  ? SonrIcons.Down.white
                  : SonrIcons.Down.black,
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
        Container(
          child: icon,
          decoration: Neumorph.indented(),
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
