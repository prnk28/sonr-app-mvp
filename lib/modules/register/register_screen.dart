import 'package:sonr_app/theme/theme.dart';
import 'form_page.dart';
import 'started_page.dart';

class StartedScreen extends StatefulWidget {
  @override
  _StartedScreenState createState() => _StartedScreenState();
}

class _StartedScreenState extends State<StartedScreen> {
  final pageController = PageController();
  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      controller: pageController,
      physics: NeverScrollableScrollPhysics(),
      itemCount: 2,
      itemBuilder: (context, index) {
        if (index == 0) {
          return GetStartedPage(() {
            pageController.jumpToPage(1);
          });
        }
        return FormPage();
      },
    );
  }
}
