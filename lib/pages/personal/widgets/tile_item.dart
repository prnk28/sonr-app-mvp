import 'package:sonr_app/style/style.dart';
import 'social_view.dart';
import 'package:sonr_app/pages/personal/personal.dart';

/// ** Builds Social Tile ** //
class SocialTileItem extends GetWidget<TileController> {
  final Contact_Social item;
  final int index;
  SocialTileItem(this.item, this.index);
  @override
  Widget build(BuildContext context) {
    // Build View
    controller.initialize(item, index);

    // Build View Controller
    return Stack(children: [
      // Draggable Aspect
      LongPressDraggable(
          feedback: _buildView(controller.isEditing.value, isDragging: true),
          child: _buildView(controller.isEditing.value),
          data: item,
          childWhenDragging: Container(),
          onDragStarted: () {
            HapticFeedback.heavyImpact();
            controller.isDragging(true);
          }),

      DragTarget<Contact_Social>(
        builder: (context, candidateData, rejectedData) {
          return Container();
        },
        // Only accept same tiles
        onWillAccept: (data) {
          return true;
        },
        // Switch Index Positions with animation
        onAccept: (data) {
          // TODO: UserService.swapSocials(item, data);
        },
      ),
    ]);
  }

  /// #### Builds Neumorohic Item
  Widget _buildView(bool isEditing, {bool isDragging = false}) {
    // Theming View with Drag
    return GestureDetector(
      onTap: () {
        controller.toggleExpand(index);
        HapticFeedback.lightImpact();
      },
      onDoubleTap: () {
        controller.launchURL(item.post.link.url);
        HapticFeedback.mediumImpact();
      },
      child: BoxContainer(
        child: Container(
          width: isDragging ? 125 : Get.width,
          height: isDragging ? 125 : Get.height,
          child: isDragging ? Icon(Icons.drag_indicator) : SocialView(controller, item, index),
        ),
      ),
    );
  }
}
