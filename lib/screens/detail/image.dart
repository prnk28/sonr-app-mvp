part of 'detail.dart';

Widget buildImageView(SonrFile file) {
  return Column(
    children: [Image.file(file.raw), Text(file.metadata.name)],
  );
}
