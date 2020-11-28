part of 'window.dart';

Widget buildProgressView(NodeReceiveInProgress state) {
  return Center(
      child:
          IconLiquidFill(iconData: iconDataFromKind(state.metadata.mime.type)));
}

class IconLiquidFill extends StatefulWidget {
  // Icon to Fill Up
  final IconData iconData;

  // By default it is set to 2 seconds.
  final Duration waveDuration;

  /// Set to screen Size
  final double boxHeight = screenSize.height / 3;

  /// By default it is set to 400
  final double boxWidth;

  /// By default it is set to blueAccent color
  final Color waveColor;

  IconLiquidFill({
    Key key,
    @required this.iconData,
    this.waveDuration = const Duration(seconds: 2),
    this.boxWidth = 225,
    this.waveColor = Colors.blueAccent,
  })  : assert(null != iconData),
        assert(null != waveDuration),
        assert(null != boxWidth),
        assert(null != waveColor),
        super(key: key);

  @override
  _IconLiquidFillState createState() => _IconLiquidFillState();
}

class _IconLiquidFillState extends State<IconLiquidFill>
    with TickerProviderStateMixin {
  final _iconKey = GlobalKey();

  AnimationController _waveController;
  double currentProgress;

  @override
  void initState() {
    super.initState();

    _waveController = AnimationController(
      vsync: this,
      duration: widget.waveDuration,
    );

    if (currentProgress == 1) {
      // Stop the repeating wave when the load has completed
      _waveController.stop();
    }

    _waveController.repeat();
  }

  @override
  void dispose() {
    _waveController?.stop();
    _waveController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProgressCubit, double>(
        cubit: context.getCubit(CubitType.Progress),
        builder: (context, state) {
          currentProgress = state;
          if (currentProgress < 1) {
            return Stack(
              children: <Widget>[
                SizedBox(
                  height: widget.boxHeight,
                  width: widget.boxWidth,
                  child: AnimatedBuilder(
                    animation: _waveController,
                    builder: (BuildContext context, Widget child) {
                      return CustomPaint(
                        painter: WavePainter(
                          iconKey: _iconKey,
                          waveAnimation: _waveController,
                          percent: currentProgress,
                          boxHeight: widget.boxHeight,
                          waveColor: widget.waveColor,
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(
                  height: widget.boxHeight,
                  width: widget.boxWidth,
                  child: ShaderMask(
                    blendMode: BlendMode.srcOut,
                    shaderCallback: (bounds) => LinearGradient(
                      colors: [NeumorphicTheme.baseColor(context)],
                      stops: [0.0],
                    ).createShader(bounds),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                      ),
                      child: Center(
                        child: Icon(widget.iconData, key: _iconKey, size: 225),
                      ),
                    ),
                  ),
                )
              ],
            );
          }
          return Container();
        });
  }
}
