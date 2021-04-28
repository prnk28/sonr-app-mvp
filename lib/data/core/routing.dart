import 'package:get/get.dart';
import 'package:sonr_app/pages/home/home_page.dart';
import 'package:sonr_app/pages/register/register_page.dart';
import 'package:sonr_app/pages/transfer/transfer_page.dart';
import 'package:sonr_app/service/device/desktop.dart';
import 'package:sonr_app/service/user/cards.dart';
import 'package:sonr_app/service/client/lobby.dart';
import 'package:sonr_app/theme/theme.dart';
import 'bindings.dart';

// ^ Constant Routing Information ^ //
class SonrRouting {
  static get pages => [
        // ** Home Page ** //
        GetPage(
            name: '/home',
            page: () {
              // Update Contact for New User
              if (UserService.isNewUser.value) {
                Get.find<SonrService>().connectNewUser(UserService.contact.value, UserService.username);
              } else {
                Get.find<SonrService>().connect();
              }
              return HomePage();
            },
            binding: HomeBinding(),
            transition: Transition.topLevel,
            curve: Curves.easeIn,
            middlewares: [GetMiddleware()]),

        // ** Register Page ** //
        GetPage(name: '/register', page: () => RegisterPage(), transition: Transition.fade, curve: Curves.easeIn, binding: RegisterBinding()),

        // ** Transfer Page ** //
        GetPage(
            name: '/transfer',
            page: () => TransferScreen(),
            binding: TransferBinding(),
            transition: Transition.downToUp,
            curve: Curves.easeIn,
            fullscreenDialog: true),
      ];

  // ^ Mobile Services ^ //
  static initMobileServices() async {
    await Get.putAsync(() => MobileService().init(), permanent: true);
    await Get.putAsync(() => UserService().init(), permanent: true);
    await Get.putAsync(() => FileService().init(), permanent: true);
    await Get.putAsync(() => MediaService().init(), permanent: true);
    await Get.putAsync(() => CardService().init(), permanent: true);
    await Get.putAsync(() => LobbyService().init(), permanent: true);
    await Get.putAsync(() => SonrService().init(), permanent: true);
    await Get.putAsync(() => SonrOverlay().init(), permanent: true);
    await Get.putAsync(() => SonrPositionedOverlay().init(), permanent: true);
  }

  // ^ Desktop Services ^ //
  static initDesktopServices() async {
    await Get.putAsync(() => DesktopService().init(), permanent: true);
    await Get.putAsync(() => UserService().init(), permanent: true);
    await Get.putAsync(() => FileService().init(), permanent: true);
    await Get.putAsync(() => CardService().init(), permanent: true);
    await Get.putAsync(() => SonrService().init(), permanent: true);
  }

  // ^ Method Validates Required Services Registered ^ //
  static bool get areServicesRegistered {
    return MobileService.isRegistered &&
        UserService.isRegistered &&
        MediaService.isRegistered &&
        CardService.isRegistered &&
        LobbyService.isRegistered &&
        UserService.isRegistered;
  }
}
