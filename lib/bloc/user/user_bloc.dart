import 'package:sonar_app/bloc/bloc.dart';
import 'package:sonar_app/core/core.dart';
import 'package:sonar_app/models/models.dart';
import 'package:sonar_app/repository/repository.dart';

part 'user_event.dart';
part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  UserBloc() : super(null);
  Peer node;

  @override
  Stream<UserState> mapEventToState(
    UserEvent event,
  ) async* {
    if (event is CheckProfile) {
      yield* _mapCheckProfileState(event);
    } else if (event is UpdateProfile) {
      yield* _mapUpdateProfileState(event);
    }
  }

// ***********************
// ** CheckProfile Event **
// ***********************
  Stream<UserState> _mapCheckProfileState(CheckProfile event) async* {
    // Retrieve Profile
    var profile = await Profile.retrieve();

    // Create Delay
    await Future.delayed(const Duration(milliseconds: 1500));

    // No Profile
    if (profile == null) {
      // Change State
      yield Unregistered();
    }
    // Profile Found
    else {
      // Initialize User Node
      node = new Peer(profile);

      // Set Node Location
      await node.setLocation();
      node.status = Status.Standby;

      // Profile Ready
      yield Online(node);
    }
  }

// *************************
// ** UpdateProfile Event **
// *************************
  Stream<UserState> _mapUpdateProfileState(UpdateProfile event) async* {
    // Save to Box
    await Profile.update(event.newProfile);

    // Reinitialize User Node
    node = new Peer(event.newProfile);

    // Set Node Location
    await node.setLocation();
    node.status = Status.Standby;

    // Profile Ready
    yield Online(node);
  }
}
