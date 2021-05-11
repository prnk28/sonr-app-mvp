import 'package:sonr_app/style/style.dart';

class URLGridItemView extends StatelessWidget {
  final TransferCardItem item;
  const URLGridItemView(this.item, {Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ObxValue<RxBool>(
        (isFlipped) => Container(
              width: 160,
              height: 190,
              clipBehavior: Clip.antiAlias,
              decoration: Neumorphic.floating(
                theme: Get.theme,
              ),
              margin: EdgeInsets.all(32),
              child: Stack(children: [
                // Content
                Container(
                  padding: EdgeInsets.all(8),
                  child: GestureDetector(
                    child: AnimatedSlideSwitcher.fade(
                      child: isFlipped.value
                          ? _URLGridItemDetailsView(
                              key: ValueKey<bool>(true),
                              isFlipped: isFlipped,
                              item: item,
                            )
                          : _URLGridItemMainView(
                              key: ValueKey<bool>(false),
                              isFlipped: isFlipped,
                              item: item,
                            ),
                    ),
                  ),
                ),
              ]),
            ),
        false.obs);
  }
}

/// @ Main URL Grid Item View
class _URLGridItemMainView extends StatelessWidget {
  final TransferCardItem? item;
  final RxBool? isFlipped;
  const _URLGridItemMainView({Key? key, this.item, this.isFlipped}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        width: context.widthTransformer(reducedBy: 0.8),
        height: context.heightTransformer(reducedBy: 0.6),
        alignment: Alignment.center,
        child: [
          // Align Back Button
          Align(
              alignment: Alignment.topRight,
              child: GestureDetector(
                onTap: () {
                  isFlipped!(true);
                  isFlipped!.refresh();
                },
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: SonrIcons.About.gradient(value: SonrGradient.Secondary, size: 24),
                ),
              )),

          Spacer(),
        ].column());
  }
}

/// @ Details URL Grid Item View
class _URLGridItemDetailsView extends StatelessWidget {
  final TransferCardItem? item;
  final RxBool? isFlipped;
  const _URLGridItemDetailsView({Key? key, this.item, this.isFlipped}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        width: context.widthTransformer(reducedBy: 0.8),
        height: context.heightTransformer(reducedBy: 0.6),
        alignment: Alignment.center,
        child: [
          [
            // Align Platform
            GestureDetector(
                onTap: () {
                  isFlipped!(false);
                  isFlipped!.refresh();
                },
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: SonrIcons.Backward.gradient(value: SonrGradient.Secondary, size: 24),
                )),

            // Align Compass
            Container(
              padding: EdgeInsets.symmetric(horizontal: 4),
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(40), color: SonrColor.AccentNavy.withOpacity(0.75)),
              // TODO: child: Obx(() => " ${controller.peerVector.value.data.directionString}".h6_White),
            ),
          ].row(mainAxisAlignment: MainAxisAlignment.spaceBetween, crossAxisAlignment: CrossAxisAlignment.center),

          // Space Between
          Spacer(),

          // Device Information
          // TODO: controller.peer.value.platform.grey(size: 92),
          Spacer(),

          // Device Icon and Full Name
          // TODO:"${controller.peer.value.model}".h5,
        ].column());
  }
}
