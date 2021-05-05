import 'package:material_floating_search_bar/material_floating_search_bar.dart';
import 'package:sonr_app/style/style.dart';
import 'home_controller.dart';
import 'profile/profile_controller.dart';
import 'remote/remote_controller.dart';

class HomeSearchAppBar extends GetView<HomeController> implements PreferredSizeWidget {
  final Widget title;
  final Widget subtitle;
  final Widget action;

  HomeSearchAppBar({
    this.title,
    this.subtitle,
    this.action,
  });
  @override
  Widget build(BuildContext context) {
    return FloatingSearchAppBar(
      color: Color(0xfff0f6fa).withOpacity(0.85),
      controller: controller.searchBarController,
      height: kToolbarHeight + 64,
      padding: const EdgeInsets.only(left: 14.0, right: 14, top: 28.0),
      actions: [action],
      title: AnimatedSlideSwitcher.fade(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            subtitle != null ? subtitle : Container(),
            title,
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
  Size get preferredSize => Size(Get.width, kToolbarHeight + 64);
}

class HomeActionButton extends GetView<HomeController> {
  HomeActionButton();

  @override
  Widget build(BuildContext context) {
    return Obx(() => AnimatedSlideSwitcher.fade(
          child: _buildView(controller.view.value),
          duration: const Duration(milliseconds: 2500),
        ));
  }

  // @ Build Page View by Navigation Item
  Widget _buildView(HomeView page) {
    // Return View
    if (page == HomeView.Profile) {
      return _ProfileActionButton();
    } else if (page == HomeView.Activity) {
      return ActionButton(
        key: ValueKey<HomeView>(HomeView.Activity),
        icon: SonrIcons.CheckAll.gradient(size: 28),
        onPressed: () => CardService.clearAllActivity(),
      );
    } else if (page == HomeView.Remote) {
      return _RemoteActionButton();
    } else {
      return ActionButton(
        key: ValueKey<HomeView>(HomeView.Main),
        icon: SonrIcons.Search.gradient(size: 28),
        onPressed: () => controller.toggleSearch(),
      );
    }
  }
}

// ^ Profile Action Button Widget ^ //
class _ProfileActionButton extends GetView<ProfileController> {
  @override
  Widget build(BuildContext context) {
    return Obx(() => ActionButton(
          key: ValueKey<HomeView>(HomeView.Main),
          icon: controller.status.value.isViewing
              ? SonrIcons.Edit.gradient(size: 28)
              : SonrIcons.Close.gradient(value: SonrGradient.Critical, size: 28),
          onPressed: () {
            if (controller.status.value.isViewing) {
              controller.setEditingMode();
            } else {
              controller.exitToViewing();
            }
          },
        ));
  }
}

// ^ Profile Action Button Widget ^ //
class _RemoteActionButton extends GetView<RemoteController> {
  @override
  Widget build(BuildContext context) {
    return Obx(() => ActionButton(
          key: ValueKey<HomeView>(HomeView.Main),
          icon: _buildIcon(controller.status.value),
          onPressed: () {
            // Creates New Lobby
            if (controller.status.value.isDefault) {
              controller.create();
            }

            // Destroys Created Lobby
            else if (controller.status.value.isCreated) {
              controller.stop();
            }

            // Exits Lobby
            else if (controller.status.value.isJoined) {
              controller.leave();
            }
          },
        ));
  }

  // @ Builds Icon by Status
  Widget _buildIcon(RemoteViewStatus status) {
    switch (status) {
      case RemoteViewStatus.Created:
        return SonrIcons.Logout.gradient(value: SonrGradient.Critical, size: 28);
        break;
      case RemoteViewStatus.Joined:
        return SonrIcons.Logout.gradient(value: SonrGradient.Critical, size: 28);
        break;
      default:
        return SonrIcons.Plus.gradient(size: 28);
        break;
    }
  }
}
