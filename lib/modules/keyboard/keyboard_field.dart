import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:keyboard_actions/keyboard_actions_config.dart';
import 'package:keyboard_actions/keyboard_custom.dart';
import 'package:sonr_app/style/style.dart';
import 'keyboard_view.dart';

class ColorField extends StatelessWidget {
  final FocusNode _focusNode = FocusNode();
  final notifier = ValueNotifier<Color>(Colors.blue);

  /// Creates the [KeyboardActionsConfig] to hook up the fields
  /// and their focus nodes to our [FormKeyboardActions].
  KeyboardActionsConfig _buildConfig(BuildContext context) {
    return KeyboardActionsConfig(
      keyboardActionsPlatform: KeyboardActionsPlatform.ALL,
      keyboardBarColor: Colors.grey[200],
      nextFocus: true,
      actions: [
        KeyboardActionsItem(
          focusNode: _focusNode,
          footerBuilder: (_) => ColorPickerKeyboard(
            notifier: notifier,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return KeyboardActions(
      config: _buildConfig(context),
      child: Center(
        child: Container(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              KeyboardCustomInput<Color>(
                focusNode: _focusNode,
                height: 65,
                notifier: notifier,
                builder: (context, val, hasFocus) {
                  return Container(
                    width: double.maxFinite,
                    color: val,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CardField extends StatelessWidget {
  final FocusNode _focusNode = FocusNode();
  final notifier = ValueNotifier<int>(0);

  /// Creates the [KeyboardActionsConfig] to hook up the fields
  /// and their focus nodes to our [FormKeyboardActions].
  KeyboardActionsConfig _buildConfig(BuildContext context) {
    return KeyboardActionsConfig(
      keyboardActionsPlatform: KeyboardActionsPlatform.ALL,
      keyboardBarColor: Colors.grey[200],
      nextFocus: true,
      actions: [
        KeyboardActionsItem(
          focusNode: _focusNode,
          footerBuilder: (_) => CardPickerKeyboard(
            notifier: notifier,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return KeyboardActions(
      config: _buildConfig(context),
      child: Center(
        child: Container(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              KeyboardCustomInput<int>(
                focusNode: _focusNode,
                height: 65,
                notifier: notifier,
                builder: (context, val, hasFocus) {
                  return Container(
                    width: double.maxFinite,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                      image: AssetImage("assets/cards/0$val.png"),
                    )),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
