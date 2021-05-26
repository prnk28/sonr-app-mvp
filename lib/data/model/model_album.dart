import 'package:photo_manager/photo_manager.dart';
import 'package:sonr_app/style/style.dart';

extension AssetPathEntityUtils on AssetPathEntity {
  Widget tag({required bool isSelected}) {
    return AnimatedContainer(
        decoration: isSelected ? BoxDecoration(borderRadius: BorderRadius.circular(40), color: SonrColor.Primary.withOpacity(0.9)) : BoxDecoration(),
        constraints: BoxConstraints(maxHeight: 50),
        padding: EdgeInsets.symmetric(vertical: 4, horizontal: 16),
        duration: 150.milliseconds,
        child: isSelected ? this.label().h6_White : this.label().h6_Grey);
  }

  String label() {
    if (this.isAll) {
      return "All";
    } else {
      return this.name;
    }
  }
}

extension AssetPathEntityListUtils on List<AssetPathEntity> {
  Future<AssetPathAlbum?> allAlbum() async {
    if (this.any((e) => e.isAll)) {
      var entity = this.firstWhere((e) => e.isAll);
      var index = this.indexOf(entity);
      return await AssetPathAlbum.init(index, entity);
    } else {
      return null;
    }
  }
}

class AssetPathAlbum {
  final int index;
  final AssetPathEntity entity;
  late List<AssetEntity> assets;

  bool get isAll => entity.isAll;
  bool get isNotAll => !isAll;
  int get length => assets.length;

  AssetPathAlbum(this.index, this.entity);

  static Future<AssetPathAlbum> init(int index, AssetPathEntity entity) async {
    var album = AssetPathAlbum(index, entity);
    album.assets = await entity.assetList;
    return album;
  }

  factory AssetPathAlbum.blank() {
    return AssetPathAlbum(-1, AssetPathEntity());
  }

  bool isIndex(int i) {
    return index == i;
  }

  AssetEntity entityAtIndex(int i) {
    return this.assets[i];
  }
}
