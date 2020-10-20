part of 'home.dart';

class RequestedView extends StatelessWidget {
  final Offer offer;
  const RequestedView(this.offer);
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DataBloc, DataState>(builder: (context, state) {
      // Queue Incoming
      // context.emitDataBlocEvent(DataEventType.QueueIncomingFile,
      //     meta: offer.metadata);

      // Create View
      return Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
          child: NeumorphicTheme(
              theme: lightTheme(),
              darkTheme: darkTheme(),
              child: Neumorphic(
                  style: NeumorphicStyle(
                      shape: NeumorphicShape.flat,
                      boxShape: NeumorphicBoxShape.roundRect(
                          BorderRadius.circular(20)),
                      depth: 8,
                      lightSource: LightSource.topLeft,
                      color: Colors.blueGrey[50]),
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
                                    context.emitWebBlocEvent(
                                        WebEventType.Authorize,
                                        match: this.offer.from,
                                        decision: false);

                                    // Pop Window
                                    Navigator.pop(context);
                                  },
                                  child: Padding(
                                      padding:
                                          EdgeInsets.only(top: 10, right: 10),
                                      child: Icon(
                                        Icons.close_rounded,
                                        size: 35,
                                        color: Colors.grey[700],
                                      )))),

                          // Build Item from Metadata and Peer
                          _buildItem(context),
                          Padding(padding: EdgeInsets.only(top: 25)),

                          // Build Auth Action
                          _buildAuthButton(context)
                        ],
                      )))));
    });
  }

  Row _buildItem(BuildContext context) {
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

  NeumorphicButton _buildAuthButton(BuildContext context) {
    return NeumorphicButton(
        onPressed: () {
          // Update WebBloc to Inform User Accepted
          context.emitWebBlocEvent(WebEventType.Authorize,
              offer: this.offer, decision: true);
        },
        style: NeumorphicStyle(
            depth: 8,
            shape: NeumorphicShape.concave,
            boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(8))),
        padding: const EdgeInsets.all(12.0),
        child:
            Text("Accept", style: smallTextStyle())); // FlatButton// Container
  }
}
