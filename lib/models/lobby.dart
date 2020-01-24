import 'package:equatable/equatable.dart';

class Lobby extends Equatable {
// *******************
  // ** JSON Values **
  // *******************
  // From JSON
  final String lobbyId;
  final List defaultMap;
  final List sendersMap;
  final List receiversMap;
  final int totalClients;
  final int totalLobbyCount;

  // *********************
  // ** Constructor Var **
  // *********************
  const Lobby({
    this.lobbyId,
    this.defaultMap,
    this.sendersMap,
    this.receiversMap,
    this.totalClients,
    this.totalLobbyCount,
  });

  // **************************
  // ** Class Implementation **
  // **************************
  @override
  List<Object> get props => [
    lobbyId,
    defaultMap,
    sendersMap,
    receiversMap,
    totalClients,
    totalLobbyCount,
      ];

  // ***********************
  // ** Object Generation **
  // ***********************
  // Create Object from Events
  static Lobby fromJSON(dynamic json) {
// Return Object
      return Lobby(
          lobbyId: json["id"],
          defaultMap: json["default_map"],
          sendersMap: json["senders_map"],
          receiversMap: json["receivers_map"],
          totalClients: json["total_lobby_clients"],
          totalLobbyCount: json["global_lobby_count"]);
  }
}
