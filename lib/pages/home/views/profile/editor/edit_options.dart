import 'package:sonr_app/style/style.dart';

class EditOptionsView extends StatelessWidget {
  EditOptionsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Build Data
    final List<Tuple<IconData, String>> list = [
      Tuple(SonrIcons.ATSign, "Names"),
      Tuple(SonrIcons.Location, "Addresses"),
      Tuple(SonrIcons.User, "Gender"),
      Tuple(SonrIcons.Audio, "Music"),
    ];

    // Build GridView
    return GridView.builder(
        itemCount: list.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
        itemBuilder: (context, index) {
          return _EditOptionsButton(data: list[index]);
        });
  }
}

class _EditOptionsButton extends StatelessWidget {
  final Tuple<IconData, String> data;

  const _EditOptionsButton({Key? key, required this.data}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        decoration: Neumorphic.floating(theme: Get.theme, radius: 24),
        child: Column(children: [data.item1.whiteWith(size: 32), data.item2.h6_White]),
      ),
    );
  }
}
