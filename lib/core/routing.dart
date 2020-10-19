part of 'core.dart';

// ******************* //
// ** Build Routing ** //
// ******************* //
extension Routing on BuildContext {
  // ** Navigator Methods **
  goHome({bool initial: false}) {
    // Connect First
    if (initial) {
      this.emitWebBlocEvent(WebEventType.Connect);
    }

    // Push
    Navigator.pushReplacementNamed(this, "/home");
  }

  goRegister() {
    Navigator.pushReplacementNamed(this, "/register");
  }

  // Display Transfer as Modal
  pushRequested(Metadata meta, Peer match) {
    showDialog(
        barrierDismissible: false,
        context: this,
        builder: (BuildContext context) {
          return RequestedView(meta, match);
        });
  }

  // Display Transfer as Modal
  pushTransfer() {
    // Change View as Modal
    Navigator.push(
      this,
      MaterialPageRoute(
          maintainState: false,
          builder: (context) => TransferScreen(),
          fullscreenDialog: true),
    );
  }

  // ** Get Routing Information **
  Function(RouteSettings) getRouting() {
    return (settings) {
      switch (settings.name) {
        case '/home':
          // Update Status
          emitWebBlocEvent(WebEventType.Active);
          return PageTransition(
              child: HomeScreen(),
              type: PageTransitionType.fade,
              settings: settings);
          break;
        case '/register':
          return PageTransition(
              child: RegisterScreen(),
              type: PageTransitionType.rightToLeftWithFade,
              settings: settings);
          break;
        case '/transfer':
          return PageTransition(
              child: TransferScreen(),
              type: PageTransitionType.fade,
              settings: settings);
          break;
        case '/detail':
          return PageTransition(
              child: DetailScreen(),
              type: PageTransitionType.scale,
              settings: settings);
          break;
        case '/settings':
          return PageTransition(
              child: SettingsScreen(),
              type: PageTransitionType.upToDown,
              settings: settings);
          break;
      }
      return null;
    };
  }
}

// *********************** //
// ** Build BLoC System ** //
// *********************** //
MultiBlocProvider initializeBloc(Widget app) {
  // Set bloc observer to observe transitions
  Bloc.observer = SimpleBlocObserver();

  // Return Provider
  return MultiBlocProvider(
    providers: [
      // User Data Logic
      BlocProvider<UserBloc>(
        create: (context) => UserBloc(),
      ),

      // Local Data/Transfer Logic
      BlocProvider<DataBloc>(create: (context) => DataBloc()),

      // Device Sensors Logic
      BlocProvider<DeviceBloc>(
        create: (context) => DeviceBloc(
          BlocProvider.of<UserBloc>(context),
        ),
      ),

      // Networking Logic
      BlocProvider<WebBloc>(
        create: (context) => WebBloc(
            BlocProvider.of<DataBloc>(context),
            BlocProvider.of<DeviceBloc>(context),
            BlocProvider.of<UserBloc>(context)),
      ),
    ],
    child: app,
  );
}
