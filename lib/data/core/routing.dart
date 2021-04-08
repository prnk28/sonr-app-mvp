import 'package:get/get.dart';
import 'package:sonr_app/pages/home/home_screen.dart';
import 'package:sonr_app/pages/register/form_page.dart';
import 'package:sonr_app/pages/transfer/transfer_screen.dart';
import 'package:sonr_app/service/cards.dart';
import 'package:sonr_app/service/lobby.dart';
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
                Get.find<SonrService>().connectNewUser(UserService.current.contact, UserService.username);
              } else {
                Get.find<SonrService>().connect();
              }
              return HomeScreen();
            },
            binding: HomeBinding(),
            transition: Transition.topLevel,
            curve: Curves.easeIn,
            middlewares: [GetMiddleware()]),

        // ** Home Page - Back from Transfer ** //
        GetPage(
          name: '/home/transfer',
          page: () => HomeScreen(),
          transition: Transition.upToDown,
          curve: Curves.bounceIn,
          binding: HomeBinding(),
        ),

        // ** Register Page ** //
        GetPage(name: '/register', page: () => FormPage(), transition: Transition.fade, curve: Curves.easeIn),

        // ** Transfer Page ** //
        GetPage(name: '/transfer', page: () => TransferScreen(), maintainState: false, transition: Transition.downToUp, curve: Curves.bounceOut),
      ];

  // ^ Services (Files, Contacts) ^ //
  static initServices() async {
    await Get.putAsync(() => DeviceService().init(), permanent: true); // First Required Service
    await Get.putAsync(() => UserService().init(), permanent: true); // Second Required Service
    await Get.putAsync(() => MediaService().init(), permanent: true);
    await Get.putAsync(() => CardService().init(), permanent: true);
    await Get.putAsync(() => LobbyService().init(), permanent: true);
    await Get.putAsync(() => SonrService().init(), permanent: true);
    await Get.putAsync(() => SonrOverlay().init(), permanent: true);
    await Get.putAsync(() => SonrPositionedOverlay().init(), permanent: true);
  }

  // ^ Method Validates Required Services Registered ^ //
  static bool get areServicesRegistered {
    return DeviceService.isRegistered &&
        UserService.isRegistered &&
        MediaService.isRegistered &&
        CardService.isRegistered &&
        LobbyService.isRegistered &&
        UserService.isRegistered;
  }
}
