import 'package:equatable/equatable.dart';
import 'package:sonar_app/core/core.dart';
import 'package:sonar_app/models/models.dart';

class Message extends Equatable {
// *******************
  // ** JSON Values **
  // *******************
  // From JSON
  final int code;
  final String message;
  final Map data;

  // Interpreted Values
  final MessageCategory category;
  final DateTime received;

  // *********************
  // ** Constructor Var **
  // *********************
  const Message({
    this.code,
    this.message,
    this.data,
    this.category,
    this.received,
  });

  // **************************
  // ** Class Implementation **
  // **************************
  @override
  List<Object> get props => [
        code,
        message,
        data,
        category,
        received,
      ];

  // ***********************
  // ** Object Generation **
  // ***********************
  // Create Object from Events
  static Message fromJSON(dynamic json) {
// Return Object
    return Message(
        code: json["code"],
        message: json["message"],
        category: getMessageCategoryFromString(json["category"]),
        data: json["data"],
        received: DateTime.now());
  }
}
