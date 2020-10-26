import 'package:sonar_app/screens/screens.dart';
import 'package:floating_action_bubble/floating_action_bubble.dart';

part 'card.dart';
part 'floater.dart';
part 'grid.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key key}) : super(key: key);
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  // Floating Button Animations
  Animation<double> _animation;
  AnimationController _animationController;

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 260),
    );

    final curvedAnimation =
        CurvedAnimation(curve: Curves.easeInOut, parent: _animationController);
    _animation = Tween<double>(begin: 0, end: 1).animate(curvedAnimation);

    super.initState();
  }

  @override
  dispose() {
    _animationController.dispose(); // you need this
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Build View
    return Scaffold(
        backgroundColor: NeumorphicTheme.baseColor(context),
        appBar: screenAppBar("Home"),
        floatingActionButton:
            FloaterButton(_animation, _animationController, (button) {
          // File Option
          if (button == "File") {
            // Push to Transfer Screen
            Navigator.pushReplacementNamed(context, "/transfer");
          }
          // Contact Option
          else {
            log.w("Contact not implemented yet");
          }
        }),
        body: _HomeView());
  }
}

class _HomeView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
            } else if (state is UserViewingFileInProgress) {
              // Push to Detail Screen
              Navigator.pushReplacementNamed(context, "/detail");
            }
          },
        ),
      ],
      child: BlocBuilder<DataBloc, DataState>(builder: (context, state) {
        // User Files View
        if (state is UserLoadedFilesSuccess) {
          return FileGrid(state.files);
        }
        // No Files View
        else if (state is UserLoadedFilesFailure) {
          return Center(child: Text("No User Files"));
        }
        // Arbitrary View
        else {
          return Center(child: Text("Mega Hellope"));
        }
      }),
    );
  }
}
