import 'package:get/get.dart';
import 'package:sonr_app/modules/home/home_screen.dart';
import 'package:sonr_app/modules/profile/profile_screen.dart';
import 'package:sonr_app/modules/register/register_screen.dart';
import 'package:sonr_app/modules/transfer/transfer_screen.dart';
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
                Get.find<SonrService>().connect(contact: UserService.current.contact);
              } else {
                Get.find<SonrService>().connect();
              }
              return HomeScreen();
            },
            transition: Transition.topLevel,
            curve: Curves.easeIn,
            middlewares: [GetMiddleware()]),

        // ** Home Page ** //
        GetPage(name: '/home/received', page: () => HomeScreen(), transition: Transition.fadeIn, curve: Curves.easeOut),

        // ** Home Page - Back from Transfer ** //
        GetPage(name: '/home/transfer', page: () => HomeScreen(), transition: Transition.upToDown, curve: Curves.bounceIn),

        // ** Home Page - Back from Profile ** //
        GetPage(name: '/home/profile', page: () => HomeScreen(), transition: Transition.downToUp, curve: Curves.easeOut),

        // ** Register Page ** //
        GetPage(name: '/register', page: () => StartedScreen(), transition: Transition.fade, curve: Curves.easeIn),

        // ** Transfer Page ** //
        GetPage(
            name: '/transfer',
            page: () => TransferScreen(),
            maintainState: false,
            transition: Transition.downToUp,
            curve: Curves.bounceOut,
            binding: TransferBinding()),

        // ** Profile Page ** //
        GetPage(name: '/profile', page: () => ProfileScreen(), transition: Transition.upToDown, curve: Curves.easeIn, binding: ProfileBinding()),
      ];

  // ^ Services (Files, Contacts) ^ //
  static initServices() async {
    await Get.putAsync(() => DeviceService().init(), permanent: true); // First Required Service
    await Get.putAsync(() => UserService().init(), permanent: true); // Second Required Service
    await Get.putAsync(() => PermissionService().init(), permanent: true); // Third Required Service
    await Get.putAsync(() => MediaService().init(), permanent: true);
    await Get.putAsync(() => SQLService().init(), permanent: true);
    await Get.putAsync(() => LobbyService().init(), permanent: true);
    await Get.putAsync(() => SonrService().init(), permanent: true);
    await Get.putAsync(() => SonrOverlay().init(), permanent: true);
    await Get.putAsync(() => SonrPositionedOverlay().init(), permanent: true);
  }

  // ^ Method Validates Required Services Registered ^ //
  static bool get areServicesRegistered {
    return DeviceService.isRegistered &&
        UserService.isRegistered &&
        PermissionService.isRegistered &&
        MediaService.isRegistered &&
        SQLService.isRegistered &&
        LobbyService.isRegistered &&
        UserService.isRegistered;
  }
}
