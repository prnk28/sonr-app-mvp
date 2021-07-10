import 'package:lottie/lottie.dart';
import 'package:sonr_app/style/style.dart';
import 'package:sonr_plugin/sonr_plugin.dart';

extension AnimationBorderUtils on SessionStatus {
  /// Return Corresponding LottieFile for Session Status
  LottieFile get lottieFile {
    switch (this) {
      case SessionStatus.Default:
        return LottieFile.NONE;
      case SessionStatus.Accepted:
        return LottieFile.NONE;
      case SessionStatus.Pending:
        return LottieFile.Pending;
      case SessionStatus.Invited:
        return LottieFile.Pending;
      case SessionStatus.Denied:
        return LottieFile.Decline;
      case SessionStatus.InProgress:
        return LottieFile.Sending;
      case SessionStatus.Completed:
        return LottieFile.Complete;
    }
  }

  /// Creates a widget that displays an [LottieComposition] obtained from this Files [AssetBundle].
  LottieBuilder lottie(
      {Animation<double>? controller,
      bool? animate,
      FrameRate? frameRate,
      bool? repeat,
      bool? reverse,
      LottieDelegates? delegates,
      LottieOptions? options,
      void Function(LottieComposition)? onLoaded,
      ImageProvider<Object>? Function(LottieImageAsset)? imageProviderFactory,
      Key? key,
      AssetBundle? bundle,
      Widget Function(BuildContext, Widget, LottieComposition?)? frameBuilder,
      double? width,
      double? height,
      BoxFit? fit,
      Alignment? alignment,
      String? package,
      bool? addRepaintBoundary}) {
    assert(this.lottieFile != LottieFile.NONE);
    return Lottie.asset(
      this.lottieFile.path,
      controller: controller,
      animate: animate,
      frameRate: frameRate,
      repeat: repeat,
      reverse: reverse,
      delegates: delegates,
      options: options,
      onLoaded: onLoaded,
      imageProviderFactory: imageProviderFactory,
      key: key,
      bundle: bundle,
      frameBuilder: frameBuilder,
      width: width,
      height: height,
      fit: fit,
      package: package,
      addRepaintBoundary: addRepaintBoundary,
    );
  }
}
