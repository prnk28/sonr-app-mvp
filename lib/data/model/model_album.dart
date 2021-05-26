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
  AssetPathAlbum? allAlbum() {
    if (this.any((e) => e.isAll)) {
      var entity = this.firstWhere((e) => e.isAll);
      var index = this.indexOf(entity);
      return AssetPathAlbum(index, entity);
    } else {
      return null;
    }
  }

  AssetPathAlbum getAlbum(AssetPathEntity entity) {
    var index = this.indexOf(entity);
    return AssetPathAlbum(index, entity);
  }
}

class AssetPathAlbum {
  final int index;
  final AssetPathEntity entity;
  late List<AssetEntity> assets;
  bool hasLoaded = false;

  bool get isAll => entity.isAll;
  bool get isNotAll => !isAll;
  int get length => hasLoaded ? assets.length : 0;

  AssetPathAlbum(this.index, this.entity) {
    _initItems();
  }

  factory AssetPathAlbum.blank() {
    return AssetPathAlbum(-1, AssetPathEntity());
  }

  Future<void> _initItems() async {
    this.assets = await this.entity.assetList;
    if (isNotAll) {
      await PhotoCachingManager().requestCacheAssets(
        assets: this.assets,
        option: ThumbOption(width: 320, height: 320),
      );
    }
    hasLoaded = true;
  }

  bool isIndex(int i) {
    return index == i;
  }

  AssetEntity entityAtIndex(int i) {
    return this.assets[i];
  }
}
