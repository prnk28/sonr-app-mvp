part of 'home.dart';

class RequestedView extends StatelessWidget {
  final Metadata metadata;
  final Peer match;
  const RequestedView(this.metadata, this.match);
  @override
  Widget build(BuildContext context) {
    return Dialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
        child: Neumorphic(
            style: NeumorphicStyle(
                shape: NeumorphicShape.flat,
                boxShape:
                    NeumorphicBoxShape.roundRect(BorderRadius.circular(20)),
                depth: 8,
                lightSource: LightSource.topLeft,
                color: Colors.grey),
            child: Container(
                color: NeumorphicTheme.baseColor(context),
                height: MediaQuery.of(context).size.height / 3,
                width: MediaQuery.of(context).size.width / 2,
                child: Row(children: [
                  NeumorphicButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: NeumorphicStyle(
                        depth: 8,
                        shape: NeumorphicShape.concave,
                        boxShape: NeumorphicBoxShape.roundRect(
                            BorderRadius.circular(8))),
                    padding: const EdgeInsets.all(12.0),
                    child: Icon(
                      Icons.close,
                      color: _iconsColor(context),
                    ),
                  ),
                  NeumorphicButton(
                      margin: EdgeInsets.only(top: 12),
                      onPressed: () {},
                      style: NeumorphicStyle(
                          depth: 8,
                          shape: NeumorphicShape.concave,
                          boxShape: NeumorphicBoxShape.roundRect(
                              BorderRadius.circular(8))),
                      padding: const EdgeInsets.all(12.0),
                      child: Icon(
                        Icons.check,
                        color: _iconsColor(context),
                      )),
                ]) // FlatButton// Container
                )));
  }

  Color _iconsColor(BuildContext context) {
    final theme = NeumorphicTheme.of(context);
    if (theme.isUsingDark) {
      return theme.current.accentColor;
    } else {
      return null;
    }
  }

  Color _textColor(BuildContext context) {
    if (NeumorphicTheme.isUsingDark(context)) {
      return Colors.white;
    } else {
      return Colors.black;
    }
  }
}
