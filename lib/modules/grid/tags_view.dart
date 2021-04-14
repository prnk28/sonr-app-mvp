import 'package:sonr_app/pages/home/home_controller.dart';
import 'package:sonr_app/theme/theme.dart';

// ^ Card Tag View ^ //
class TagsView extends GetView<HomeController> {
  final List<String> tags;

  const TagsView({Key key, this.tags}) : super(key: key);
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

// ^ Card Tag Item ^ //
class _TagItem extends GetView<HomeController> {
  final String data;
  final int index;
  const _TagItem(this.data, this.index, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() => AnimatedContainer(
        decoration: controller.toggleIndex.value == index
            ? BoxDecoration(borderRadius: BorderRadius.circular(40), color: SonrPalette.Primary.withOpacity(0.9))
            : BoxDecoration(),
        constraints: BoxConstraints(maxHeight: 50),
        padding: EdgeInsets.symmetric(vertical: 4, horizontal: 16),
        duration: 150.milliseconds,
        child: controller.toggleIndex.value == index ? data.h6_White : data.h6));
  }
}
