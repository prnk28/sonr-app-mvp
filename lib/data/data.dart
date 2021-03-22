export 'model/model_file.dart';
export 'model/model_tile.dart';
export 'api/api_models.dart';
export 'api/api_primitive.dart';
export 'api/api_widgets.dart';
export 'model/model_register.dart';

import 'package:get/get.dart';
import 'package:sonr_app/modules/home/home_binding.dart';
import 'package:sonr_app/modules/profile/profile_binding.dart';
import 'package:sonr_app/modules/register/register_binding.dart';
import 'package:sonr_app/modules/transfer/transfer_binding.dart';
import 'package:sonr_app/theme/theme.dart';

// ^ Constant Routing Information ^ //
class SonrRoutes {
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
            binding: HomeBinding(),
            middlewares: [GetMiddleware()]),

        // ** Home Page ** //
        GetPage(name: '/home/received', page: () => HomeScreen(), transition: Transition.fadeIn, curve: Curves.easeIn, binding: HomeBinding()),

        // ** Home Page - Back from Transfer ** //
        GetPage(name: '/home/transfer', page: () => HomeScreen(), transition: Transition.upToDown, curve: Curves.easeIn, binding: HomeBinding()),

        // ** Home Page - Back from Profile ** //
        GetPage(name: '/home/profile', page: () => HomeScreen(), transition: Transition.downToUp, curve: Curves.easeIn, binding: HomeBinding()),

        // ** Register Page ** //
        GetPage(name: '/register', page: () => RegisterScreen(), transition: Transition.fade, curve: Curves.easeIn, binding: RegisterBinding()),

        // ** Transfer Page ** //
        GetPage(
            name: '/transfer',
            page: () => TransferScreen(),
            maintainState: false,
            transition: Transition.downToUp,
            curve: Curves.easeIn,
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
    await Get.putAsync(() => SonrService().init(), permanent: true);
    await Get.putAsync(() => SonrOverlay().init(), permanent: true);
    await Get.putAsync(() => SonrPositionedOverlay().init(), permanent: true);
  }
}

// ^ Initial Controller Bindings ^ //
class InitialBinding implements Bindings {
  @override
  void dependencies() {
    Get.create<TransferCardController>(() => TransferCardController());
    Get.create<AnimatedController>(() => AnimatedController());
    Get.lazyPut<CameraController>(() => CameraController());
  }
}
