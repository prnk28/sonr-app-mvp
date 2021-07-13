import 'dart:ui';
import 'package:sonr_app/style/style.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../controllers/home_controller.dart';
import 'search_view.dart';

const K_LIST_HEIGHT = 225.0;

/// #### Root Grid View
class DashboardView extends GetView<HomeController> {
  DashboardView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => controller.changeView(HomeView.Dashboard),
      child: Container(
          padding: EdgeInsets.all(8),
          margin: _getMargin(context),
          child: CustomScrollView(controller: controller.scrollController, slivers: [
            SliverToBoxAdapter(child: CardSearchField()),
            SliverPadding(padding: EdgeInsets.only(top: 14)),
            Obx(() => SliverToBoxAdapter(
                child: Container(
                    height: Height.ratio(0.4) + 125,
                    child: AnimatedSlider.fade(
                      child: _buildView(controller.view.value),
                    )))),
            SliverPadding(padding: EdgeInsets.all(8)),
          ])),
    );
  }

  // # Builds Subview from Controller Status
  Widget _buildView(HomeView status) {
    if (status == HomeView.Dashboard) {
      return Container(
        height: Height.ratio(0.44),
        width: Width.full,
        key: ValueKey(HomeView.Dashboard),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          "My Stuff".section(align: TextAlign.start, color: Get.theme.focusColor),
          Padding(padding: EdgeInsets.only(top: 4)),
          Center(
            child: Container(
                height: Height.ratio(0.36),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: ComplexButton(
                            type: ComplexIcons.MediaSelect,
                            label: PostItemType.Media.name(),
                            size: 100,
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
                          child: ComplexButton(
                            size: 100,
                            type: ComplexIcons.DocumentsBox,
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
                          child: ComplexButton(
                            size: 100,
                            type: ComplexIcons.LobbyGroup,
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
                          child: ComplexButton(
                            type: ComplexIcons.Clip,
                            size: 100,
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
    } else {
      return SearchResultsView(key: ValueKey(HomeView.Search));
    }
  }

  // # Gets View Margin for Dashboard
  EdgeInsets _getMargin(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return EdgeInsets.only(left: width * 0.05, right: width * 0.05);
  }
}
