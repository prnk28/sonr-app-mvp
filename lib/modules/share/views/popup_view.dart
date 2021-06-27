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
      Future.delayed(500.milliseconds, () {
        WidgetsBinding.instance!.addPostFrameCallback((_) => ShowCaseWidget.of(context)!.startShowCase([
              Get.find<ShareController>().keyOne,
              Get.find<ShareController>().keyTwo,
              Get.find<ShareController>().keyThree,
              Get.find<ShareController>().keyFour,
              Get.find<ShareController>().keyFive,
            ]));
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
        backgroundColor: AppTheme.backgroundColor,
        appBar: DetailAppBar(
          title: "Share",
          onPressed: () => controller.close(),
          action: AnimatedScale(
              scale: _buildScale(controller.hasSelected.value),
              child: ShowcaseItem.fromType(
                type: ShowcaseType.ShareConfirm,
                child: ActionButton(
                  onPressed: () => controller.confirmMediaSelection(),
                  iconData: SonrIcons.Share,
                  banner: Logger.userAppFirstTime ? null : ActionBanner.count(controller.selectedItems.length),
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
              backgroundColor: AppTheme.backgroundColor,
              forceElevated: false,
            ),
            SliverPadding(padding: EdgeInsets.only(top: 24)),
            // @ Builds List of Social Tile
            Obx(() {
              if (controller.status.value.isReady) {
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
                return SliverToBoxAdapter(child: Center(child: HourglassIndicator()));
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
    if (Logger.userAppFirstTime) {
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
        VerticalDivider(color: AppTheme.dividerColor),
        ShowcaseItem.fromType(type: ShowcaseType.ContactPick, child: const _ShareContactButtonItem()),
        VerticalDivider(color: AppTheme.dividerColor),
        ShowcaseItem.fromType(type: ShowcaseType.FilePick, child: const _ShareFileButtonItem()),
      ]),
    );
  }
}

/// @ Camera Share Button
class _ShareCameraButtonItem extends GetView<ShareController> {
  const _ShareCameraButtonItem();
  @override
  Widget build(BuildContext context) {
    return FadeInDownBig(
      delay: 225.milliseconds,
      duration: [265.milliseconds, 225.milliseconds, 285.milliseconds, 245.milliseconds, 300.milliseconds].random(),
      child: ImageButton(
        label: 'Camera',
        imageWidth: K_ROW_BUTTON_SIZE,
        imageHeight: K_ROW_BUTTON_SIZE,
        circleSize: K_ROW_CIRCLE_SIZE,
        onPressed: controller.chooseCamera,
        path: 'assets/images/Camera.png',
      ),
    );
  }
}

/// @ File Share Button
class _ShareFileButtonItem extends GetView<ShareController> {
  const _ShareFileButtonItem();
  @override
  Widget build(BuildContext context) {
    return FadeInDownBig(
        delay: 225.milliseconds,
        duration: [265.milliseconds, 225.milliseconds, 285.milliseconds, 245.milliseconds, 300.milliseconds].random(),
        child: ImageButton(
          label: 'File',
          imageWidth: K_ROW_BUTTON_SIZE,
          imageHeight: K_ROW_BUTTON_SIZE,
          circleSize: K_ROW_CIRCLE_SIZE,
          onPressed: controller.chooseFile,
          path: 'assets/images/Folder.png',
        ));
  }
}

/// @ Contact Share Button
class _ShareContactButtonItem extends GetView<ShareController> {
  const _ShareContactButtonItem();
  @override
  Widget build(BuildContext context) {
    return FadeInDownBig(
        delay: 225.milliseconds,
        duration: [265.milliseconds, 225.milliseconds, 285.milliseconds, 245.milliseconds, 300.milliseconds].random(),
        child: ImageButton(
          label: 'Contact',
          imageWidth: K_ROW_BUTTON_SIZE,
          imageHeight: K_ROW_BUTTON_SIZE,
          circleSize: K_ROW_CIRCLE_SIZE,
          onPressed: controller.chooseContact,
          path: 'assets/images/Contact.png',
        ));
  }
}
