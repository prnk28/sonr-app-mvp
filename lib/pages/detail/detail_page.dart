import 'dart:io';

import 'package:sonr_app/style.dart';
import 'detail.dart';
import 'views/views.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
export 'detail.dart';

class Details {
  /// Shifts to Details PostList Page
  static void toPostsList(TransferItemsType itemsType) {
    _present(PostsListView(type: itemsType), DetailPageType.PostsList);
  }

  /// Shifts to Details for Contact Item Page
  static void toDetailContactItem(Contact item) {
    _present(DetailView.contact(), DetailPageType.DetailContact);
  }

  /// Shifts to Details for File Item Page
  static void toDetailFileItem(SonrFile_Item item) {
    _present(DetailView.file(), DetailPageType.DetailFile);
  }

  /// Shifts to Details for Media Item Page
  static void toDetailMediaItem(SonrFile_Item item, File? file) {
    _present(DetailView.media(item), DetailPageType.DetailMedia);
  }

  /// Shifts to Details for Contact Item Page
  static void toDetailUrlItem(URLLink item) {
    _present(DetailView.url(), DetailPageType.DetailUrl);
  }

  /// Shifts to Details Error Page
  static void toError(DetailPageType type) {
    _present(ErrorView(type: type), type);
  }

  // @ Helper: To Shift Page
  static void _present(Widget body, DetailPageType type, [String title = ""]) {
    Get.to(DetailsScreen(body: body, type: type, title: title));
  }
}

/// @ QuickAccessScreen from Home
class DetailsScreen extends StatelessWidget {
  final Widget body;
  final DetailPageType type;
  final String? title;
  const DetailsScreen({Key? key, required this.type, required this.body, this.title}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    if (type.hasAppBar) {
      return SonrScaffold(
          appBar: DetailAppBar(
            onPressed: () => Get.back(closeOverlays: true),
            title: title ?? "Detail",
          ),
          body: body);
    } else {
      return body;
    }
  }
}
