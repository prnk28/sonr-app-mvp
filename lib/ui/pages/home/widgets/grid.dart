part of '../home.dart';

class ImageGrid extends StatelessWidget {
  final double itemHeight = (Get.height - kToolbarHeight - 24) / 4;
  final double itemWidth = Get.width / 4;

  // Build Widget
  @override
  Widget build(BuildContext context) {
    FileService files = Get.find();
    // Load Files
    return ListView.builder(
      itemCount: files.allFiles.length,
      itemBuilder: (context, current) {
        // Get Current Metadata
        Metadata metadata = files.allFiles[current];

        // Generate Cell
        return GestureDetector(
            onTap: () async {
              // Process data.
              files.getFile(metadata);
            },
            child: Container(
              height: 75,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: FileImage(File(metadata.path)),
                      fit: BoxFit.cover)),
              child:
                  // Image Info
                  Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                    Text(metadata.name),
                    Text(metadata.mime.type.toString()),
                    Text("Owner: " + metadata.owner.firstName),
                  ]),
            ));
      },
    );
  }
}
