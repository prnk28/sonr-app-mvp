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
    if (event is Initialize) {
      yield* _mapInitializeState(event);
    } else if (event is UpdateProfile) {
      yield* _mapUpdateProfileState(event);
    }
  }

// ***********************
// ** Initialize Event **
// ***********************
  Stream<UserState> _mapInitializeState(Initialize event) async* {
    // Retrieve Profile
    var profile = await localData.getProfile();

    // Create Delay
    await Future.delayed(const Duration(milliseconds: 1500));

    // No Profile
    if (profile == null) {
      // Change State
      yield Offline();
    }
    // Profile Found
    else {
      // Initialize User Node
      node = new Peer(profile: profile);

      // Profile Ready
      yield Online(node);
    }
  }

// *************************
// ** UpdateProfile Event **
// *************************
  Stream<UserState> _mapUpdateProfileState(UpdateProfile event) async* {
    // Save to Box
    await localData.updateProfile(event.newProfile);

    // Reinitialize User Node
    node = new Peer(profile: event.newProfile);

    // Profile Ready
    yield Online(node);
  }
}
