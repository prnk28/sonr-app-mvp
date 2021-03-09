import 'dart:convert';

import 'package:sonr_app/service/user_service.dart';
import 'package:wiredash/wiredash.dart';

const String data = '''
  {
    "captureSaveScreenshot": "Save screenshot",
    "captureSkip": "Skip screenshot",
    "captureSpotlightNavigateMsg": "Navigate to the screen which you would like to attach to your capture.",
    "captureSpotlightNavigateTitle": "navigate",
    "captureSpotlightScreenCapturedMsg": "Screen captured! Feel free to draw on the screen to highlight areas affected by your capture.",
    "captureSpotlightScreenCapturedTitle": "draw",
    "captureTakeScreenshot": "Take screenshot",
    "feedbackBack": "Edit Feedback",
    "feedbackCancel": "Cancel",
    "feedbackModeBugMsg": "Let me know so I can fix it in the next build.",
    "feedbackModeBugTitle": "Report Bug",
    "feedbackModeImprovementMsg": "Lets not get carried away with this button, but let me know if you have any features in mind!",
    "feedbackModeImprovementTitle": "Send Suggestion",
    "feedbackModePraiseMsg": "Let us know what you really like about our app, maybe we can make it even better?",
    "feedbackModePraiseTitle": "Send Applause",
    "feedbackSave": "Continue",
    "feedbackSend": "Finish",
    "feedbackStateEmailMsg": "You'll be notified once I finish fixing the bug, or if I have additional questions.",
    "feedbackStateEmailTitle": "Stay in the loop 👇",
    "feedbackStateFeedbackMsg": "For bugs please it would be ideal if in the feedback 'Where it Happened' and 'What Happened' was provided.",
    "feedbackStateIntroMsg": "Would you like to report an issue or suggestion about Sonr?",
    "feedbackStateIntroTitle": "Hi there 👋",
    "feedbackStateSuccessCloseMsg": "Thanks for submitting your feedback!",
    "feedbackStateSuccessCloseTitle": "Close this Dialog",
    "feedbackStateSuccessMsg": "That's it. Thank you so much for helping us build a better app!",
    "feedbackStateSuccessTitle": "Thank you ✌️",
    "inputHintEmail": "Your email",
    "inputHintFeedback": "Your feedback",
    "validationHintEmail": "Please enter a valid email or leave this field blank.",
    "validationHintFeedbackEmpty": "Please provide your feedback.",
    "validationHintFeedbackLength": "Your feedback is too long.",
    "feedbackStateFeedbackTitle": "Your feedback ✍️",
    "firstPenLabel": "A dark brown pen",
    "secondPenLabel": "An off-white pen",
    "thirdPenLabel": "A teal highlighter",
    "fourthPenLabel": "An orange highlighter",
    "companyLogoLabel": "The Wiredash Logo",
    "undoButtonLabel": "Undo the last change",
    "firstPenSelected": "The dark brown pen is selected",
    "secondPenSelected": "The off-white pen is selected",
    "thirdPenSelected": "The teal highlighter is selected",
    "fourthPenSelected": "The orange highlighter is selected"
}
''';

class SonrWiredashTranslation extends WiredashTranslations {
  // final jsonDecode(data) = jsonDecode(data);
  const SonrWiredashTranslation() : super();

  @override
  String get captureSaveScreenshot => jsonDecode(data)["captureSaveScreenshot"];
  @override
  String get captureSkip => jsonDecode(data)["captureSkip"];
  @override
  String get captureSpotlightNavigateMsg => jsonDecode(data)["captureSpotlightNavigateMsg"];
  @override
  String get captureSpotlightNavigateTitle => jsonDecode(data)["captureSpotlightNavigateTitle"];
  @override
  String get captureSpotlightScreenCapturedMsg => jsonDecode(data)["captureSpotlightScreenCapturedMsg"];
  @override
  String get captureSpotlightScreenCapturedTitle => jsonDecode(data)["captureSpotlightScreenCapturedTitle"];
  @override
  String get captureTakeScreenshot => jsonDecode(data)["captureTakeScreenshot"];
  @override
  String get companyLogoLabel => jsonDecode(data)["companyLogoLabel"];
  @override
  String get feedbackBack => jsonDecode(data)["feedbackBack"];
  @override
  String get feedbackCancel => jsonDecode(data)["feedbackCancel"];
  @override
  String get feedbackStateIntroTitle => '👋 Hello ${UserService.firstName.value}! ';
  @override
  String get feedbackModeBugMsg => jsonDecode(data)["feedbackModeBugMsg"];
  @override
  String get feedbackModeBugTitle => jsonDecode(data)["feedbackModeBugTitle"];
  @override
  String get feedbackModeImprovementMsg => jsonDecode(data)["feedbackModeImprovementMsg"];
  @override
  String get feedbackModeImprovementTitle => jsonDecode(data)["feedbackModeImprovementTitle"];
  @override
  String get feedbackModePraiseMsg => jsonDecode(data)["feedbackModePraiseMsg"];
  @override
  String get feedbackModePraiseTitle => jsonDecode(data)["feedbackModePraiseTitle"];
  @override
  String get feedbackSave => jsonDecode(data)["feedbackSave"];
  @override
  String get feedbackSend => jsonDecode(data)["feedbackSend"];
  @override
  String get feedbackStateEmailMsg => jsonDecode(data)["feedbackStateEmailMsg"];
  @override
  String get feedbackStateEmailTitle => jsonDecode(data)["feedbackStateEmailTitle"];
  @override
  String get feedbackStateFeedbackMsg => jsonDecode(data)["feedbackStateFeedbackMsg"];
  @override
  String get feedbackStateFeedbackTitle => jsonDecode(data)["feedbackStateFeedbackTitle"];
  @override
  String get feedbackStateIntroMsg => jsonDecode(data)["feedbackStateIntroMsg"];
  @override
  String get feedbackStateSuccessCloseMsg => jsonDecode(data)["feedbackStateSuccessCloseMsg"];
  @override
  String get feedbackStateSuccessCloseTitle => jsonDecode(data)["feedbackStateSuccessCloseTitle"];
  @override
  String get feedbackStateSuccessMsg => jsonDecode(data)["feedbackStateSuccessMsg"];
  @override
  String get feedbackStateSuccessTitle => jsonDecode(data)["feedbackStateSuccessTitle"];
  @override
  String get firstPenLabel => jsonDecode(data)["firstPenLabel"];
  @override
  String get firstPenSelected => jsonDecode(data)["firstPenSelected"];
  @override
  String get fourthPenLabel => jsonDecode(data)["fourthPenLabel"];
  @override
  String get fourthPenSelected => jsonDecode(data)["fourthPenSelected"];
  @override
  String get inputHintEmail => jsonDecode(data)["inputHintEmail"];
  @override
  String get inputHintFeedback => jsonDecode(data)["inputHintFeedback"];
  @override
  String get secondPenLabel => jsonDecode(data)["secondPenLabel"];
  @override
  String get secondPenSelected => jsonDecode(data)["secondPenSelected"];
  @override
  String get thirdPenLabel => jsonDecode(data)["thirdPenLabel"];
  @override
  String get thirdPenSelected => jsonDecode(data)["thirdPenSelected"];
  @override
  String get undoButtonLabel => jsonDecode(data)["undoButtonLabel"];
  @override
  String get validationHintEmail => jsonDecode(data)["validationHintEmail"];
  @override
  String get validationHintFeedbackEmpty => jsonDecode(data)["validationHintFeedbackEmpty"];
  @override
  String get validationHintFeedbackLength => jsonDecode(data)["validationHintFeedbackLength"];
}
