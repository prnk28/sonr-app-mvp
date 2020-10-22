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
    if (event is UserStarted) {
      yield* _mapUserStartedState(event);
    } else if (event is ProfileUpdated) {
      yield* _mapProfileUpdatedState(event);
    }
  }

// ***********************
// ** UserStarted Event **
// ***********************
  Stream<UserState> _mapUserStartedState(UserStarted event) async* {
    // Retrieve Profile
    var profile = await Profile.retrieve();

    // Create Delay
    await Future.delayed(const Duration(milliseconds: 1500));

    // No Profile
    if (profile == null) {
      // Change State
      yield UserLoadFailure();
    }
    // Profile Found
    else {
      // Initialize User Node
      node = new Peer(profile);

      // Set Node Location
      await node.setLocation();
      node.status = Status.Standby;

      // Profile Ready
      yield UserLoadSuccess(node);
    }
  }

// **************************
// ** ProfileUpdated Event **
// **************************
  Stream<UserState> _mapProfileUpdatedState(ProfileUpdated event) async* {
    // Save to Box
    await Profile.update(event.newProfile);

    // Reinitialize User Node
    node = new Peer(event.newProfile);

    // Set Node Location
    await node.setLocation();
    node.status = Status.Standby;

    // Profile Ready
    yield UserLoadSuccess(node);
  }
}
