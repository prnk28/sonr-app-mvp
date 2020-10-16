part of 'core.dart';

Function(RouteSettings) getRouting(BuildContext context) {
  return (settings) {
    switch (settings.name) {
      case '/home':
        // Update Status
        BlocProvider.of<WebBloc>(context)
            .add(Update(UpdateType.STATUS, newStatus: PeerStatus.Active));

        // Initialize
        BlocProvider.of<WebBloc>(context).add(Connect());
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
        // Update Status
        BlocProvider.of<WebBloc>(context)
            .add(Update(UpdateType.STATUS, newStatus: PeerStatus.Searching));
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

MultiBlocProvider initializeBloc(Widget appWidget) {
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
    child: appWidget,
  );
}
