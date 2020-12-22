import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:get/get.dart';
import 'package:sonar_app/theme/theme.dart';
import 'package:sonar_app/service/device_service.dart';
import 'package:sonr_core/sonr_core.dart';

part 'form_view.dart';

class RegisterScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: SonrAppBar("Sonr"),
        backgroundColor: NeumorphicTheme.baseColor(context),
        body: Column(children: <Widget>[
          Padding(
              padding: EdgeInsets.symmetric(vertical: 10.0), child: FormView())
        ]));
  }
}

// ^ Builds Neumorphic Text Field ^ //
class NeuomorphicTextField extends StatefulWidget {
  final String label;
  final String hint;

  final ValueChanged<String> onChanged;

  NeuomorphicTextField(
      {@required this.label, @required this.hint, this.onChanged});

  @override
  _NeuomorphicTextFieldState createState() => _NeuomorphicTextFieldState();
}

class _NeuomorphicTextFieldState extends State<NeuomorphicTextField> {
  TextEditingController _controller;
  String get text => _controller.value.text;

  @override
  void initState() {
    _controller = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8),
          child: Text(
            this.widget.label,
            style: TextStyle(
              fontWeight: FontWeight.w700,
              color: NeumorphicTheme.defaultTextColor(context),
            ),
          ),
        ),
        Neumorphic(
          margin: EdgeInsets.only(left: 8, right: 8, top: 2, bottom: 4),
          style: NeumorphicStyle(
            depth: NeumorphicTheme.embossDepth(context),
            boxShape: NeumorphicBoxShape.stadium(),
          ),
          padding: EdgeInsets.symmetric(vertical: 14, horizontal: 18),
          child: TextField(
            onChanged: this.widget.onChanged,
            controller: _controller,
            decoration: InputDecoration.collapsed(hintText: this.widget.hint),
          ),
        )
      ],
    );
  }
}
