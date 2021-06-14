// import 'dart:typed_data';
// import 'package:flutter/material.dart';
// import 'package:sonr_app/style.dart';
// import 'package:sonr_plugin/sonr_plugin.dart';
// import 'decoration.dart';

// /// Returns NeumorphicCard
// class NeumorphicCard extends StatelessWidget {
//   final Widget child;
//   final EdgeInsets? margin;
//   final ThemeData themeData;
//   const NeumorphicCard({Key? key, required this.child, this.margin, required this.themeData}) : super(key: key);
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: EdgeInsets.all(8),
//       decoration: Neumorphic.floating(theme: themeData),
//       width: _getWidth(context),
//       height: _getHeight(context),
//       margin: margin ?? _getMargin(context),
//       child: child,
//     );
//   }

//   EdgeInsets _getMargin(BuildContext context) {
//     var width = MediaQuery.of(context).size.width;
//     var height = MediaQuery.of(context).size.height;
//     return EdgeInsets.only(bottom: height * 0.05, left: width * 0.05, right: width * 0.05);
//   }

//   double _getHeight(BuildContext context) {
//     return MediaQuery.of(context).size.height * 0.75;
//   }

//   double _getWidth(BuildContext context) {
//     var width = MediaQuery.of(context).size.width;
//     var factor = width * 0.15;
//     return width - factor;
//   }
// }

// /// Returns Neumorphic Card with Stacked Avatar Image from Profile
// class NeumorphicAvatarCard extends StatelessWidget {
//   final Widget child;
//   final Profile profile;
//   final EdgeInsets? margin;
//   final ThemeData themeData;
//   const NeumorphicAvatarCard({Key? key, required this.child, required this.profile, this.margin, required this.themeData}) : super(key: key);
//   @override
//   Widget build(BuildContext context) {
//     return Stack(
//       children: [
//         Padding(
//           padding: const EdgeInsets.only(top: 42.0),
//           child: Container(
//             padding: EdgeInsets.all(8),
//             decoration: Neumorphic.floating(theme: themeData),
//             width: _getWidth(context),
//             height: _getHeight(context),
//             margin: margin ?? _getMargin(context),
//             child: child,
//           ),
//         ),
//         Align(
//           alignment: Alignment.topRight,
//           child: Container(
//               margin: EdgeInsets.only(top: 16),
//               decoration: Neumorphic.floating(theme: themeData, shape: BoxShape.circle),
//               padding: EdgeInsets.all(4),
//               child: Container(
//                 width: 80,
//                 height: 80,
//                 child: profile.hasPicture()
//                     ? CircleAvatar(
//                         backgroundImage: MemoryImage(Uint8List.fromList(profile.picture)),
//                       )
//                     : SonrIcons.Avatar.greyWith(size: 80),
//               )),
//         )
//       ],
//     );
//   }

//   EdgeInsets _getMargin(BuildContext context) {
//     var width = MediaQuery.of(context).size.width;
//     var height = MediaQuery.of(context).size.height;
//     return EdgeInsets.only(bottom: height * 0.2, left: width * 0.05, right: width * 0.05);
//   }

//   double _getHeight(BuildContext context) {
//     return MediaQuery.of(context).size.height * 0.65;
//   }

//   double _getWidth(BuildContext context) {
//     var width = MediaQuery.of(context).size.width;
//     var factor = width * 0.15;
//     return width - factor;
//   }
// }
