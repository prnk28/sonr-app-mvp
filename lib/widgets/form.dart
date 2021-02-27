import 'package:get/get.dart';
import 'package:media_gallery/media_gallery.dart';
import 'package:sonr_app/theme/theme.dart';
import 'package:sonr_core/sonr_core.dart';

class SonrForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }
}

// ^ Builds Neumorphic Checkbox with Label ^ //
class SonrCheckbox extends StatelessWidget {
  final String label;
  final double labelSize;
  final bool initialValue;
  final Function(bool) onUpdate;
  final EdgeInsets padding;
  final EdgeInsets margin;
  final double rowWidth;
  final double width;
  final double height;
  final CrossAxisAlignment crossAxisAlignment;
  final MainAxisAlignment mainAxisAlignment;
  const SonrCheckbox({
    @required this.onUpdate,
    Key key,
    this.label,
    this.labelSize = 18,
    this.initialValue = false,
    this.padding = const EdgeInsets.only(top: 25),
    this.margin = const EdgeInsets.only(left: 12, right: 12),
    this.width = 40,
    this.height = 40,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    this.mainAxisAlignment = MainAxisAlignment.spaceEvenly,
    this.rowWidth,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      width: rowWidth ?? Get.width - 160,
      margin: margin,
      child: Row(crossAxisAlignment: crossAxisAlignment, mainAxisAlignment: mainAxisAlignment, children: [
        // @ Set Text
        label ?? SonrText.normal(label, size: labelSize),

        // @ Create Check Box
        ValueBuilder<bool>(
            initialValue: initialValue,
            onUpdate: onUpdate,
            builder: (newValue, updateFn) {
              return Container(
                width: width,
                height: height,
                child: NeumorphicCheckbox(
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  onChanged: updateFn,
                  value: newValue,
                ),
              );
            })
      ]),
    );
  }
}

// ^ Builds Overlay Based Positional Dropdown Menu ^ //
class SonrDropdown extends StatelessWidget {
  // Properties
  final ValueChanged<int> onChanged;
  final EdgeInsets margin;
  final double width;
  final double height;

  // Overlay Properties
  final double overlayHeight;
  final double overlayWidth;
  final EdgeInsets overlayMargin;
  final WidgetPosition selectedIconPosition;

  // References
  final List<SonrDropdownItem> items;
  final String title;
  final RxInt index = (-1).obs;

  // * Builds Social Media Dropdown * //
  factory SonrDropdown.social(List<Contact_SocialTile_Provider> data,
      {@required ValueChanged<int> onChanged, EdgeInsets margin = const EdgeInsets.only(left: 14, right: 14), double width, double height = 60}) {
    var items = List<SonrDropdownItem>.generate(data.length, (index) {
      return SonrDropdownItem(true, data[index].toString(), icon: data[index].icon(IconType.Gradient));
    });
    return SonrDropdown(items, "Choose", onChanged, margin, width ?? Get.width - 250, height);
  }

  // * Builds Albums Dropdown * //
  factory SonrDropdown.albums(List<MediaCollection> data,
      {@required ValueChanged<int> onChanged, EdgeInsets margin = const EdgeInsets.only(left: 14, right: 14), double width, double height = 60}) {
    var items = List<SonrDropdownItem>.generate(data.length, (index) {
      if (data[index].name != null) {
        // Initialize
        var collection = data[index];
        var hasIcon = false;
        var icon;

        // Set Icon for Generated Albums
        switch (collection.name.toLowerCase()) {
          case "all":
            hasIcon = true;
            icon = SonrIcon.gradient(Icons.all_inbox_rounded, FlutterGradientNames.premiumDark, size: 20);
            break;
          case "sonr":
            hasIcon = true;
            icon = SonrIcon.sonr;
            break;
          case "download":
            hasIcon = true;
            icon = SonrIcon.gradient(Icons.download_rounded, FlutterGradientNames.orangeJuice, size: 20);
            break;
          case "screenshots":
            hasIcon = true;
            icon = SonrIcon.screenshots;
            break;
          case "movies":
            hasIcon = true;
            icon = SonrIcon.gradient(Icons.movie_creation_outlined, FlutterGradientNames.lilyMeadow, size: 20);
            break;
          case "panoramas":
            hasIcon = true;
            icon = SonrIcon.panorama;
            break;
          case "favorites":
            hasIcon = true;
            icon = SonrIcon.gradient(Icons.star_half_rounded, FlutterGradientNames.fruitBlend, size: 20);
            break;
          case "recents":
            hasIcon = true;
            icon = SonrIcon.gradient(Icons.timelapse, FlutterGradientNames.crystalline, size: 20);
            break;
          default:
            hasIcon = false;
        }
        // Return Item
        return SonrDropdownItem(hasIcon, collection.name, icon: icon);
      } else {
        return null;
      }
    });
    return SonrDropdown(items, "All", onChanged, margin, width ?? Get.width - 250, height, selectedIconPosition: WidgetPosition.Left);
  }

