import 'package:equatable/equatable.dart';
import 'package:sonar_app/core/core.dart';
import 'package:sonar_app/models/client.dart';
import 'package:sonar_app/models/models.dart';

class Data extends Equatable {
// *******************
  // ** JSON Values **
  // *******************
  // Interpreted
  final DataType kind;
  final Object value;

  // *********************
  // ** Constructor Var **
  // *********************
  const Data(
    {this.kind,
    this.value}
  );

  // **************************
  // ** Class Implementation **
  // **************************
  @override
  List<Object> get props => [value, kind];

  // ***********************
  // ** Object Generation **
  // ***********************
  // Create Object from Events
  static Data fromMessage(MessageCategory category, Map data) {
    switch (category) {
      case MessageCategory.Authorization:
            return Data();
        break;
      case MessageCategory.Client:
        return Data(kind: DataType.Client, value: Client.fromMap(data));
        break;
      case MessageCategory.Lobby:
        return Data(kind: DataType.Lobby, value: Lobby.fromMap(data));
        break;
      case MessageCategory.Sender:
        
        break;
      case MessageCategory.Receiver:
        
        break;
      case MessageCategory.WebRTC:
        
        break;
      case MessageCategory.Error:
        
        break;
    }
    return Data(kind: DataType.None, value: null);
  }
}
