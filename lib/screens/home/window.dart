import 'package:sonar_app/screens/screens.dart';

part 'offered.dart';

class WindowView extends StatelessWidget {
  const WindowView();
  @override
  Widget build(BuildContext context) {
    return Dialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
        child: BlocBuilder<WebBloc, WebState>(builder: (context, state) {
          if (state is Requested) {
            return buildAuthenticationView(context, state.offer);
          }
          return Container(color: NeumorphicTheme.baseColor(context),
              height: MediaQuery.of(context).size.height / 3,
              width: MediaQuery.of(context).size.width / 2,);
        }));
  }
}
