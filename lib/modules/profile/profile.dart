import 'package:sonr_app/theme/theme.dart';
import 'edit_dialog.dart';

export 'create_tile.dart';
export 'edit_dialog.dart';
export 'profile_controller.dart';
export 'profile_header.dart';
export 'profile_view.dart';
export 'social_view.dart';
export 'tile_item.dart';

// ^ Edit Sheet View for Profile ^ //
enum EditType { ColorCombo, NameField }

extension EditTypeUtils on EditType {
  Widget get view {
    switch (this) {
      case EditType.ColorCombo:
        return EditColorsView();
        break;
      case EditType.NameField:
        return EditNameView();
        break;
      default:
        return Container();
        break;
    }
  }
}
