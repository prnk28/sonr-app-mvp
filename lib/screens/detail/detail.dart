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
      appBar: leadingAppBar(context, Icons.arrow_back, onPressed: () {
        // Push Replacement
        Navigator.pushReplacementNamed(context, "/home");
      }),
      backgroundColor: NeumorphicTheme.baseColor(context),

      // Setup Body
      body: BlocBuilder<DataBloc, DataState>(
          // Set Build Requirements
          buildWhen: (previous, current) {
        if (current is UserViewingFileInProgress) {
          return true;
        }
        return false;
      },
          // Build By State
          builder: (context, state) {
        if (state is UserViewingFileInProgress) {
          // Get File
          var file = state.file;
          // Check Files Count
          if (state.file != null) {
            // Log File Type
            log.i("File Type: " + file.metadata.type.toString());

            // Check file type
            switch (file.metadata.type) {
              case FileType.Audio:
                return Container();
                break;
              case FileType.Image:
                return buildImageView(file);
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
          // No Files
          else {
            return Center(child: Text("Mega Hellope: Couldnt Load File"));
          }
        }
        log.e("Incorrect State in Detail Screen");
        return Center(child: Text("Mega Hellope"));
      }),
    );
  }
}
