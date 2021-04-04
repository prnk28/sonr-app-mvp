import 'package:sonr_app/theme/theme.dart';
import 'form_page.dart';
import 'started_page.dart';

class StartedScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetX<_StartedController>(
      init: _StartedController(),
      builder: (controller) {
        return PageView.builder(
          controller: controller.pageController,
          physics: NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            if (index == 0) {
              return GetStartedPage(controller.shiftToForm());
            } else if (index == 1) {
              return FormPage();
            }
            return FormPage();
          },
        );
      },
    );
  }
}

class _StartedController extends GetxController {
  final index = 0.obs;
  final pageController = PageController();

  shiftToForm() {
    pageController.jumpToPage(1);
    index(1);
  }
}
