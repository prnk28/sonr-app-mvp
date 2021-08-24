import 'package:get/get.dart';
import 'package:sonr_app/modules/share/share.dart';
import 'package:sonr_app/modules/share/widgets/media_item.dart';
import 'package:sonr_app/style/style.dart';

class SharePopupView extends StatefulWidget {
  @override
  _SharePopupViewState createState() => _SharePopupViewState();
}

class _SharePopupViewState extends State<SharePopupView> {
  @override
  void initState() {
    super.initState();
    if (AppPage.Share.needsOnboarding) {
      Future.delayed(300.milliseconds, () {
        WidgetsBinding.instance!.addPostFrameCallback(
          (_) => ShowCaseWidget.of(context)!.startShowCase(AppPage.Share.onboardingItems),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ShareController>();
    return Obx(() => Scaffold(
        extendBodyBehindAppBar: false,
        extendBody: true,
        resizeToAvoidBottomInset: false,
        backgroundColor: AppTheme.BackgroundColor,
        appBar: DetailAppBar(
          title: "Share",
          onPressed: () => controller.close(),
          action: AnimatedScale(
              scale: _buildScale(controller.hasSelected.value),
              duration: 700.milliseconds,
              child: ShowcaseItem.fromType(
                type: ShowcaseType.ShareConfirm,
                child: ActionButton(
                  onPressed: () => controller.confirmMediaSelection(),
                  iconData: SimpleIcons.Share,
                  banner: Logger.appOpenFirst ? null : ActionBanner.count(controller.selectedItems.length),
                ),
              )),
        ),
        body: Stack(children: [
          CustomScrollView(slivers: [
            // @ Builds Profile Header
            SliverToBoxAdapter(child: ShareOptionsRow()),

            SliverAppBar(
              title: AlbumHeader(),
              pinned: true,
              floating: true,
              automaticallyImplyLeading: false,
              backgroundColor: AppTheme.BackgroundColor,
              forceElevated: false,
            ),
            SliverPadding(padding: EdgeInsets.only(top: 24)),
            // @ Builds List of Social Tile
            Obx(() {
              if (controller.viewStatus.value.isReady) {
                return SliverGrid(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        return MediaItem(
                          item: controller.currentAlbum.value.entityAtIndex(index),
                        );
                      },
                      childCount: controller.currentAlbum.value.length,
                    ),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      mainAxisSpacing: 4.0,
                      crossAxisSpacing: 4.0,
                    ));
              } else {
                return SliverToBoxAdapter(
                    child: Container(
                        width: Get.width,
                        height: Get.height / 2.5,
                        child: Center(
                            child: CircleLoader(
                          scale: 2,
                        ))));
              }
            })
          ]),
          // Align(
          //   alignment: Alignment.bottomCenter,
          //   child: ShareConfirmSheet(),
          // )
        ])));
  }

  double _buildScale(bool hasSelected) {
    if (Logger.appOpenFirst) {
      return 1.0;
    } else {
      if (hasSelected) {
        return 1.0;
      } else {
        return 0.0;
      }
    }
  }
}

class ShareOptionsRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: Height.ratio(0.2),
      width: Get.width,
      padding: EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 16),
      child: Row(crossAxisAlignment: CrossAxisAlignment.center, mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
        ShowcaseItem.fromType(type: ShowcaseType.CameraPick, child: const _ShareCameraButtonItem()),
        VerticalDivider(color: AppTheme.DividerColor),
        ShowcaseItem.fromType(type: ShowcaseType.ContactPick, child: const _ShareContactButtonItem()),
        VerticalDivider(color: AppTheme.DividerColor),
        ShowcaseItem.fromType(type: ShowcaseType.FilePick, child: const _ShareFileButtonItem()),
      ]),
    );
  }
}

/// #### Camera Share Button
class _ShareCameraButtonItem extends GetView<ShareController> {
  const _ShareCameraButtonItem();
  @override
  Widget build(BuildContext context) {
    return FadeInDownBig(
      delay: 225.milliseconds,
      duration: [265.milliseconds, 225.milliseconds, 285.milliseconds, 245.milliseconds, 300.milliseconds].random(),
      child: ComplexButton(
        label: 'Camera',
        onPressed: controller.chooseCamera,
        type: ComplexIcons.Camera,
        size: K_ROW_CIRCLE_SIZE,
      ),
    );
  }
}

/// #### File Share Button
class _ShareFileButtonItem extends GetView<ShareController> {
  const _ShareFileButtonItem();
  @override
  Widget build(BuildContext context) {
    return FadeInDownBig(
        delay: 225.milliseconds,
        duration: [265.milliseconds, 225.milliseconds, 285.milliseconds, 245.milliseconds, 300.milliseconds].random(),
        child: ComplexButton(
          label: 'File',
          type: ComplexIcons.Document,
          size: K_ROW_CIRCLE_SIZE,
          onPressed: controller.chooseFile,
        ));
  }
}

/// #### Contact Share Button
class _ShareContactButtonItem extends GetView<ShareController> {
  const _ShareContactButtonItem();
  @override
  Widget build(BuildContext context) {
    return FadeInDownBig(
        delay: 225.milliseconds,
        duration: [265.milliseconds, 225.milliseconds, 285.milliseconds, 245.milliseconds, 300.milliseconds].random(),
        child: ComplexButton(
          label: 'Contact',
          type: ComplexIcons.ContactCard,
          size: K_ROW_CIRCLE_SIZE,
          onPressed: controller.chooseContact,
        ));
  }
}
