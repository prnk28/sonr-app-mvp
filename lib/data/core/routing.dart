import 'package:get/get.dart';
import 'package:sonr_app/pages/desktop/window.dart';
import 'package:sonr_app/pages/home/home_page.dart';
import 'package:sonr_app/pages/register/register_page.dart';
import 'package:sonr_app/pages/transfer/transfer_page.dart';
// import 'package:sonr_app/service/device/ble.dart';
import 'package:sonr_app/service/device/desktop.dart';
import 'package:sonr_app/service/device/mobile.dart';
import 'package:sonr_app/service/device/auth.dart';
import 'package:sonr_app/service/user/cards.dart';
import 'package:sonr_app/service/client/lobby.dart';
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

  /// @ Application Services
  static initServices({bool isDesktop = false}) async {
    // First: Device Services
    await Get.putAsync(() => DeviceService().init(), permanent: true);
    if (isDesktop) {
      await Get.putAsync(() => DesktopService().init(), permanent: true);
    } else {
      await Get.putAsync(() => AuthService().init(), permanent: true);
      await Get.putAsync(() => MobileService().init(), permanent: true);
      //await Get.putAsync(() => BLEService().init(), permanent: true);
    }

    // Second: User Services
    await Get.putAsync(() => UserService().init(), permanent: true);

    // Third: Initialize Data/Networking Services
    await Get.putAsync(() => TransferService().init(), permanent: true);
    await Get.putAsync(() => CardService().init(), permanent: true);
    await Get.putAsync(() => LobbyService().init(), permanent: true);
    await Get.putAsync(() => SonrService().init(), permanent: true);

    // Fourth: UI Services
    await Get.putAsync(() => SonrOverlay().init(), permanent: true);
    await Get.putAsync(() => SonrPositionedOverlay().init(), permanent: true);
  }

  /// @ Method Validates Required Services Registered
  static bool get areServicesRegistered {
    return DeviceService.isRegistered &&
        UserService.isRegistered &&
        CardService.isRegistered &&
        LobbyService.isRegistered &&
        UserService.isRegistered;
  }

  static List<String> get excludedModules => [
        'open_file',
        'animated_widgets',
        'get',
        'path_provider',
        'camerawesome_plugin',
        'file_picker',
      ];
}
