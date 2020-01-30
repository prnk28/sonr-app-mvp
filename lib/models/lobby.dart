import 'package:equatable/equatable.dart';
import 'models.dart';

class Lobby extends Equatable {
// *******************
  // ** JSON Values **
  // *******************
  // From JSON
  final String id;
  final Location location;
  final List senders;
  final List receivers;
  final int size;

  // *********************
  // ** Constructor Var **
  // *********************
  const Lobby({
    this.id,
    this.location,
    this.senders,
    this.receivers,
    this.size,
  });

  // **************************
  // ** Class Implementation **
  // **************************
  @override
  List<Object> get props => [
    id,
    location,
    senders,
    receivers,
    size,
      ];

  // ***********************
  // ** Object Generation **
  // ***********************
  // Create Object from Events
  static Lobby fromMap(Map json) {
      return Lobby(
          id: json["id"],
          location: Location.fromMap(json["location"]),
          senders: json["senders"],
          receivers: json["receivers"],
          size: json["size"],
          );
  }
}
