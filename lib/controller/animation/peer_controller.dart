import 'package:rive/rive.dart';

enum PeerState {
  Initial,
  Idle,
  Pending,
  Accepted,
  Denied,
  Done,
}

class PeerController extends RiveAnimationController<RuntimeArtboard> {
  RuntimeArtboard _artboard;

  PeerController(this.device);

  /// Our four different animations
  LinearAnimationInstance _idle;
  LinearAnimationInstance _android;
  LinearAnimationInstance _iphone;
  LinearAnimationInstance _pending;
  LinearAnimationInstance _denied;
  LinearAnimationInstance _start;
  LinearAnimationInstance _loading;

  PeerState _peerState = PeerState.Initial;
  String device = "";
  double progress;
  bool _finishedInitialSendAnimation = false;

  update(PeerState state) {
    _peerState = state;
  }

  @override
  bool init(RuntimeArtboard artboard) {
    _artboard = artboard;
    _android = getInstance(artboard, animationName: 'Android');
    _iphone = getInstance(artboard, animationName: 'iPhone');
    _idle = getInstance(artboard, animationName: 'Idle');
    _pending = getInstance(artboard, animationName: 'Pending');
    _denied = getInstance(artboard, animationName: 'Denied');
    _start = getInstance(artboard, animationName: 'StartSend');
    _loading = getInstance(artboard, animationName: 'DuringSend');

    // Find Animation time
    _iphone.time = _iphone.animation.enableWorkArea
        ? _iphone.animation.workEnd / _iphone.animation.fps
        : _iphone.animation.duration / _iphone.animation.fps;

    // Find Animation time
    _android.time = _android.animation.enableWorkArea
        ? _android.animation.workEnd / _android.animation.fps
        : _android.animation.duration / _android.animation.fps;

    // Find Animation time
    _start.time = _start.animation.enableWorkArea
        ? _start.animation.workEnd / _start.animation.fps
        : _start.animation.duration / _start.animation.fps;

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
    switch (_peerState) {
      case PeerState.Initial:
        // @ Check Device - iOS
        if (device == "iOS") {
          // iPhone Animation
          _iphone.animation.apply(_iphone.time, coreContext: artboard);
          _iphone.advance(elapsedSeconds);
          _peerState = PeerState.Idle;
        }
        // @ Check Device - Android
        else if (device == "Android") {
          // Android Animation
          _android.animation.apply(_android.time, coreContext: artboard);
          _android.advance(elapsedSeconds);
          _peerState = PeerState.Idle;
        }
        break;
      case PeerState.Idle:
        _idle.animation.apply(_idle.time, coreContext: artboard);
        _idle.advance(elapsedSeconds);
        break;
      case PeerState.Pending:
        // Start Pending State
        _pending.animation.apply(_pending.time, coreContext: artboard);
        _pending.advance(elapsedSeconds);
        break;
      case PeerState.Accepted:
        if (!_finishedInitialSendAnimation) {
          // Start Send Animation
          _start.animation.apply(_start.time, coreContext: artboard);
          if (!_start.advance(elapsedSeconds)) {
            _finishedInitialSendAnimation = true;
          }
        } else {
          // Start Progress Animation
          _loading.animation.apply(_loading.time, coreContext: artboard);
          _loading.advance(progress);
        }
        break;
      case PeerState.Denied:
        // Start Send Animation
        _denied.animation.apply(_denied.time, coreContext: artboard);
        if (!_denied.advance(elapsedSeconds)) {
          isActive = false;
        }
        break;
      case PeerState.Done:
        // TODO: Handle this case.
        print("Not implemented yet");
        break;
    }
  }

  @override
  void dispose() {}

  @override
  void onActivate() {}

  @override
  void onDeactivate() {}
}

class PeerAnimation extends SimpleAnimation {
  PeerAnimation(String animationName) : super(animationName);

  start() {
    instance.animation.loop = Loop.loop;
    isActive = true;
  }

  stop() => instance.animation.loop = Loop.oneShot;
}
