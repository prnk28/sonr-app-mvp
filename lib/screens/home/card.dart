part of 'home.dart';

class FileCard extends StatelessWidget {
  final Metadata metadata;
  FileCard(this.metadata);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
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
  }
}
