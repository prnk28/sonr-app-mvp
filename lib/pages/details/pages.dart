import 'package:sonr_app/style.dart';
import 'arguments.dart';
import 'items/post/item.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// @ QuickAccessScreen from Home
class DetailPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final DetailPageArgs args = Get.arguments;
    return SonrScaffold(
        appBar: DetailAppBar(
          onPressed: () => Get.back(closeOverlays: true),
          title: args.title,
        ),
        body: args.body());
  }
}

class ErrorPage extends StatelessWidget {
  const ErrorPage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final ErrorPageArgs args = Get.arguments;
    return SafeArea(
      top: false,
      left: false,
      right: false,
      bottom: false,
      child: Stack(
        children: [
          Container(
            width: Get.width,
            height: Get.height,
            decoration: BoxDecoration(color: args.backgroundColor),
            foregroundDecoration: BoxDecoration(image: DecorationImage(image: AssetImage(args.imagePath), fit: BoxFit.fitHeight)),
          ),
          Container(
            padding: EdgeInsets.only(bottom: 32),
            alignment: Alignment.bottomCenter,
            child: ColorButton.neutral(
              onPressed: () => AppRoute.close(),
              text: "Return Home",
              textColor: args.textColor,
            ),
          ),
        ],
      ),
    );
  }
}

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
