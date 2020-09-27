import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:sonar_app/models/models.dart';
import 'package:sonar_app/repository/repository.dart';

part 'data_event.dart';
part 'data_state.dart';

class DataBloc extends Bloc<DataEvent, DataState> {
  DataBloc() : super(null);

  // Initialize Repositories
  LocalData localData = new LocalData();

  // Initialize References
  Profile currentProfile;

  @override
  Stream<DataState> mapEventToState(
    DataEvent event,
  ) async* {
    if (event is UpdateProfile) {
      yield* _mapUpdateProfileState(event);
    } else if (event is UpdateAccount) {
      yield* _mapUpdateAccountState(event);
    } else if (event is CheckLocalStatus) {
      yield* _mapCheckLocalStatusState(event);
    } else if (event is SaveFile) {
      yield* _mapSaveFileState(event);
    } else if (event is SelectFile) {
      yield* _mapSelectFileState(event);
    } else if (event is FindFile) {
      yield* _mapFindFileState(event);
    } else if (event is OpenFile) {
      yield* _mapOpenFileState(event);
    }
  }

// ***********************
// ** UpdateProfile Event **
// *************************
  Stream<DataState> _mapUpdateProfileState(
      UpdateProfile updateProfileEvent) async* {
    // Save to Box
    await localData.updateProfile(updateProfileEvent.data);

    // Update Reference
    this.currentProfile = updateProfileEvent.data;

    // Profile Ready
    yield Standby();
  }

// ***********************
// ** UpdateAccount Event **
// *************************
  Stream<DataState> _mapUpdateAccountState(
      UpdateAccount updateAccountEvent) async* {
    // Check Status
  }

// ****************************
// ** CheckLocalStatus Event **
// ****************************
  Stream<DataState> _mapCheckLocalStatusState(
      CheckLocalStatus checkLocalStatusEvent) async* {
    // Check Status
    var profile = await localData.getProfile();

    // Create Delay
    await Future.delayed(const Duration(milliseconds: 1500));

    // No Profile
    if (profile == null) {
      // Update Reference
      this.currentProfile = null;

      // Change State
      yield Unavailable();
    }
    // Profile Found
    else {
      // Update Reference
      this.currentProfile = profile;

      // Profile Ready
      yield Standby();
    }
  }

// ********************
// ** SaveFile Event **
// ********************
  Stream<DataState> _mapSaveFileState(SaveFile saveFileEvent) async* {
    // Check Status
  }

// **********************
// ** SelectFile Event **
// **********************
  Stream<DataState> _mapSelectFileState(SelectFile selectFileEvent) async* {
    // Check Status
  }

// ********************
// ** FindFile Event **
// ********************
  Stream<DataState> _mapFindFileState(FindFile findFileEvent) async* {
    // Check Status
  }

// ********************
// ** OpenFile Event **
// ********************
  Stream<DataState> _mapOpenFileState(OpenFile openFileEvent) async* {
    // Check Status
  }
}
