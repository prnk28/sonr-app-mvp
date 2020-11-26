import 'dart:ffi';
import 'dart:math';
import 'dart:typed_data';

import 'package:intl/intl.dart';
import 'package:sonar_app/screens/screens.dart';
import 'package:sonr_core/sonr_core.dart';

part 'image.dart';

// ********************************** //
// ** Screen Class for File Detail ** //

// TODO: Implement Detail View With FileBloc
// // ********************************** //
// class DetailScreen extends StatelessWidget {
//   DetailScreen({Key key}) : super(key: key);
//   @override
//   Widget build(BuildContext context) {
//     // Get Passed MetaData
//     final Metadata metadata = ModalRoute.of(context).settings.arguments;
//     return Scaffold(
//         // Setup App Bar
//         appBar: actionSingleAppBar(context, Icons.arrow_back, Icons.delete,
//             onLeadingPressed: () {
//           // Push Replacement
//           Navigator.pushReplacementNamed(context, "/home");
//         }, onActionPressed: () {
//           // show the dialog
//           showDialog(
//             context: context,
//             builder: (BuildContext context) {
//               return detailDeleteDialog(onCancel: () {
//                 // Close Window
//                 Navigator.pop(context);
//               }, onDelete: () {
//                 // Delete File Event
//                 context.getBloc(BlocType.Data).add(UserDeleteFile(metadata));
//               });
//             },
//           );
//         }, title: metadata.kind),
//         backgroundColor: NeumorphicTheme.baseColor(context),
//         // Setup Body
//         body: _DetailView());
//   }
// }

// class _DetailView extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MultiBlocListener(
//       listeners: [
//         BlocListener<DataBloc, DataState>(
//           // Set Listen Requirements
//           listenWhen: (previous, current) {
//             if (current is UserDeletedFileSuccess) {
//               return true;
//             }
//             return false;
//           },
//           listener: (context, state) {
//             if (state is UserDeletedFileSuccess) {
//               // Change Status
//               context.getBloc(BlocType.User).add(NodeAvailable());

//               // Push to Home
//               Navigator.pushReplacementNamed(
//                 context,
//                 "/home",
//               );
//             }
//           },
//         ),
//         getRequestListener()
//       ],
//       child: BlocBuilder<DataBloc, DataState>(
//           // Set Build Requirements
//           buildWhen: (previous, current) {
//         if (current is UserViewingFileInProgress) {
//           return true;
//         } else if (current is UserViewingFileSuccess) {
//           return true;
//         } else if (current is UserViewingFileFailure) {
//           return true;
//         }
//         return false;
//       },
//           // Build By State
//           builder: (context, state) {
//         // * User Opened File
//         if (state is UserViewingFileSuccess) {
//           return _getViewForFileType(context, state.bytes, state.metadata);
//         }
//         // ! User Couldnt open file
//         else if (state is UserViewingFileFailure) {
//           // Show Error Dialog
//           showDialog(
//             context: context,
//             builder: (BuildContext context) {
//               return detailDeleteDialog(onCancel: () {
//                 // Close Window
//                 Navigator.pop(context);
//               }, onDelete: () {
//                 // Delete File Event
//                 context
//                     .getBloc(BlocType.Data)
//                     .add(UserDeleteFile(state.metadata));

//                 // Push to Home
//                 Navigator.pushReplacementNamed(
//                   context,
//                   "/home",
//                 );
//               });
//             },
//           );
//           return Container();
//         } else {
//           return Center(child: CircularProgressIndicator());
//         }
//       }),
//     );
//   }

//   _getViewForFileType(
//       BuildContext context, Uint8List bytes, Metadata metadata) {
//     // Check Files Count
//     if (bytes != null && metadata != null) {
//       // Check file type
//       switch (metadata.kind) {
//         case "audio":
//           return Container();
//           break;
//         case "image":
//           return ImageDetailView(bytes, metadata);
//           break;
//         case "video":
//           return Container();
//           break;
//         case "text":
//           return Container();
//           break;
//         default:
//           return Container();
//           break;
//       }
//     }
//   }
// }
