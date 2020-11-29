part of '../home.dart';

class ImageCard extends StatelessWidget {
  final Color color;
  final Metadata metadata;
  ImageCard(this.metadata, this.color);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () async {
          // Load Files
          context.getBloc(BlocType.File).add(GetFile(metadata));
        },
        child: Container(
          height: 75,
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: MemoryImage(metadata.thumbnail), fit: BoxFit.cover)),
          child:
              // Image Info
              Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Text(metadata.name),
            Text(metadata.mime.type),
            Text("Owner: " +
                metadata.owner.firstName +
                " " +
                metadata.owner.lastName),
          ]),
        ));
  }
}
