import 'package:http/http.dart';
import 'package:sonar_app/screens/screens.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    // Build View
    return Scaffold(
        backgroundColor: NeumorphicTheme.baseColor(context),
        appBar: screenAppBar("Home"),
        floatingActionButton: NeumorphicFloatingActionButton(
            child: Icon(Icons.star, size: 30),
            onPressed: () async {
              // Queue File
              context
                  .getBloc(BlocType.Data)
                  .add(PeerQueuedFile(TrafficDirection.Outgoing));

              // Push to Transfer Screen
              Navigator.pushReplacementNamed(context, "/transfer");
            }),
        body: _HomeView());
  }
}

class _HomeView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    PersistentBottomSheetController _controller;
    final _scaffoldKey = GlobalKey<ScaffoldState>(); //
    void _changeSheetState() {
      _controller.setState(() {});
    }

    _createBottomSheet() async {
      _controller =
          _scaffoldKey.currentState.showBottomSheet((context) => WindowSheet());
    }

    // Popup Callback
    onWindowTransferComplete() {
      Future.delayed(const Duration(seconds: 1), () {
        print('Transfer Was Completed, Present Popup');
      });
    }

    return MultiBlocListener(
      listeners: [
        BlocListener<UserBloc, UserState>(
          listenWhen: (previousState, state) {
            if (state is NodeRequestInitial) {
              return true;
            } else if (state is NodeTransferSuccess) {
              return true;
            }
            return false;
          },
          listener: (context, state) {
            if (state is NodeRequestInitial) {
              // Display Bottom Sheet
              showModalBottomSheet<void>(
                  context: context,
                  builder: (context) {
                    return Window.showAuth(context, state);
                  });
            } else if (state is NodeTransferSuccess) {
              // Display Bottom Sheet
              showModalBottomSheet<void>(
                  context: context,
                  builder: (context) {
                    return Window.showComplete(
                        context, state, onWindowTransferComplete);
                  });
            }
          },
        ),
        BlocListener<DataBloc, DataState>(
          listener: (context, state) {
            if (state is PeerReceiveInProgress) {
              // Display Bottom Sheet
              showModalBottomSheet<void>(
                  context: context,
                  builder: (context) {
                    return Window.showTransferring(
                      context,
                    );
                  });
            }
          },
        ),
      ],
      child: Center(child: Text("Mega Hellope")),
    );
  }
}
