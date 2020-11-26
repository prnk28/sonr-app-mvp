import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:sonr_core/sonr_core.dart';
import 'package:equatable/equatable.dart';

part 'file_event.dart';
part 'file_state.dart';

// ^ FileBloc handles File Searching/Sharing Management ^
class FileBloc extends Bloc<FileEvent, FileState> {
  FileBloc() : super(FileInitial());

  @override
  Stream<FileState> mapEventToState(
    FileEvent event,
  ) async* {
    // TODO: implement mapEventToState
  }
}
