import 'package:get/get.dart';
import 'package:sonr_app/pages/desktop/window.dart';
import 'package:sonr_app/pages/home/home_page.dart';
import 'package:sonr_app/pages/register/register_page.dart';
import 'package:sonr_app/pages/transfer/transfer_page.dart';
// import 'package:sonr_app/service/device/ble.dart';
import 'package:sonr_app/style/style.dart';
import 'bindings.dart';

/// @ Constant Routing Information
class SonrRouting {
  static get pages => [
        // ** Home Page ** //
        GetPage(
            name: '/home',
            page: () {
              Get.find<SonrService>().connect();
              return HomePage();
            },
            binding: HomeBinding(),
            transition: Transition.fadeIn,
            curve: Curves.easeIn,
            middlewares: [GetMiddleware()]),

        // ** Home Page ** //
        GetPage(
            name: '/desktop',
            page: () {
              return DesktopWindow();
            },
            binding: DesktopBinding(),
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

/// #### Details
/// Handles opening new page to display Cards, Item, or Error
class Details {
  static void openCardsList() {}

  static void openCardsGrid() {}

  static void openDetailContact() {}

  static void openDetailFile() {}

  static void openDetailMedia() {}

  static void openDetailUrl() {}

  static void openErrorConnection() {}

  static void openErrorPermissions() {}

  static void openErrorTransfer() {}
}
