import 'package:sonr_app/pages/detail/detail.dart';
import 'package:sonr_app/style.dart';

class DetailView {
  static Widget display(DetailPageType type) {
    if (type == DetailPageType.DetailContact) {
      return DetailContactView();
    } else if (type == DetailPageType.DetailFile) {
      return DetailFileView();
    } else if (type == DetailPageType.DetailMedia) {
      return DetailMediaView();
    } else {
      return DetailUrlView();
    }
  }
}

class DetailContactView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class DetailFileView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class DetailMediaView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class DetailUrlView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
