import 'package:get/get.dart';
import 'package:sonr_app/modules/activity/activity_view.dart';
import 'package:sonr_app/modules/share/share_view.dart';
import 'package:sonr_app/pages/details/pages.dart';
import 'package:sonr_app/pages/explorer/explorer_page.dart';
import 'package:sonr_app/pages/home/home_page.dart';
import 'package:sonr_app/pages/register/register_page.dart';
import 'package:sonr_app/pages/transfer/transfer_page.dart';
import 'package:sonr_app/style.dart';
import 'bindings.dart';

/// @ Enum Values for App Page
enum AppPage { Home, Register, Transfer, Share, Activity, Error, Detail, Posts }

extension AppRoute on AppPage {
  // ^ Static Accessors ^
  /// Returns Current Route Name
  static String get current => Get.currentRoute;

  /// Checks if Current Route is Given Page
  static bool isCurrent(AppPage page) => Get.currentRoute == page.name;

  /// Checks if Current Route is NOT Given Page
  static bool isNotCurrent(AppPage page) => Get.currentRoute != page.name;

  /// Checks Whether Dialog is Currently Open
  static bool get isPopupOpen => Get.isDialogOpen ?? false;

  /// Checks Whether Dialog is Currently Closed
  static bool get isPopupClosed => !isPopupOpen;

  /// Checks Whether BottomSheet is Currently Open
  static bool get isSheetOpen => Get.isBottomSheetOpen ?? false;

  /// Checks Whether BottomSheet is Currently Closed
  static bool get isSheetClosed => !isSheetOpen;

  // ^ AppPage Properties ^
  /// Returns Animation Curve
  Curve get curve => Curves.easeIn;

  /// Returns if this Page maintains State
  bool get maintainState => this == AppPage.Transfer ? false : true;

  /// Returns Middleware for Page
  List<GetMiddleware> get middlewares => this == AppPage.Home ? [GetMiddleware()] : [];

  /// Returns Transition Animation
  Transition get transition => this.isDialog ? Transition.downToUp : Transition.fadeIn;

  /// Returns Binding for Page by Type
  Bindings get binding {
    switch (this) {
      case AppPage.Register:
        return RegisterBinding();
      case AppPage.Transfer:
        return TransferBinding();
      default:
        return DeviceService.isMobile ? HomeBinding() : ExplorerBinding();
    }
  }

  /// If this Page is Full Screen Dialog
  bool get isDialog => this == AppPage.Activity || this == AppPage.Share || this == AppPage.Detail || this == AppPage.Error || this == AppPage.Posts;

  /// Returns Page Name
  String get name {
    switch (this) {
      case AppPage.Register:
        return "/register";
      case AppPage.Transfer:
        return "/transfer";
      default:
        return "/home";
    }
  }

  /// Returns Function to Build Page
  Widget Function() get page {
    switch (this) {
      case AppPage.Register:
        return () => RegisterPage();
      case AppPage.Transfer:
        return () => TransferPage();
      case AppPage.Detail:
        return () => DetailPage();
      case AppPage.Error:
        return () => ErrorPage();
      case AppPage.Posts:
        return () => PostsPage();
      case AppPage.Share:
        return () => SharePopupView();
      case AppPage.Activity:
        return () => ActivityPopup();

      default:
        return () {
          if (DeviceService.isMobile) {
            Get.find<SonrService>().connect();
            return HomePage();
          } else {
            return ExplorerPage();
          }
        };
    }
  }

  // ^ AppPage Methods ^
  /// Function Builds `GetPage` instance from `AppPage` Properties
  GetPage config() => GetPage(
        binding: this.binding,
        curve: this.curve,
        maintainState: this.maintainState,
        middlewares: this.middlewares,
        name: this.name,
        page: this.page,
        transition: this.transition,
      );

  /// Pop the current named [page] in the stack and push a new one in its place
  Future<void> off({
    dynamic args,
    void Function()? init,
    Duration? delay,
    bool condition = true,
    bool closeCurrent = false,
  }) async {
    // Init Function
    if (init != null) {
      init();
    }

    // Check for Close Current
    if (closeCurrent) {
      close();
    }

    // Check for Condition
    if (condition) {
      // Shift Screen
      if (delay != null) {
        Future.delayed(delay, () => Get.offNamed(this.name, arguments: args));
      } else {
        Get.offNamed(this.name, arguments: args);
      }
    }
  }

  /// Pushes a new named [page] to the stack.
  Future<void> to({
    dynamic args,
    void Function()? init,
    Duration? delay,
    bool condition = true,
    bool closeCurrent = false,
  }) async {
    // Init Function
    if (init != null) {
      init();
    }

    // Check for Close Current
    if (closeCurrent) {
      close();
    }

    // Check for Condition
    if (condition) {
      // Push Screen
      if (this.isDialog) {
        // Check Delay
        if (delay != null) {
          Future.delayed(delay, () => Get.to(this.page(), transition: this.transition));
        } else {
          Get.to(this.page(), transition: this.transition);
        }
      }
    }
  }

  /// Pushes a Popup Modal
  static Future<void> popup(
    Widget child, {
    bool ignoreSafeArea = false,
    bool dismissible = true,
    dynamic args,
    void Function()? init,
    Duration? delay,
  }) async {
    if (isPopupClosed) {
      if (init != null) {
        init();
      }
      Get.dialog(
        BlurredBackground(child: child),
        barrierDismissible: dismissible,
        barrierColor: Colors.transparent,
        useSafeArea: !ignoreSafeArea,
      );
    }
  }

  /// Pushes a BottomSheet View
  static Future<void> sheet(
    Widget child, {
    Key? key,
    bool forced = false,
    bool ignoreSafeArea = false,
    double elevation = 8,
    bool dismissible = true,
    bool persistent = false,
    Function(DismissDirection)? onDismissed,
    dynamic args,
    void Function()? init,
    Duration? delay,
  }) async {
    // Check if Forced Open
    if (forced) {
      closeSheet();
    }

    if (init != null) {
      init();
    }

    // Open Sheet
    if (isSheetClosed) {
      Get.bottomSheet(
          dismissible
              ? BlurredBackground(
                  child: Dismissible(
                    key: key!,
                    child: child,
                    direction: DismissDirection.down,
                    onDismissed: onDismissed!,
                  ),
                )
              : BlurredBackground(child: child),
          isDismissible: dismissible,
          persistent: persistent,
          barrierColor: Colors.transparent,
          ignoreSafeArea: ignoreSafeArea,
          elevation: 0);
    }
  }

  /// Closes Current Page
  static void close() {
    Get.back(closeOverlays: true);
  }

  /// Closes Active Popup
  static void closePopup() {
    if (isPopupOpen) {
      Get.back(closeOverlays: true);
    }
  }

  /// Closes Active Popup
  static void closeSheet() {
    if (isSheetOpen) {
      Get.back(closeOverlays: true);
    }
  }
}
