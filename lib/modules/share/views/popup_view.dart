import 'package:get/get.dart';
import 'package:sonr_app/modules/share/share.dart';
import 'package:sonr_app/modules/share/widgets/albums_row.dart';
import 'package:sonr_app/modules/share/widgets/media_item.dart';
import 'package:sonr_app/style/style.dart';

class SharePopupView extends GetView<ShareController> {
  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
        extendBodyBehindAppBar: false,
        extendBody: true,
        resizeToAvoidBottomInset: false,
        backgroundColor: AppTheme.backgroundColor,
        appBar: DetailAppBar(
          title: "Share",
          onPressed: () => controller.close(),
          action: AnimatedScale(
              scale: controller.hasSelected.value ? 1.0 : 0.0,
              child: ActionButton(
                onPressed: () => controller.confirmMediaSelection(),
                iconData: SonrIcons.Share,
                banner: ActionBanner.selected(controller.selectedItems.length),
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
}
