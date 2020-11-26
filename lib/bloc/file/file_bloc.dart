import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:sonr_core/sonr_core.dart';
import 'package:equatable/equatable.dart';

part 'file_event.dart';
part 'file_state.dart';

// ^ FileBloc handles File Searching/Sharing Management ^
class FileBloc extends Bloc<FileEvent, FileState> {
  FileBloc() : super(AllFilesLoading());

  @override
  Stream<FileState> mapEventToState(
    FileEvent event,
  ) async* {
    if (event is GetAllFiles) {
      yield* _mapGetAllFilesState(event);
    } else if (event is GetFile) {
      yield* _mapGetFileState(event);
    }
  }

  // ^ GetAllFiles Event ^
  Stream<FileState> _mapGetAllFilesState(GetAllFiles event) async* {
    // ! Location Permission Denied
    yield AllFilesSuccess();
  }

  // ^ GetFile Event ^
  Stream<FileState> _mapGetFileState(GetFile event) async* {
    // ! Location Permission Denied
    yield AllFilesSuccess();
  }
}
