import 'package:sonr_app/modules/intel/intel.dart';
import 'package:sonr_app/style/style.dart';

class NearbyPeersRow extends GetView<IntelController> {
  const NearbyPeersRow({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 8),
      child: controller.obx(
        (state) {
          if (state != null) {
            if (state.needsMoreLabel) {
              final moreKey = GlobalKey();
              return Stack(
                alignment: Alignment.centerRight,
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: Row(
                      children: state.mapNearby(),
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      mainAxisSize: MainAxisSize.min,
                    ),
                  ),
                  Container(
                    key: moreKey,
                    width: 32,
                    height: 32,
                    child: "${state.additionalPeers}+".light(
                      fontSize: 18,
                      color: AppTheme.greyColor,
                    ),
                    decoration: BoxDecoration(
                      color: AppTheme.foregroundColor,
                      shape: BoxShape.circle,
                    ),
                  ),
                ],
              );
            } else {
              return Row(
                children: state.mapNearby(),
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                mainAxisSize: MainAxisSize.min,
              );
            }
          }
          return Container();
        },
        onEmpty: Container(),
        onLoading: Container(),
        onError: (_) => Container(),
      ),
    );
  }
}
