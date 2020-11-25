part of 'sonr_bloc.dart';

abstract class SonrState extends Equatable {
  const SonrState();
  
  @override
  List<Object> get props => [];
}

class SonrInitial extends SonrState {}
