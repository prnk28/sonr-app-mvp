part of 'user_bloc.dart';

abstract class UserEvent extends Equatable {
  const UserEvent();

  @override
  List<Object> get props => [];
}

// Get User Ready on Device
class UserStarted extends UserEvent {
  const UserStarted();
}

// Update Profile/Contact Info
class ProfileUpdated extends UserEvent {
  final Profile newProfile;
  const ProfileUpdated(this.newProfile);
}
