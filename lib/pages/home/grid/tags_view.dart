import 'package:sonr_app/theme/theme.dart';
import 'grid_controller.dart';

// ^ Card Tag View ^ //
class TagsView extends GetView<GridController> {
  final List<Tuple<String, int>> tags;

  const TagsView({Key key, this.tags}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      child: SingleChildScrollView(
        controller: controller.scrollController,
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List<Widget>.generate(
              tags.length,
              (index) => GestureDetector(
                    onTap: () {
                      controller.setTag(tags[index].item2);
                    },
                    child: _TagItem(tags[index].item1, tags[index].item2),
                  )),
        ),
      ),
    );
  }
}

// ^ Card Tag Item ^ //
class _TagItem extends GetView<GridController> {
  final String data;
  final int index;
  const _TagItem(this.data, this.index, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() => AnimatedContainer(
        decoration: controller.tagIndex.value == index
            ? BoxDecoration(borderRadius: BorderRadius.circular(40), color: SonrColor.Secondary.withOpacity(0.9))
            : BoxDecoration(),
        constraints: BoxConstraints(maxHeight: 50),
        padding: EdgeInsets.symmetric(vertical: 4, horizontal: 16),
        duration: 150.milliseconds,
        child: controller.tagIndex.value == index ? data.h6_White : data.h6_Grey));
  }
}
