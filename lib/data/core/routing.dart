import 'package:get/get.dart';
import 'package:sonr_app/pages/explorer/explorer_page.dart';
import 'package:sonr_app/pages/home/home_page.dart';
import 'package:sonr_app/pages/register/register_page.dart';
import 'package:sonr_app/pages/transfer/transfer_page.dart';
// import 'package:sonr_app/service/device/ble.dart';
import 'package:sonr_app/style.dart';
import 'bindings.dart';

/// @ Constant Routing Information
class Route {
  static get pages => [
        // ** Home Page ** //
        GetPage(
            name: '/home',
            page: () {
              if (DeviceService.isMobile) {
                Get.find<SonrService>().connect();
                return HomePage();
              } else {
                return ExplorerPage();
              }
            },
            binding: DeviceService.isMobile ? HomeBinding() : ExplorerBinding(),
            transition: Transition.fadeIn,
            curve: Curves.easeIn,
            middlewares: [GetMiddleware()]),

        // ** Register Page ** //
        GetPage(
          name: '/register',
          page: () => RegisterPage(),
          transition: Transition.fadeIn,
          curve: Curves.easeIn,
          binding: RegisterBinding(),
        ),

        // ** Transfer Page ** //
        GetPage(
          name: '/transfer',
          page: () => TransferScreen(),
          maintainState: false,
          binding: TransferBinding(),
          transition: Transition.fadeIn,
          curve: Curves.easeIn,
        ),
      ];
}
