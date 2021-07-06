import 'package:sonr_app/style/style.dart';

class PostsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final PostsPageArgs args = Get.arguments;
    return Obx(() => SonrScaffold(
          appBar: DetailAppBar(
            onPressed: () => Get.back(closeOverlays: true),
            title: args.type.name(),
            isClose: true,
          ),
          body: ListView.builder(
            controller: args.scrollController,
            itemCount: args.type.itemCount,
            itemBuilder: (BuildContext context, int index) => PostItem(
              args.type.transferItemAtIndex(index),
            ),
          ),
        ));
  }
}
