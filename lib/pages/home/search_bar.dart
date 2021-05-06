import 'package:material_floating_search_bar/material_floating_search_bar.dart';
import 'package:sonr_app/style/style.dart';
import 'action_button.dart';
import 'home_controller.dart';

class HomeAppBar extends GetView<HomeController> implements PreferredSizeWidget {
  @override
  Widget build(BuildContext context) {
    return Obx(() => AnimatedSlideSwitcher.fade(
          duration: 2.seconds,
          child: controller.view.value.isMain
              ? _HomeSearchAppBar(
                  key: ValueKey(true),
                  subtitle: _HomeAppBarSubtitle(),
                  action: HomeActionButton(),
                  title: _HomeAppBarTitle(),
                )
              : DesignAppBar(
                  key: ValueKey(false),
                  subtitle: _HomeAppBarSubtitle(),
                  action: HomeActionButton(),
                  title: _HomeAppBarTitle(),
                ),
        ));
  }

  @override
  Size get preferredSize => Size(Get.width, kToolbarHeight + 82);
}

class _HomeAppBarTitle extends GetView<HomeController> {
  @override
  Widget build(BuildContext context) {
    return Obx(() => AnimatedSlideSwitcher.fade(
          duration: 2.seconds,
          child: GestureDetector(
            key: ValueKey<String>(controller.titleText.value),
            onTap: () {
              if (controller.isTitleVisible.value) {
                controller.swapTitleText(
                  "${LobbyService.local.value!.count} Around",
                  timeout: 2500.milliseconds,
                );
              }
            },
            child: controller.titleText.value.headThree(
              color: SonrColor.Black,
              weight: FontWeight.w800,
              align: TextAlign.start,
            ),
          ),
        ));
  }
}

class _HomeAppBarSubtitle extends GetView<HomeController> {
  @override
  Widget build(BuildContext context) {
    return Obx(() => controller.view.value == HomeView.Main
        ? "Hi ${UserService.contact.value.firstName},".headThree(
            color: SonrColor.Black,
            weight: FontWeight.w400,
            align: TextAlign.start,
          )
        : Container());
  }
}

class _HomeSearchAppBar extends GetView<HomeController> implements PreferredSizeWidget {
  final Widget? title;
  final Widget? subtitle;
  final Widget? action;

  _HomeSearchAppBar({this.title, this.subtitle, this.action, Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return FloatingSearchAppBar(
      color: Color(0xfff0f6fa).withOpacity(0.85),
      controller: controller.searchBarController,
      height: kToolbarHeight + 64,
      padding: const EdgeInsets.only(left: 14.0, right: 14, top: 24.0, bottom: 8),
      actions: [action!],
      title: AnimatedSlideSwitcher.fade(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            subtitle != null ? subtitle! : Container(),
            title!,
          ],
        ),
      ),
      hint: 'Search...',
      transitionDuration: const Duration(milliseconds: 100),
      transitionCurve: Curves.easeInOut,
      onQueryChanged: (query) {},
      body: ListView.separated(
        padding: EdgeInsets.zero,
        itemCount: 100,
        separatorBuilder: (context, index) => const Divider(),
        itemBuilder: (context, index) {
          return ListTile(
            title: Text('Item $index'),
          );
        },
      ),
    );
  }

  @override
  Size get preferredSize => Size(Get.width, kToolbarHeight + 82);
}
