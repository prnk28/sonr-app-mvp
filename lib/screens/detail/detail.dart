import 'package:intl/intl.dart';
import 'package:sonar_app/screens/screens.dart';

part 'image.dart';

// ********************************** //
// ** Screen Class for File Detail ** //
// ********************************** //
class DetailScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Setup App Bar
      appBar: actionSingleAppBar(
        context,
        Icons.arrow_back,
        Icons.delete,
        onLeadingPressed: () {
          // Push Replacement
          Navigator.pushReplacementNamed(context, "/home");
        },
        onActionPressed: () {
          // show the dialog
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return detailDeleteDialog(
                  onCancel: () {
                    // Close Window
                    Navigator.pop(context);
                  },
                  onDelete: () {});
            },
          );
        },
      ),
      backgroundColor: NeumorphicTheme.baseColor(context),
      // Setup Body
      body: BlocBuilder<DataBloc, DataState>(
          // Set Build Requirements
          buildWhen: (previous, current) {
        if (current is UserViewingFileInProgress) {
          return true;
        } else if (current is UserLoadedFilesSuccess) {
          return true;
        }
        return false;
      },
          // Build By State
          builder: (context, state) {
        if (state is UserViewingFileSuccess) {
          // Get Data
          Uint8List bytes = state.bytes;
          Metadata metadata = state.metadata;

          // Check Files Count
          if (bytes != null && metadata != null) {
            // Check file type
            switch (metadata.type) {
              case FileType.Audio:
                return Container();
                break;
              case FileType.Image:
                return buildImageView(bytes, metadata);
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
        } else if (state is UserViewingFileInProgress) {
          return Center(child: CircularProgressIndicator());
        }
        log.e("Incorrect State in Detail Screen");
        return Center(child: Text("Mega Hellope"));
      }),
    );
  }
}
