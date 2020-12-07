import 'package:rive/rive.dart';

enum PeerState {
  Idle,
  Pending,
  Accepted,
  Denied,
  Done,
}

class PeerController extends RiveAnimationController<RuntimeArtboard> {
  RuntimeArtboard _artboard;

  /// Our four different animations
  LinearAnimationInstance _idle;
  LinearAnimationInstance _android;
  LinearAnimationInstance _iphone;
  LinearAnimationInstance _pending;
  LinearAnimationInstance _start;
  LinearAnimationInstance _loading;

  PeerState peerState;
  String device = "";
  double progress;

  @override
  bool init(RuntimeArtboard artboard) {
    _artboard = artboard;
    _idle = artboard.animationByName('Idle');
    _android = artboard.animationByName('Android');
    _iphone = artboard.animationByName('iPhone');
    _pending = artboard.animationByName('Pending');
    _start = artboard.animationByName('StartSend');
    _loading = artboard.animationByName('DuringSend');

    _loading.time = _loading.animation.enableWorkArea
        ? _loading.animation.workEnd / _loading.animation.fps
        : _loading.animation.duration / _loading.animation.fps;

    isActive = true;
    return _idle != null;
  }

  LinearAnimationInstance getInstance(RuntimeArtboard artboard,
      {String animationName}) {
    var animation = artboard.animations.firstWhere(
      (animation) =>
          animation is LinearAnimation && animation.name == animationName,
      orElse: () => null,
    );
    if (animation != null) {
      return LinearAnimationInstance(animation as LinearAnimation);
    }
    return null;
  }

  @override
  void apply(RuntimeArtboard artboard, double elapsedSeconds) {
    // @ Check Device - iOS
    if (device == "iOS") {
      // iPhone Animation
      _iphone.animation.apply(_idle.time, coreContext: artboard);
      _iphone.advance(_iphone.time);
      peerState = PeerState.Idle;
    }
    // @ Check Device - Android
    else if (device == "Android") {
      // Iphone Animation
      _android.animation.apply(_idle.time, coreContext: artboard);
      _android.advance(_android.time);
      peerState = PeerState.Idle;
    }

    // @ Check PeerStatus
    switch (peerState) {
      case PeerState.Idle:
        // Start Idle State
        _idle.animation.apply(_idle.time, coreContext: artboard);
        _idle.advance(elapsedSeconds);
        break;
      case PeerState.Pending:
        // Start Pending State
        _pending.animation.apply(_idle.time, coreContext: artboard);
        _pending.advance(elapsedSeconds);
        break;
      case PeerState.Accepted:
        // Start Send Animation
        _start.animation.apply(_idle.time, coreContext: artboard);
        _start.advance(_start.time);

        // Start Progress Animation
        _loading.animation.apply(_idle.time, coreContext: artboard);
        _loading.advance(progress);
        break;
      case PeerState.Denied:
        //TODO: Add Denied Animation
        // // Start Send Animation
        // _start.animation.apply(_idle.time, coreContext: artboard);
        // _start.advance(_start.time);

        // // Start Progress Animation
        // _loading.animation.apply(_idle.time, coreContext: artboard);
        // _loading.advance(progress);
        break;
      default:
        break;
    }
  }

  void reset() {
    // Reset Loading
    _loading.animation.apply(_loading.time, coreContext: _artboard);

    // Reset One Shot Animations
    _android.animation.apply(_start.time, coreContext: _artboard);
    _iphone.animation.apply(_start.time, coreContext: _artboard);
    _start.animation.apply(_start.time, coreContext: _artboard);

    // Reset Loop Animations
    _idle.animation.apply(0, coreContext: _artboard);
    _pending.animation.apply(0, coreContext: _artboard);
  }

  @override
  void dispose() {}

  @override
  void onActivate() {}

  @override
  void onDeactivate() {}
}
