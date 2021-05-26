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
      // Tuple(SonrIcons.Audio, "Music"),
    ];

    // Build GridView
    return Container(
      padding: EdgeInsets.all(8),
      child: GridView.builder(
          itemCount: list.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 24,
            crossAxisSpacing: 24,
          ),
          itemBuilder: (context, index) {
            return _EditOptionsButton(data: list[index]);
          }),
    );
  }
}

class _EditOptionsButton extends StatelessWidget {
  final Tuple<IconData, String> data;

  const _EditOptionsButton({Key? key, required this.data}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        margin: EdgeInsets.all(12),
        decoration: Neumorphic.floating(theme: Get.theme, radius: 24),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          data.item1.whiteWith(size: 40),
          Padding(padding: EdgeInsets.only(top: 4)),
          data.item2.h6_White,
        ]),
      ),
    );
  }
}
