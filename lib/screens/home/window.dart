import 'package:sonar_app/screens/screens.dart';

part 'offered.dart';

class WindowView extends StatelessWidget {
  final dynamic offer;
  final Peer from;
  const WindowView(this.offer, this.from);
  @override
  Widget build(BuildContext context) {
    return Dialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
        child: buildAuthenticationView(context, this.offer, this.from));
  }
}
