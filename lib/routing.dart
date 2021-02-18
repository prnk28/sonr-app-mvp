import 'package:get/get.dart';
import 'package:sonr_app/service/device_service.dart';
import 'package:sonr_app/service/social_service.dart';
import 'package:sonr_app/service/sql_service.dart';
import 'package:sonr_app/theme/theme.dart';

import 'modules/card/card_controller.dart';
import 'modules/home/home_binding.dart';
import 'modules/media/camera_binding.dart';
import 'modules/profile/profile_binding.dart';
import 'modules/register/register_binding.dart';
import 'modules/transfer/transfer_binding.dart';
import 'widgets/overlay.dart';

// ^ Services (Files, Contacts) ^ //
initServices() async {
  await Get.putAsync(() => SQLService().init());
  await Get.putAsync(() => SocialMediaService().init());
  await Get.putAsync(() => DeviceService().init());
}

// ^ Initial Controller Bindings ^ //
class InitialBinding implements Bindings {
  @override
  void dependencies() {
    Get.create<TransferCardController>(() => TransferCardController());
    Get.create<AnimatedController>(() => AnimatedController());
    Get.put(SonrOverlay());
    Get.put<RiveWidgetController>(RiveWidgetController('assets/animations/tile_preview.riv'), permanent: true);
  }
}

// ^ Routing Information ^ //
// ignore: non_constant_identifier_names
List<GetPage> get K_PAGES => [
      // ** Home Page ** //
      GetPage(name: '/home', page: () => HomeScreen(), transition: Transition.zoom, curve: Curves.easeIn, binding: HomeBinding()),

      // ** Home Page - Completed File ** //
      GetPage(
          maintainState: false,
          name: '/home/completed',
          page: () => HomeScreen(),
          transition: Transition.fade,
          curve: Curves.easeIn,
          transitionDuration: 200.milliseconds,
          binding: HomeBinding()),

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

      // ** Camera Page - Default Media View ** //
      GetPage(
          name: '/camera',
          maintainState: false,
          page: () => CameraScreen(),
          transition: Transition.downToUp,
          curve: Curves.easeIn,
          fullscreenDialog: true,
          binding: CameraBinding()),

      // ** Camera Page - Profile Picture View ** //
      GetPage(
          name: '/camera/avatar',
          maintainState: false,
          page: () => CameraScreen(),
          transition: Transition.downToUp,
          curve: Curves.easeIn,
          fullscreenDialog: true,
          binding: CameraBinding()),

      // ** Camera Page - QR Code Scanner ** //
      GetPage(
          name: '/camera/qr',
          maintainState: false,
          page: () => CameraScreen(),
          transition: Transition.downToUp,
          curve: Curves.easeIn,
          fullscreenDialog: true,
          binding: CameraBinding()),

      // ** Profile Page ** //
      GetPage(
          name: '/profile',
          page: () => ProfileScreen(),
          transition: Transition.upToDown,
          curve: Curves.easeIn,
          fullscreenDialog: true,
          binding: ProfileBinding()),
    ];
