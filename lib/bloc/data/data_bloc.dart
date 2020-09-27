import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:sonar_app/core/file/file.dart';
import 'package:sonar_app/models/models.dart';
import 'package:sonar_app/repository/repository.dart';

part 'data_event.dart';
part 'data_state.dart';

class DataBloc extends Bloc<DataEvent, DataState> {
  DataBloc() : super(null);

  // Initialize Repositories
  LocalData localData = new LocalData();
  BytesBuilder block = new BytesBuilder();

  // Map Methods
  @override
  Stream<DataState> mapEventToState(
    DataEvent event,
  ) async* {
    if (event is AddChunk) {
      yield* _mapAddChunkState(event);
    } else if (event is UpdateProgress) {
      yield* _mapUpdateProgressState(event);
    } else if (event is WriteFile) {
      yield* _mapWriteFileState(event);
    } else if (event is SelectFile) {
      yield* _mapSelectFileState(event);
    } else if (event is FindFile) {
      yield* _mapFindFileState(event);
    } else if (event is OpenFile) {
      yield* _mapOpenFileState(event);
    }
  }

// ********************
// ** AddChunk Event **
// ********************
  Stream<DataState> _mapAddChunkState(AddChunk addChunkEvent) async* {
    // Check Status
  }

// ********************
// ** UpdateProgress Event **
// ********************
  Stream<DataState> _mapUpdateProgressState(UpdateProgress updateEvent) async* {
    // Check Status
  }

// *********************
// ** WriteFile Event **
// *********************
  Stream<DataState> _mapWriteFileState(WriteFile writeFileEvent) async* {
    // Check Status
  }

// **********************
// ** SelectFile Event **
// **********************
  Stream<DataState> _mapSelectFileState(SelectFile saveFileEvent) async* {
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
