part of 'home.dart';

class ImageCard extends StatelessWidget {
  final Color color;
  final Metadata metadata;
  ImageCard(this.metadata, this.color);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () async {
          // Load Files
          context.getBloc(BlocType.Data).add(UserGetFile(meta: metadata));
        },
        child: Container(
          height: 75,
          color: color,
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
  }
}
