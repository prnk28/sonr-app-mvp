import 'package:intl/intl.dart';
import 'package:sonar_app/screens/screens.dart';

part 'image.dart';

// ********************************** //
// ** Screen Class for File Detail ** //
// ********************************** //
class DetailScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Get Passed MetaData
    final Metadata metadata = ModalRoute.of(context).settings.arguments;

    return Scaffold(
      // Setup App Bar
      appBar: actionSingleAppBar(context, Icons.arrow_back, Icons.delete,
          onLeadingPressed: () {
        // Push Replacement
        Navigator.pushReplacementNamed(context, "/home");
      }, onActionPressed: () {
        // show the dialog
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return detailDeleteDialog(onCancel: () {
              // Close Window
              Navigator.pop(context);
            }, onDelete: () {
              // Delete File Event
              context.getBloc(BlocType.Data).add(UserDeleteFile(metadata));
            });
          },
        );
      }, title: enumAsString(metadata.type)),
      backgroundColor: NeumorphicTheme.baseColor(context),
      // Setup Body
      body: BlocConsumer<DataBloc, DataState>(
          // Set Listen Requirements
          listenWhen: (previous, current) {
        if (current is UserDeletedFileSuccess) {
          return true;
        }
        return false;
      },
          // Listen by State
          listener: (context, state) {
        if (state is UserDeletedFileSuccess) {
          // Change Status
          context.getBloc(BlocType.User).add(NodeAvailable());

          // Push to Home
          Navigator.pushReplacementNamed(
            context,
            "/home",
          );
        }
      },
          // Set Build Requirements
          buildWhen: (previous, current) {
        if (current is UserViewingFileInProgress) {
          return true;
        } else if (current is UserViewingFileSuccess) {
          return true;
        }
        return false;
      },
          // Build By State
          builder: (context, state) {
        if (state is UserViewingFileSuccess) {
          return _getViewForFileType(context, state.bytes, state.metadata);
        } else {
          return Center(child: CircularProgressIndicator());
        }
      }),
    );
  }

  _getViewForFileType(
      BuildContext context, Uint8List bytes, Metadata metadata) {
    // Check Files Count
    if (bytes != null && metadata != null) {
      // Check file type
      switch (metadata.type) {
        case FileType.Audio:
          return Container();
          break;
        case FileType.Image:
          return ImageDetailView(bytes, metadata);
          break;
        case FileType.Video:
          return Container();
          break;
        case FileType.Word:
          return Container();
          break;
        case FileType.Unknown:
          return Container();
          break;
        default:
          return Container();
          break;
      }
    }
  }
}
