import 'package:flutter/material.dart';
import 'package:sonr_app/pages/home/home_controller.dart';
import 'package:sonr_app/style.dart';

class AccessView extends GetView<HomeController> {
  AccessView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BoxContainer(
      width: 800,
      height: 625,
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Padding(
          padding: const EdgeInsets.only(left: 24.0, top: 8),
          child: "Quick Access".subheading(align: TextAlign.start, color: Get.theme.focusColor),
        ),
        Padding(padding: EdgeInsets.only(top: 4)),
        Center(
          child: Container(
              height: 575,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: ImageButton(
                          path: PostItemType.Media.imagePath(),
                          label: PostItemType.Media.name(),
                          imageFit: BoxFit.fitWidth,
                          imageWidth: 130,
                          onPressed: () {
                            if (PostItemType.Media.count() > 0) {
                              AppPage.Posts.to(args: PostsPageArgs.media());
                            } else {
                              AppPage.Error.to(args: ErrorPageArgs.emptyMedia());
                            }
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: ImageButton(
                          path: PostItemType.Files.imagePath(),
                          label: PostItemType.Files.name(),
                          onPressed: () {
                            if (PostItemType.Files.count() > 0) {
                              AppPage.Posts.to(args: PostsPageArgs.files());
                            } else {
                              AppPage.Error.to(args: ErrorPageArgs.emptyFiles());
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: ImageButton(
                          path: PostItemType.Contacts.imagePath(),
                          label: PostItemType.Contacts.name(),
                          onPressed: () {
                            if (PostItemType.Contacts.count() > 0) {
                              AppPage.Posts.to(args: PostsPageArgs.contacts());
                            } else {
                              AppPage.Error.to(args: ErrorPageArgs.emptyContacts());
                            }
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: ImageButton(
                          path: PostItemType.Links.imagePath(),
                          imageWidth: 90,
                          imageHeight: 90,
                          label: PostItemType.Links.name(),
                          onPressed: () {
                            if (PostItemType.Links.count() > 0) {
                              AppPage.Posts.to(args: PostsPageArgs.links());
                            } else {
                              AppPage.Error.to(args: ErrorPageArgs.emptyLinks());
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              )),
        ),
      ]),
    );
  }
}
