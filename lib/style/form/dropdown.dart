import 'package:get/get.dart';
import 'package:sonr_plugin/sonr_plugin.dart';
import '../../style.dart';

/// @ Builds Overlay Based Positional Dropdown Menu
class SonrDropdown extends StatelessWidget {
  // Properties
  final int? selectedFlex;
  // final NeumorphicStyle style;

  // Overlay Properties
  final double? overlayHeight;
  final double? overlayWidth;
  final EdgeInsets? overlayMargin;
  final WidgetPosition selectedIconPosition;

  // References
  final List<SonrDropdownItem> items;
  final SonrDropdownItem initial;
  final RxInt index;

  // * Builds Social Media Dropdown * //
  factory SonrDropdown.social(List<Contact_Social_Media> data,
      {required RxInt index, EdgeInsets margin = const EdgeInsets.only(left: 14, right: 14), double? width, double height = 60}) {
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
    );
  }

  SonrDropdown(this.items, this.initial, this.index,
      {this.overlayHeight, this.overlayWidth, this.overlayMargin, this.selectedIconPosition = WidgetPosition.Right, this.selectedFlex});
  @override
  Widget build(BuildContext context) {
    GlobalKey _dropKey = LabeledGlobalKey("Sonr_Dropdown");
    items.toSet();
    return Obx(() {
      return Container(
        key: _dropKey,
        child: GestureDetector(
          onTapUp: (details) {
            SonrPositionedOverlay.dropdown(items, _dropKey, (newIdx) {
              index(newIdx);
              index.refresh();
            }, height: overlayHeight, width: overlayWidth, margin: overlayMargin);
          },
          child: BoxContainer(
            margin: EdgeInsets.symmetric(horizontal: 3),
            child: AnimatedSlideSwitcher.slideUp(child: Container(key: ValueKey<int>(index.value), child: _buildSelected(index.value))),
          ),
        ),
      );
    });
  }

  Widget _buildSelected(int index) {
    // @ Default Widget
    if (index == -1) {
      return Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
        Spacer(),
        initial.hasIcon ? initial.icon! : Container(),
        Padding(padding: EdgeInsets.all(4)),
        initial.text.light(),
        Spacer(flex: selectedFlex!),
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
          item.hasIcon ? item.icon! : Container(),
          Padding(padding: EdgeInsets.only(right: 10)),
          item.text.light(color: SonrColor.Grey),
          Spacer(flex: selectedFlex!),
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
          item.text.light(color: SonrColor.Grey),
          Padding(padding: EdgeInsets.only(right: 6)),
          item.hasIcon ? item.icon! : Container(),
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

/// @ Builds Dropdown Menu Item Widget
class SonrDropdownItem extends StatelessWidget {
  final Widget? icon;
  final String text;
  final bool hasIcon;

  const SonrDropdownItem(this.hasIcon, this.text, {this.icon, Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    if (hasIcon) {
      return Row(children: [
        BoxContainer(
          child: icon,
          padding: EdgeInsets.all(10),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: text.light(),
        )
      ]);
    } else {
      return Row(children: [Padding(padding: EdgeInsets.all(4)), text.light()]);
    }
  }
}
