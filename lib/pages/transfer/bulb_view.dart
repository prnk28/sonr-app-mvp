import 'package:sonr_app/theme/theme.dart';

class BulbView extends StatelessWidget {
  final String direction;
  final String heading;
  final Gradient gradient;
  BulbView(this.direction, this.heading, this.gradient);
  @override
  Widget build(BuildContext context) {
    // Return View
    return Neumorphic(
        style: NeumorphicStyle(
          depth: -5,
          boxShape: NeumorphicBoxShape.circle(),
        ),
        margin: EdgeInsets.all(65),
        child: Neumorphic(
            style: NeumorphicStyle(
              depth: 10,
              shape: NeumorphicShape.concave,
              boxShape: NeumorphicBoxShape.circle(),
            ),
            margin: EdgeInsets.all(7.5),
            child: AnimatedContainer(
                duration: Duration(seconds: 1),
                decoration: BoxDecoration(gradient: gradient),
                child: Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.center, children: [
                  direction.gradient(gradient: FlutterGradientNames.glassWater, size: 44, key: ValueKey<String>(direction)),
                  AnimatedSlideSwitcher.slideDown(
                      child: heading.gradient(gradient: FlutterGradientNames.glassWater, size: 24, key: ValueKey<String>(heading)))
                ]))));
  }
}

class HexagonView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        children: [
          Container(
            child: Stack(
              children: [
                /// wrap:positioned of "Polygon"
                Positioned.fill(
                  child: Align(
                    alignment: Alignment.center,
                    child: Opacity(
                      opacity: 0.5,
                      child: ClipPath(
                        clipper: _HexagonClipper(),
                        child: Container(
                          width: 228,
                          height: 228,
                          decoration: BoxDecoration(
                            color: Color(
                              0xffe8f3fb,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Color(
                                  0xb9b0c3d2,
                                ),
                                offset: Offset(
                                  19,
                                  21,
                                ),
                                blurRadius: 50,
                              ),
                              BoxShadow(
                                color: Color(
                                  0x80f4f8fb,
                                ),
                                offset: Offset(
                                  -8,
                                  0,
                                ),
                                blurRadius: 8,
                              ),
                              BoxShadow(
                                color: Color(
                                  0x61f6fbff,
                                ),
                                offset: Offset(
                                  -8,
                                  -40,
                                ),
                                blurRadius: 22,
                              ),
                              BoxShadow(
                                color: Color(
                                  0x45ffffff,
                                ),
                                offset: Offset(
                                  -11,
                                  -11,
                                ),
                                blurRadius: 20,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                /// wrap:positioned of "Polygon"
                Positioned.fill(
                  child: Align(
                    alignment: Alignment.center,
                    child: Opacity(
                      opacity: 0.5,
                      child: ClipPath(
                        clipper: _HexagonClipper(),
                        child: Container(
                          width: 140,
                          height: 140,
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: Color(
                                  0x99f7925a,
                                ),
                                offset: Offset(
                                  40,
                                  2,
                                ),
                                blurRadius: 70,
                              ),
                              BoxShadow(
                                color: Color(
                                  0x99f470b1,
                                ),
                                offset: Offset(
                                  -40,
                                  2,
                                ),
                                blurRadius: 70,
                              ),
                            ],
                            gradient: LinearGradient(
                              begin: Alignment.bottomRight,
                              end: Alignment.topLeft,
                              colors: [
                                Color(
                                  0xfff7964f,
                                ),
                                Color(
                                  0xfff364ce,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                /// stack requires empty non positioned widget to work properly. refer: https://github.com/flutter/flutter/issues/49631#issuecomment-582090992
                Container(),
              ],
            ),
            width: 318,
            height: 318,
            decoration: BoxDecoration(
              color: Color(
                0xffe8f3fb,
              ),
              boxShadow: [
                BoxShadow(
                  color: Color(
                    0xb9b0c3d2,
                  ),
                  offset: Offset(
                    19,
                    21,
                  ),
                  blurRadius: 50,
                ),
                BoxShadow(
                  color: Color(
                    0x80f4f8fb,
                  ),
                  offset: Offset(
                    -8,
                    0,
                  ),
                  blurRadius: 8,
                ),
                BoxShadow(
                  color: Color(
                    0x61f6fbff,
                  ),
                  offset: Offset(
                    -8,
                    -40,
                  ),
                  blurRadius: 22,
                ),
                BoxShadow(
                  color: Color(
                    0x45ffffff,
                  ),
                  offset: Offset(
                    -11,
                    -11,
                  ),
                  blurRadius: 20,
                ),
              ],
            ),
          ),

          /// stack requires empty non positioned widget to work properly. refer: https://github.com/flutter/flutter/issues/49631#issuecomment-582090992
          Container(),
        ],
      ),
      width: MediaQuery.of(context).size.width,
    );
  }
}

class _HexagonClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, 0);
    path.lineTo(size.width, 0);
    path.lineTo(size.width, size.height * 0.8);
    path.lineTo(size.width * 0.8, size.height);
    path.lineTo(size.width * 0.2, size.height);
    path.lineTo(0, size.height * 0.8);
    path.lineTo(0, 0);

    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
