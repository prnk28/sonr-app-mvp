part of 'window.dart';

Widget buildAuthenticationView(BuildContext context, Offer offer) {
  return NeumorphicTheme(
      theme: lightTheme(),
      darkTheme: darkTheme(),
      child: Neumorphic(
          style: windowStyle(),
          child: Container(
              color: NeumorphicTheme.baseColor(context),
              height: MediaQuery.of(context).size.height / 3,
              width: MediaQuery.of(context).size.width / 2,
              child: Column(
                children: [
                  // Top Right Close/Cancel Button
                  Align(
                      alignment: Alignment.topRight,
                      child: GestureDetector(
                          onTap: () {
                            // Update WebBloc to Inform User Accepted
                            context.emitWebBlocEvent(WebEventType.Authorize,
                                match: offer.from, decision: false);

                            // Pop Window
                            Navigator.pop(context);
                          },
                          child: Padding(
                              padding: EdgeInsets.only(top: 10, right: 10),
                              child: Icon(
                                Icons.close_rounded,
                                size: 35,
                                color: Colors.grey[700],
                              )))),

                  // Build Item from Metadata and Peer
                  _buildItem(context, offer),
                  Padding(padding: EdgeInsets.only(top: 25)),

                  // Build Auth Action
                  _buildAuthButton(context, offer)
                ],
              ))));
}

Row _buildItem(BuildContext context, Offer offer) {
  return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
    Icon(Icons.image, size: 100),
    Column(
      children: [
        Text(offer.from.profile.firstName, style: headerTextStyle()),
        Text(offer.from.device,
            style: TextStyle(
                fontFamily: "Raleway",
                fontWeight: FontWeight.w500,
                fontSize: 22,
                color: Colors.black54))
      ],
    ),
  ]); // FlatButton// Container
}

NeumorphicButton _buildAuthButton(BuildContext context, Offer offer) {
  return NeumorphicButton(
      onPressed: () {
        // Update WebBloc to Inform User Accepted
        context.emitWebBlocEvent(WebEventType.Authorize,
            offer: offer, decision: true);
      },
      style: NeumorphicStyle(
          depth: 8,
          shape: NeumorphicShape.concave,
          boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(8))),
      padding: const EdgeInsets.all(12.0),
      child: Text("Accept", style: smallTextStyle())); // FlatButton// Container
}
