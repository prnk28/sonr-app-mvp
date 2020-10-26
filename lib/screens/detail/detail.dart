import 'package:sonar_app/screens/screens.dart';

part 'image.dart';

class DetailScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Setup App Bar
      appBar: leadingAppBar(context, Icons.arrow_back, onPressed: () {
        // Update Node
        context.getBloc(BlocType.User).add(NodeAvailable());

        // Pop Navigation
        Navigator.pop(context);
      }),
      backgroundColor: NeumorphicTheme.baseColor(context),

      // Setup Body
      body: BlocBuilder<DataBloc, DataState>(builder: (context, state) {
        if (state is UserViewingFile) {
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
        } else {
          log.e("Incorrect State in Detail Screen");
          return Center(child: Text("Mega Hellope"));
        }
      }),
    );
  }
}
