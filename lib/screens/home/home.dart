import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logger/logger.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sonar_app/modals/modals.dart';
import 'package:sonar_app/screens/screens.dart';
import 'package:floating_action_bubble/floating_action_bubble.dart';
import 'package:sonr_core/sonr_core.dart';

part 'view/card.dart';
part 'elements/floater.dart';
part 'view/grid.dart';

Logger log = Logger();

class HomeScreen extends StatefulWidget {
  HomeScreen({Key key}) : super(key: key);
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  // Floating Button Animations
  Animation<double> _animation;
  AnimationController _animationController;

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 260),
    );

    final curvedAnimation =
        CurvedAnimation(curve: Curves.easeInOut, parent: _animationController);
    _animation = Tween<double>(begin: 0, end: 1).animate(curvedAnimation);

    super.initState();
  }

  @override
  dispose() {
    _animationController.dispose(); // you need this
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Build View
    return Scaffold(
        backgroundColor: NeumorphicTheme.baseColor(context),
        appBar: titleAppBar("Home"),
        floatingActionButton:
            FloaterButton(_animation, _animationController, (button) {
          // File Option
          if (button == "File") {
            // Push to Transfer Screen
            Get.offNamed("/transfer");
          }
          // Contact Option
          else {
            log.w("Contact not implemented yet");
          }
        }),
        body: _HomeView());
  }
}

class _HomeView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final SonrController sonrController = Get.find();
    Obx(() {
      if (sonrController.status == SonrStatus.Pending) {
        Get.dialog(widget);
      }
    });
    return MultiBlocListener(
      listeners: [
        BlocListener<AuthenticationCubit, AuthMessage>(
          cubit: context.getCubit(CubitType.Authentication),
          listener: (context, state) {
            if (state.event == AuthMessage_Event.REQUEST) {
              // Display Bottom Sheet
              showModalBottomSheet<void>(
                  shape: windowBorder(),
                  barrierColor: Colors.black87,
                  isDismissible: false,
                  context: context,
                  builder: (context) {
                    return Window.showAuth(context, state);
                  });
            }
          },
        ),
        BlocListener<SonrBloc, SonrState>(
          listener: (context, state) {
            if (state is NodeReceiveInProgress) {
              // Display Bottom Sheet
              showModalBottomSheet<void>(
                  shape: windowBorder(),
                  barrierColor: Colors.black87,
                  isDismissible: false,
                  context: context,
                  builder: (context) {
                    return Window.showTransferring(context, state);
                  });
            }
          },
        ),
      ],
      child: ImageGrid(),
    );
  }
}
