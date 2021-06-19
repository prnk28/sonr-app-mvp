import 'package:sonr_app/style.dart';

import '../details.dart';

class PostsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final PostsPageArgs args = Get.arguments;
    return Obx(() => ListView.builder(
          controller: args.scrollController,
          itemCount: args.type.itemCount,
          itemBuilder: (BuildContext context, int index) => PostItem(
            args.type.transferItemAtIndex(index),
            type: PostDisplayType.ListItem,
          ),
        ));
  }
}
