import 'package:sonr_app/style.dart';

class DeviceItemView extends StatelessWidget {
  final Device device;
  const DeviceItemView({Key? key, required this.device}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150,
      height: 150,
      child: Column(
        children: [
          CircleContainer(
            child: device.platform.icon(size: 64),
          ),
          Padding(padding: EdgeInsets.only(top: 4)),
          UserService.isDarkMode ? device.name.paragraph(color: SonrColor.White) : device.name.paragraph()
        ],
      ),
    );
  }
}
