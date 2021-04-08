import 'package:sonr_app/theme/theme.dart';

class GetStartedPage extends StatelessWidget {
  final Function onPressed;

  const GetStartedPage(this.onPressed, {Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Image.asset('assets/illustrations/getting-started.png'),
        Align(
            alignment: Alignment.bottomCenter,
            child: Container(
                padding: EdgeWith.bottom(24),
                child: ColorButton.primary(
                  onPressed: () => onPressed,
                  text: "Get Started",
                  icon: SonrIcon.sonr,
                )))
      ],
    );
  }
}
