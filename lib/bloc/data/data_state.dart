part of 'data_bloc.dart';

enum DataBlocStatus {
  Loading,
  Ready,
  
}

abstract class DataState extends Equatable {
  const DataState();

  @override
  List<Object> get props => [];
}

class DataInitial extends DataState {}
