import 'package:get/get.dart';
import '../theme.dart';

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
        label ?? label.p,

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
            unselectedColor: SonrColor.White, selectedColor: SonrColor.White, boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(4))),
        child: child,
        value: value,
        groupValue: groupValue,
        onChanged: (i) => onChanged(),
      ),
      Padding(padding: EdgeInsets.only(top: 4)),
      title.p,
    ]);
  }
}

// ^ Stores SonrRadioRowOption Widget ^ //
class SonrRadioRowOption {
  final Widget child;
  final String title;
  SonrRadioRowOption({@required this.child, @required this.title});

  // * Animated Icon from Type * //
  factory SonrRadioRowOption.animated(RiveBoard type, String title) {
    return SonrRadioRowOption(
        child: RiveContainer(
          height: 60,
          width: 60,
          type: type,
        ),
        title: title);
  }

  // * Static Icon Child * //
  factory SonrRadioRowOption.icon(Icon icon, String title) {
    return SonrRadioRowOption(child: icon, title: title);
  }

  // * Text Only Item * //
  factory SonrRadioRowOption.normal(String title) {
    return SonrRadioRowOption(child: Container(), title: title);
  }
}
