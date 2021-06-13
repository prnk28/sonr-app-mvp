import 'package:get/get.dart';
import 'package:sonr_app/pages/explorer/explorer_page.dart';
import 'package:sonr_app/pages/home/home_page.dart';
import 'package:sonr_app/pages/register/register_page.dart';
import 'package:sonr_app/pages/transfer/transfer_page.dart';
import 'package:sonr_app/style.dart';
import 'bindings.dart';

/// @ Enum Values for App Page
enum AppPage { Home, Register, Transfer }

extension AppPageUtils on AppPage {
  // ^ AppPage Properties ^
  /// Returns Binding for Page by Type
  Bindings get binding {
    switch (this) {
      case AppPage.Home:
        return DeviceService.isMobile ? HomeBinding() : ExplorerBinding();
      case AppPage.Register:
        return RegisterBinding();
      case AppPage.Transfer:
        return TransferBinding();
    }
  }

  /// Returns Animation Curve
  Curve get curve {
    return Curves.easeIn;
  }

  /// Returns if this Page maintains State
  bool get maintainState {
    return this == AppPage.Transfer ? false : true;
  }

  /// Returns Middleware for Page
  List<GetMiddleware> get middlewares {
    if (this == AppPage.Home) {
      return [GetMiddleware()];
    }
    return [];
  }

  /// Returns Page Name
  String get name {
    switch (this) {
      case AppPage.Home:
        return "/home";
      case AppPage.Register:
        return "/register";
      case AppPage.Transfer:
        return "/transfer";
    }
  }

  /// Returns Function to Build Page
  Widget Function() get page {
    switch (this) {
      case AppPage.Home:
        return () {
          if (DeviceService.isMobile) {
            Get.find<SonrService>().connect();
            return HomePage();
          } else {
            return ExplorerPage();
          }
        };
      case AppPage.Register:
        return () => RegisterPage();
      case AppPage.Transfer:
        return () => TransferScreen();
    }
  }

  /// Returns Transition Animation
  Transition get transition {
    return Transition.fadeIn;
  }

  // ^ AppPage Methods ^
  /// Function Builds `GetPage` instance from `AppPage` Properties
  GetPage getPage() => GetPage(
        binding: this.binding,
        curve: this.curve,
        maintainState: this.maintainState,
        middlewares: this.middlewares,
        name: this.name,
        page: this.page,
        transition: this.transition,
      );

  /// Pop the current named [page] in the stack and push a new one in its place
  Future offNamed() async {
    Get.offNamed(this.name);
  }

  /// Pushes a new named [page] to the stack.
  Future to() async {
    Get.toNamed(this.name);
  }
}
