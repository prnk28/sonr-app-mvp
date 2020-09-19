part of 'data_bloc.dart';

abstract class DataState extends Equatable {
  const DataState();
  
  @override
  List<Object> get props => [];
}

class DataInitial extends DataState {}
