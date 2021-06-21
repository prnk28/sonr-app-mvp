import 'package:get/get.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:sonr_app/style.dart';

class AlbumItem extends StatelessWidget {
  final bool isSelected;
  final AssetPathEntity entity;
  const AlbumItem({Key? key, required this.isSelected, required this.entity}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
        decoration: isSelected ? BoxDecoration(borderRadius: BorderRadius.circular(40), color: SonrColor.Primary.withOpacity(0.9)) : BoxDecoration(),
        constraints: BoxConstraints(maxHeight: 50),
        padding: EdgeInsets.symmetric(vertical: 4, horizontal: 16),
        duration: 150.milliseconds,
        child: _buildLabel());
  }

  Widget _buildLabel() {
    return isSelected
        ? entity.name.subheading(color: SonrColor.White, fontSize: 20)
        : entity.name.subheading(color: Get.theme.hintColor, fontSize: 20);
  }
}
