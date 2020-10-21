import 'package:sonar_app/screens/screens.dart';

part 'auth.dart';
part 'download.dart';

class Window extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        color: NeumorphicTheme.baseColor(context),
        height: MediaQuery.of(context).size.height / 3,
        child: BlocBuilder<WebBloc, WebState>(
            // Set Build Requirements
            buildWhen: (prev, curr) {
          if (curr is Loading) {
            return false;
          }
          return true;
        }, builder: (context, state) {
          if (state is Requested) {
            return buildAuthenticationView(context, state);
          } else if (state is Transferring) {
            return buildProgressView(context);
          } else if (state is Completed) {}
          Navigator.pop(context);
          return Container();
        }));
  }
}