  SonrDropdown(this.items, this.title, this.onChanged, this.margin, this.width, this.height,
      {this.overlayHeight, this.overlayWidth, this.overlayMargin, this.selectedIconPosition = WidgetPosition.Right});
  @override
  Widget build(BuildContext context) {
    GlobalKey _dropKey = LabeledGlobalKey("Sonr_Dropdown");
    items.removeWhere((value) => value == null);
    return ObxValue<RxInt>((selectedIndex) {
      return Container(
        key: _dropKey,
        width: width,
        margin: margin,
        height: height,
        child: NeumorphicButton(
            margin: EdgeInsets.symmetric(horizontal: 5),
            style: SonrStyle.flat,
            child: Center(child: _buildSelected(selectedIndex.value, Get.find<SonrPositionedOverlay>().overlays.length > 0)),
            onPressed: () {
              SonrPositionedOverlay.dropdown(items, _dropKey, (newIndex) {
                selectedIndex(newIndex);
                onChanged(newIndex);
              }, height: overlayHeight, width: overlayWidth, margin: overlayMargin);
            }),
      );
    }, index);
  }

  _buildSelected(int idx, bool isOpen) {
    // @ Default Widget
    if (idx == -1) {
      return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, crossAxisAlignment: CrossAxisAlignment.center, children: [
        Expanded(child: SonrText.medium(title, color: Colors.black87, size: height / 3)),
        Padding(padding: EdgeInsets.all(4)),
        isOpen
            ? SonrIcon.normal(Icons.arrow_upward_rounded, color: Colors.black)
            : SonrIcon.normal(Icons.arrow_downward_rounded, color: Colors.black),
      ]);
    }

    // @ Selected Widget
    else {
      var item = items[idx];
      if (selectedIconPosition == WidgetPosition.Left) {
        return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, crossAxisAlignment: CrossAxisAlignment.center, children: [
          item.hasIcon ? item.icon : Container(),
          Padding(padding: EdgeInsets.all(4)),
          Expanded(child: SonrText.medium(item.text, color: Colors.black87, size: height / 3)),
        ]);
      } else {
        return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, crossAxisAlignment: CrossAxisAlignment.center, children: [
          Expanded(child: SonrText.medium(item.text, color: Colors.black87, size: height / 3)),
          Padding(padding: EdgeInsets.all(4)),
          item.hasIcon ? item.icon : Container(),
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
          child: SonrText.medium(text),
        )
      ]);
    } else {
      return Row(children: [Padding(padding: EdgeInsets.all(4)), SonrText.medium(text, color: Colors.black)]);
    }
  }
}

// ^ Stores SonrRadioRowOption Widget ^ //
class SonrRadioRowOption {
  final Widget child;
  final String title;
  SonrRadioRowOption({@required this.child, @required this.title});

  // * Animated Icon from Type * //
  factory SonrRadioRowOption.animated(ArtboardType type, String title) {
    return SonrRadioRowOption(
        child: RiveContainer(
          height: 60,
          width: 60,
          type: type,
        ),
        title: title);
  }

  // * Static Icon Child * //
  factory SonrRadioRowOption.icon(SonrIcon icon, String title) {
    return SonrRadioRowOption(child: icon, title: title);
  }

  // * Text Only Item * //
  factory SonrRadioRowOption.normal(String title) {
    return SonrRadioRowOption(child: Container(), title: title);
  }
}

// ^ Builds Radio Item Widget ^ //
class SonrRadio extends StatelessWidget {
  final groupValue = (-1).obs;
  final List<SonrRadioRowOption> options;
  final Function(int, String) onUpdated;
  final double width;
  final double height;

  SonrRadio({@required this.options, Key key, @required this.onUpdated, this.width, this.height}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      width: width ?? Get.width,
      height: height ?? 85,
      child: ObxValue<RxInt>(
          (groupValue) => Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: List.generate(options.length, (index) {
                  return SonrRadioItem(
                    value: index,
                    groupValue: groupValue.value,
                    title: options[index].title,
                    child: options[index].child,
                    onChanged: () {
                      groupValue(index);
                      onUpdated(index, options[index].title);
                    },
                  );
                }),
              ),
          groupValue),
    );
  }
}

class SonrRadioItem extends StatelessWidget {
  final int value;
  final int groupValue;
  final Function onChanged;
  final Widget child;
  final String title;

  const SonrRadioItem(
      {@required this.value, @required this.title, @required this.groupValue, @required this.child, Key key, @required this.onChanged})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Column(mainAxisSize: MainAxisSize.min, children: [
      NeumorphicRadio(
        style: NeumorphicRadioStyle(
            unselectedColor: SonrColor.base, selectedColor: SonrColor.base, boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(4))),
        child: child,
        value: value,
        groupValue: groupValue,
        onChanged: (i) => onChanged(),
      ),
      Padding(padding: EdgeInsets.only(top: 4)),
      SonrText.medium(title, size: 14, color: Colors.black),
    ]);
  }
}
