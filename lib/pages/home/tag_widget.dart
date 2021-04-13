import 'dart:ui';

import '../../theme/theme.dart';
import 'home_controller.dart';

class TagView extends GetView<HomeController> {
  final List<Tuple<Icon, String>> tags;

  const TagView({Key key, this.tags}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return OpacityAnimatedWidget(
      enabled: true,
      delay: 100.milliseconds,
      duration: 100.milliseconds,
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List<Widget>.generate(
              tags.length,
              (index) => GestureDetector(
                    onTap: () {
                      controller.setToggleCategory(index);
                    },
                    child: _TagItem(tags[index], index),
                  )),
        ),
      ),
    );
  }
}

class _TagItem extends GetView<HomeController> {
  final Tuple<Icon, String> data;
  final int index;
  const _TagItem(this.data, this.index, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() => AnimatedContainer(
          decoration: controller.toggleIndex.value == index
              ? BoxDecoration(borderRadius: BorderRadius.circular(40), color: SonrPalette.Primary.withOpacity(0.9))
              : BoxDecoration(borderRadius: BorderRadius.circular(40), color: SonrColor.Neutral.withOpacity(0.75)),
          constraints: BoxConstraints(maxHeight: 50),
          padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
          duration: 150.milliseconds,
          child: RichText(
            text: TextSpan(
              children: [
                WidgetSpan(
                  child: data.item1,
                ),
                TextSpan(
                    text: "  ${data.item2}",
                    style: TextStyle(
                      fontFamily: "Manrope",
                      fontWeight: FontWeight.w700,
                      fontSize: 20,
                      color: SonrColor.White,
                      fontFeatures: [
                        FontFeature.tabularFigures(),
                      ],
                    )),
              ],
            ),
          ),
        ));
  }
}
