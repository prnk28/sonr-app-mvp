import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'sonr_event.dart';
part 'sonr_state.dart';

class SonrBloc extends Bloc<SonrEvent, SonrState> {
  SonrBloc() : super(SonrInitial());

  @override
  Stream<SonrState> mapEventToState(
    SonrEvent event,
  ) async* {
    // TODO: implement mapEventToState
  }
}
