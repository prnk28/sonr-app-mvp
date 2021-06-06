import 'package:sonr_app/pages/detail/detail.dart';
import 'package:sonr_app/style.dart';

class ErrorView {
  static Widget display(DetailPageType type) {
    if (type == DetailPageType.ErrorConnection) {
      return ErrorConnectionView();
    } else if (type == DetailPageType.ErrorPermissions) {
      return ErrorPermissionsView();
    } else {
      return ErrorTransferView();
    }
  }
}

class ErrorConnectionView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class ErrorPermissionsView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class ErrorTransferView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
