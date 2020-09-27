import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:sonar_app/bloc/bloc.dart';
import 'package:sonar_app/models/models.dart';
import 'package:sonar_app/repository/repository.dart';
import 'package:sonar_app/core/core.dart';

part 'account_event.dart';
part 'account_state.dart';

class AccountBloc extends Bloc<AccountEvent, AccountState> {
  AccountBloc() : super(null);

  // Initialize Repositories
  LocalData localData = new LocalData();

  // Initialize References
  Profile currentProfile;

  @override
  Stream<AccountState> mapEventToState(
    AccountEvent event,
  ) async* {
    if (event is UpdateProfile) {
      yield* _mapUpdateProfileState(event);
    } else if (event is CheckStatus) {
      yield* _mapCheckStatusState(event);
    } else if (event is UpdateProgress) {
      yield* _mapCheckStatusState(event);
    } else if (event is WriteFile) {}
  }

// ***********************
// ** UpdateProfile Event **
// *************************
  Stream<AccountState> _mapUpdateProfileState(
      UpdateProfile updateProfileEvent) async* {
    // Save to Box
    await localData.updateProfile(updateProfileEvent.data);

    // Update Reference
    this.currentProfile = updateProfileEvent.data;

    // Profile Ready
    yield Online(currentProfile);
  }

// ***********************
// ** CheckStatus Event **
// ***********************
  Stream<AccountState> _mapCheckStatusState(
      CheckStatus checkLocalStatusEvent) async* {
    // Check Status
    var profile = await localData.getProfile();

    // Create Delay
    await Future.delayed(const Duration(milliseconds: 1500));

    // No Profile
    if (profile == null) {
      // Update Reference
      this.currentProfile = null;

      // Change State
      yield Offline();
    }
    // Profile Found
    else {
      // Update Reference
      this.currentProfile = profile;

      // Profile Ready
      yield Online(currentProfile);
    }
  }
}
