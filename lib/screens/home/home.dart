import 'package:http/http.dart';
import 'package:sonar_app/screens/screens.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    // Load Files
    context.getBloc(BlocType.Data).add(UserGetAllFiles());

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
            } else if (state is UserViewingFile) {
              // Push to Detail Screen
              Navigator.pushReplacementNamed(context, "/detail");
            }
          },
        ),
      ],
      child: BlocBuilder<DataBloc, DataState>(builder: (context, state) {
        if (state is UserLoadedFiles) {
          // Check Files Count
          if (state.files != null) {
            return ListView(
                padding: const EdgeInsets.all(8),
                children: _buildMetadataListCells(context, state.files));
          }
          // No Files
          else {
            return Center(child: Text("Mega Hellope: No User Files"));
          }
        } else {
          return Center(child: Text("Mega Hellope"));
        }
      }),
    );
  }

  _buildMetadataListCells(BuildContext context, List<Metadata> allFiles) {
    // Initialize
    List<Widget> cells = new List<Widget>();

    // Iterate Through Files
    allFiles.forEach((metadata) {
      // Generate Cell
      var cell = GestureDetector(
          onTap: () async {
            // Load Files
            context.getBloc(BlocType.Data).add(UserGetFile(meta: metadata));
          },
          child: Container(
            height: 75,
            color: Colors.amber[100],
            child: Center(
                child: Column(children: [
              Text(metadata.name),
              Text(enumAsString(metadata.type)),
              Text("Owner: " +
                  metadata.owner.firstName +
                  " " +
                  metadata.owner.lastName),
            ])),
          ));

      // Add Cell to List
      cells.add(cell);
    });

    // Return Cells
    return cells;
  }
}
