import 'dart:async';
import 'package:get/get.dart';
import 'package:sonr_app/modules/activity/activity.dart';
import 'package:sonr_app/modules/share/views/popup_view.dart';
import 'package:sonr_app/pages/details/details.dart';
import 'package:sonr_app/pages/home/home.dart';
import 'package:sonr_app/pages/register/register.dart';
import 'package:sonr_app/pages/transfer/transfer.dart';
import 'package:sonr_app/style.dart';
import 'bindings.dart';

/// @ Enum Values for App Page
enum AppPage {
  /// ### Home `Off`
  /// Dashboard, Search, Personal
  Home,

  /// ### Register `Off`
  /// New User
  Register,

  /// ### Transfer `Off`
  /// Looking for Peers to Share
  Transfer,

  /// ### Share `To`
  /// Select File, Contact, URL
  Share,

  /// ### Activity `To`
  /// Current Sessions, Past Cards
  Activity,

  /// ### Error `To`
  /// Empty Items, No Connection, No Permission
  Error,

  /// ### Detail `To`
  /// TransferCard Detail View
  Detail,

  /// ### Posts List `To`
  /// Transfer Card Collection View
  Posts,

  /// ### FlatMode Overlay `Dialog`
  /// Transfer Subpage For FlatMode
  Flat,
}

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

  /// Checks Whether Snackbar is Currently Open
  static bool get isSnackOpen => Get.isSnackbarOpen ?? true;

  /// Checks Whether Snackbar is Currently Closed
  static bool get isSnackClosed => !isSnackOpen;

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
        return HomeBinding();
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
      case AppPage.Flat:
        return () => FlatModeOverlay();
      default:
        return () {
          if (DeviceService.isMobile) {
            Get.find<NodeService>().connect();
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

  /// Received FlatMode Invite
  Future<void> invite(Contact data) async {
    Get.find<TransferController>().animateFlatSwap(data);
  }

  /// Pop the current named [page] in the stack and push a new one in its place
  Future<void> off({
    dynamic args,
    void Function()? init,
    Duration? delay,
    bool condition = true,
    bool closeCurrent = false,
  }) async {
    // Hide Keyboard Before Route
    DeviceService.keyboardHide();

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

  /// Flat Mode Outgoing
  Future<void> outgoing() async {
    if (this == AppPage.Flat && isPopupClosed) {
      Get.dialog(
        this.page(),
        barrierColor: Colors.transparent,
        useSafeArea: false,
      );
    }
  }

  /// Received FlatMode Response
  Future<void> response(Contact data) async {
    Get.find<TransferController>().animateFlatIn(data, delayModifier: 2);
  }

  /// Pushes a new named [page] to the stack.
  Future<void> to({
    dynamic args,
    void Function()? init,
    Duration? delay,
    bool condition = true,
    bool closeCurrent = false,
  }) async {
    // Hide Keyboard Before Route
    DeviceService.keyboardHide();

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
      // Check Delay
      if (delay != null) {
        Future.delayed(delay, () => Get.to(this.page(), transition: this.transition, arguments: args));
      } else {
        Get.to(this.page(), transition: this.transition, arguments: args);
      }
    }
  }

  /// Pushes a Alert View Modal
  static Future<bool> alert({
    required String title,
    required String description,
    String buttonText = "Okay",
    bool closeOnResponse = true,
    bool ignoreSafeArea = false,
    bool dismissible = true,
  }) async {
    // Hide Keyboard Before Route
    DeviceService.keyboardHide();

    // Create Future Completer
    var completer = Completer<bool>();
    Get.dialog(
      BlurredBackground(
          child: AlertOverlay(
        title,
        description,
        buttonText,
        () {
          completer.complete();
          Future.delayed(300.milliseconds, () => Get.back());
        },
      )),
      transitionDuration: 0.seconds,
      barrierDismissible: dismissible,
      barrierColor: Colors.transparent,
      useSafeArea: !ignoreSafeArea,
    );
    return completer.future;
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
      // Hide Keyboard Before Route
      DeviceService.keyboardHide();

      // Init Function
      if (init != null) {
        init();
      }

      // Push Dialog
      Get.dialog(
        BlurredBackground(
            child: child,
            onTapped: () {
              Future.delayed(300.milliseconds, () => Get.back());
            }),
        barrierDismissible: dismissible,
        barrierColor: Colors.transparent,
        useSafeArea: !ignoreSafeArea,
      );
    }
  }

  /// Pushes Postioned Modal relative to Parent Key
  static Future<void> positioned(
    Widget child, {
    required GlobalKey parentKey,
    bool ignoreSafeArea = false,
    Offset? offset,
  }) async {
    // Hide Keyboard Before Route
    DeviceService.keyboardHide();

    final RxBool hasDismissed = false.obs;
    Get.dialog(
      BlurredBackground(
          onTapped: () {
            hasDismissed(true);
            Future.delayed(300.milliseconds, () => Get.back());
          },
          child: PositionedOverlay(
            parentKey: parentKey,
            hasDismissed: hasDismissed,
            child: child,
            offset: offset,
          )),
      transitionDuration: 0.seconds,
      barrierColor: Colors.transparent,
      useSafeArea: !ignoreSafeArea,
    );
  }

  /// Pushes a Question View Modal
  static Future<bool> question({
    required String title,
    required String description,
    String acceptTitle = "Yes!",
    String declineTitle = "No",
    bool closeOnResponse = true,
    bool ignoreSafeArea = false,
    bool dismissible = true,
  }) async {
    // Hide Keyboard Before Route
    DeviceService.keyboardHide();

    // Create Future Completer
    var completer = Completer<bool>();

    // Push Dialog
    Get.dialog(
      BlurredBackground(
          child: QuestionOverlay(
        title,
        description,
        (result) {
          completer.complete(result);
          Get.back();
        },
        acceptTitle,
        declineTitle,
      )),
      transitionDuration: 0.seconds,
      barrierDismissible: dismissible,
      barrierColor: Colors.transparent,
      useSafeArea: !ignoreSafeArea,
    );
    return completer.future;
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
    // Hide Keyboard Before Route
    DeviceService.keyboardHide();

    // Check if Forced Open
    if (forced) {
      closeSheet();
    }

    // Init Method
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

  /// Display snackbar on bottom of current page
  static Future<void> snack(SnackArgs args) async {
    if (isSnackClosed) {
      // Hide Keyboard Before Route
      DeviceService.keyboardHide();

      // Push Snackbar
      Get.snackbar(
        args.title!,
        args.message,
        snackStyle: SnackStyle.FLOATING,
        duration: Duration(milliseconds: args.duration),
        snackPosition: SnackPosition.BOTTOM,
        reverseAnimationCurve: Curves.elasticOut,
        backgroundColor: args.color,
        icon: args.icon,
        colorText: SonrColor.White,
      );
    }
  }

  /// Closes Current Page
  static void close() {
    Get.back(closeOverlays: true);
  }

  /// Closes Active Popup
  static void closePopup() {
    if (isPopupOpen) {
      Get.back();
    }
  }

  /// Closes Active Popup
  static void closeSheet() {
    if (isSheetOpen) {
      Get.back();
    }
  }
}
