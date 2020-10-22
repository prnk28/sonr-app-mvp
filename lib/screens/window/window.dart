import 'package:sonar_app/screens/screens.dart';

part 'auth.dart';
part 'download.dart';

class Sheet {
  static Widget showAuth(BuildContext context, Requested state) {
    return Container(
        color: NeumorphicTheme.baseColor(context),
        height: MediaQuery.of(context).size.height / 3,
        child: buildAuthenticationView(context, state));
  }

  static Widget showTransferring(BuildContext context) {
    return Container(
        color: NeumorphicTheme.baseColor(context),
        height: MediaQuery.of(context).size.height / 3,
        child: buildProgressView(context));
  }

  static Widget showComplete(BuildContext context, Completed state) {
    return Container(
        color: NeumorphicTheme.baseColor(context),
        height: MediaQuery.of(context).size.height / 3,
        child: buildCompleteView(context, state));
  }
}

// TODO: Turn into a Full Method of Extending Modal BottomSheet
class Window {
  Widget baseWindow;
  Widget view;

  Window(BuildContext screenContext) {
    // Create Box Window
    baseWindow = Neumorphic(
        style: NeumorphicStyle(
            shape: NeumorphicShape.flat,
            boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(20)),
            depth: 8,
            lightSource: LightSource.topLeft,
            color: Colors.blueGrey[50]),
        child: Container(
            color: NeumorphicTheme.baseColor(screenContext),
            height: MediaQuery.of(screenContext).size.height / 3,
            child: view));
  }

  Widget build(BuildContext context, SignalState state) {
    if (state is Requested) {
      Requested reqState = state;
      view = buildAuthenticationView(context, reqState);
    } else if (state is Transferring) {
      view = buildProgressView(context);
    } else if (state is Completed) {
      Completed compState = state;
      view = buildCompleteView(context, compState);
    }

    return baseWindow;
  }
}
