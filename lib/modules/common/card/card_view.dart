import 'package:sonr_app/theme/theme.dart';

enum TransferCardViewStatus {
  Main,
  Info,
}

class TransferCardWidget extends StatelessWidget {
  final TransferCardItem item;
  final Widget view;
  final Widget infoView;
  final Widget expandedView;
  final Rx<TransferCardViewStatus> status;
  const TransferCardWidget({Key key, @required this.item, @required this.status, @required this.view, this.infoView, this.expandedView})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: 500.milliseconds,
      height: 420,
      width: Get.width - 64,
    );
  }
}
