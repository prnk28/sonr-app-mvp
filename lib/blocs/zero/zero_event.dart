import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class ZeroEvent extends Equatable {
  ZeroEvent([List props = const []]) : super(props);
}

class FetchConvos extends ZeroEvent {
  final String userId;

  FetchConvos(this.userId) : super([userId]);
}

class UpdateConvos extends ZeroEvent {
  final String userId;

  UpdateConvos(this.userId) : super([userId]);
}

class DeleteConvo extends ZeroEvent {
  final String convoId;

  DeleteConvo(this.convoId) : super([convoId]);
}