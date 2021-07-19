import 'package:sonr_app/style/style.dart';

class RemoteView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SonrScaffold(
      appBar: DetailAppBar(
        onPressed: () => Get.back(),
        title: "Remote Invite",
        isClose: true,
      ),
      body: Column(
        children: <Widget>[
          
        ],
      ),
    );
  }
}
