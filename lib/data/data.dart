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
List<GetPage> get pageRouting => [
      // ** Home Page ** //
      GetPage(
          name: '/home',
          page: () {
            Get.putAsync(() => SonrService().init(), permanent: true);
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
