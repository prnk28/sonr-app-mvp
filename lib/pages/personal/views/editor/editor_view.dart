import 'package:get/get.dart';
import '../../controllers/editor_controller.dart';
import 'package:sonr_app/style.dart';
import 'general/fields.dart';
import 'package:sonr_app/pages/personal/controllers/personal_controller.dart';

class EditorView extends GetView<EditorController> {
  @override
  Widget build(BuildContext context) {
    return Obx(() => SonrScaffold(
        appBar: DetailAppBar(
          onPressed: controller.handleLeading,
          title: controller.title.value,
          isClose: true,
        ),
        body: _buildView(controller.status.value)));
  }

  // @ Build Page View by Navigation Item
  Widget _buildView(EditorFieldStatus status) {
    // Edit Name
    if (status == EditorFieldStatus.FieldName) {
      return EditNameView(key: ValueKey<EditorFieldStatus>(EditorFieldStatus.FieldName));
    }
    // Edit Phone
    else if (status == EditorFieldStatus.FieldPhone) {
      return EditPhoneView(key: ValueKey<EditorFieldStatus>(EditorFieldStatus.FieldPhone));
    }
    // Default View
    else {
      return GeneralEditorView();
    }
  }
}
