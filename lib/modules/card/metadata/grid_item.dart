import 'package:sonr_app/data/data.dart';
import 'package:sonr_app/data/database/cards_db.dart';
import 'package:sonr_app/service/user/cards.dart';
import 'package:sonr_app/theme/theme.dart';

import 'views.dart';

class MetaGridItemView extends StatelessWidget {
  final TransferCardItem item;
  const MetaGridItemView(this.item, {Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ObxValue<RxBool>(
        (isFlipped) => Container(
              width: 160,
              height: 160,
              clipBehavior: Clip.antiAlias,
              decoration: Neumorph.floating(),
              padding: EdgeInsets.all(4),
              child: Stack(children: [
                // Content
                Container(
                  child: GestureDetector(
                    child: AnimatedSlideSwitcher.fade(
                      child: isFlipped.value
                          ? _MediaGridItemDetailsView(
                              key: ValueKey<bool>(true),
                              isFlipped: isFlipped,
                              item: item,
                            )
                          : _MediaGridItemMainView(
                              key: ValueKey<bool>(false),
                              isFlipped: isFlipped,
                              item: item,
                            ),
                    ),
                  ),
                ),
              ]),
            ),
        false.obs);
  }
}

// ^ Main Media Grid Item View ^ //
class _MediaGridItemMainView extends StatelessWidget {
  final TransferCardItem item;
  final RxBool isFlipped;
  const _MediaGridItemMainView({Key key, this.item, this.isFlipped}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MetaBox(
        metadata: item.metadata,
        child: Stack(children: [
          // Align Platform
          Align(
              alignment: Alignment.topRight,
              child: GestureDetector(
                onTap: () {
                  isFlipped(true);
                  isFlipped.refresh();
                },
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: SonrIcons.Unknown.gradient(gradient: SonrGradient.Secondary, size: 32),
                ),
              )),
        ]));
  }
}

// ^ Details Media Grid Item View ^ //
class _MediaGridItemDetailsView extends StatelessWidget {
  final TransferCardItem item;
  final RxBool isFlipped;
  const _MediaGridItemDetailsView({Key key, this.item, this.isFlipped}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Stack(alignment: Alignment.topCenter, children: [
      // Align Back Button
      Align(
        alignment: Alignment.topLeft,
        child: GestureDetector(
            onTap: () {
              isFlipped(false);
              isFlipped.refresh();
            },
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: SonrIcons.Backward.gradient(gradient: SonrGradient.Secondary, size: 32),
            )),
      ),

      // Device Information
      Padding(
        padding: const EdgeInsets.only(left: 8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Mime Icon
            item.metadata.mime.type.gradient(size: 96),

            item.metadata.sizeString.p_Grey,

            // Basic Info
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 4),
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(40), color: SonrColor.AccentNavy.withOpacity(0.75)),
                child: SizedBox(height: 30, child: item.dateText),
              ),
            )
          ],
        ),
      ),
    ]));
  }
}
