import 'package:sonr_app/pages/desktop/views/explorer_view.dart';
import 'package:sonr_app/style/style.dart';
import 'controllers/window_controller.dart';
import 'views/linker_view.dart';

class DesktopWindow extends GetView<WindowController> {
  @override
  Widget build(BuildContext context) {
    return SonrScaffold(
      resizeToAvoidBottomInset: false,
      appBar: DesignAppBar(
        subtitle: Obx(() => controller.view.value == DesktopView.Register
            ? "Hello,".headThree(color: SonrColor.White, weight: FontWeight.w400, align: TextAlign.start)
            : "Hi ${UserService.contact.value.firstName},".headThree(color: SonrColor.White, weight: FontWeight.w400, align: TextAlign.start)),
        title: Obx(() => controller.view.value == DesktopView.Register
            ? "Link your Device".headThree(color: SonrColor.White, weight: FontWeight.w800, align: TextAlign.start)
            : AnimatedSlideSwitcher.fade(
                duration: 2.seconds,
                child: GestureDetector(
                  key: ValueKey<String>(controller.titleText.value),
                  onTap: () {
                    if (controller.isTitleVisible.value) {
                      controller.swapTitleText("${LobbyService.local.value.size} Around", timeout: 2500.milliseconds);
                    }
                  },
                  child: controller.titleText.value.headThree(color: SonrColor.White, weight: FontWeight.w800, align: TextAlign.start),
                ),
              )),
      ),
      body: Obx(() => AnimatedSlideSwitcher.fade(
            duration: 1.seconds,
            child: Container(width: 1200, height: 800, child: _buildView(controller.view.value)),
          )),
    );
  }

  Widget _buildView(DesktopView view) {
    switch (view) {
      case DesktopView.Explorer:
        return ExplorerDesktopView(key: ValueKey<DesktopView>(view));
      case DesktopView.Register:
        return RegisterDesktopView(key: ValueKey<DesktopView>(view));
      default:
        return Container();
    }
  }
}
