import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:sonar_app/repository/repository.dart';
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
    // Open Provider
    MetadataProvider metadataProvider = new MetadataProvider();
    await metadataProvider.open();

    // Get All Files
    List<Metadata> allFiles = await metadataProvider.getAllFiles();

    // Validate List
    if (allFiles == null) {
      yield AllFilesError();
    }

    // Change State
    if (allFiles.length > 0) {
      yield AllFilesSuccess(allFiles);
    } else {
      yield AllFilesNone();
    }
  }

  // ^ GetFile Event ^
  Stream<FileState> _mapGetFileState(GetFile event) async* {
    // Open Provider
    MetadataProvider metadataProvider = new MetadataProvider();
    await metadataProvider.open();

    // Get File
    var metadata = await metadataProvider.getFile(event.metadata.id);

    // Validate Value
    if (metadata != null) {
      // Create File Object and Return Success
      var file = File(metadata.path);
      yield OneFileSuccess(file, metadata);
    } else {
      yield OneFileError();
    }
  }
}
