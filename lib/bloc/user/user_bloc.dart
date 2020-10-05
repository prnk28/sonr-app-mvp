import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:sonar_app/bloc/bloc.dart';
import 'package:sonar_app/models/models.dart';
import 'package:sonar_app/repository/repository.dart';
import 'package:sonar_app/core/core.dart';

part 'user_event.dart';
part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  UserBloc() : super(null);

  // Initialize
  Profile profile;
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
    var box = await Hive.openBox(PROFILE_BOX);
    final profileData = box.get("profile");
    await box.close();

    // Create Delay
    await Future.delayed(const Duration(milliseconds: 1500));

    // No Profile
    if (profileData == null) {
      // Update Reference
      this.profile = null;

      // Change State
      yield Offline();
    }
    // Profile Found
    else {
      // Update Reference
      this.profile = profileData;

      // Initialize User Node
      node = new Peer(profile);

      // Profile Ready
      yield Online(profile);
    }
  }

  // *************************
// ** UpdateProfile Event **
// *************************
  Stream<UserState> _mapUpdateProfileState(UpdateProfile event) async* {
    // Find Box
    var box = await Hive.openBox(PROFILE_BOX);

    // Put in Box
    box.put("profile", profile);

    // Log
    print('Profile: ${box.get("profile")}');

    // Close Box
    await box.close();

    // Update Reference
    this.profile = event.data;

    // Reinitialize User Node
    node = new Peer(profile);

    // Profile Ready
    yield Online(profile);
  }
}
