import 'package:flutter/material.dart';
import 'package:sonr_app/pages/home/home_controller.dart';
import 'package:sonr_app/pages/transfer/transfer.dart';
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

class NearbyListView extends GetView<HomeController> {
  NearbyListView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BoxContainer(
      width: 400,
      height: 700,
      child: Column(
        children: [
          // Label
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.only(left: 24.0, top: 8),
              child: "Nearby Devices".subheading(align: TextAlign.start, color: SonrTheme.itemColor),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 8),
            child: Obx(
              () => LobbyService.lobby.value.isEmpty ? _LocalEmptyView() : _LocalLobbyView(),
            ),
          ),
        ],
      ),
    );
  }
}

/// @ LocalLobbyView:  When Lobby is NOT Empty
class _LocalLobbyView extends GetView<HomeController> {
  @override
  Widget build(BuildContext context) {
    return
        // Scroll View
        Obx(() => Container(
            width: Get.width,
            height: 400,
            child: ListView.builder(
                itemCount: LobbyService.lobby.value.peers.length,
                itemBuilder: (context, index) {
                  return PeerListItem(peer: LobbyService.lobby.value.peerAtIndex(index), index: index);
                })));
  }
}

/// @ LobbyEmptyView: When Lobby is Empty
class _LocalEmptyView extends GetView<HomeController> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        child: [
          Image.asset(
            'assets/illustrations/EmptyLobby.png',
            height: Height.ratio(0.45),
            fit: BoxFit.fitWidth,
          ),
          Padding(padding: EdgeInsets.only(top: 8)),
          "Nobody Here..".subheading(color: Get.theme.hintColor, fontSize: 20)
        ].column(),
        padding: EdgeInsets.all(64),
      ),
    );
  }
}
