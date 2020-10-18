part of 'user_bloc.dart';

abstract class UserEvent extends Equatable {
  const UserEvent();

  @override
  List<Object> get props => [];
}

// Get User Ready on Device
class CheckProfile extends UserEvent {
  const CheckProfile();
}

// Login/Signup to account save info data bloc
class Register extends UserEvent {
  const Register();
}

// Update Profile/Contact Info
class UpdateProfile extends UserEvent {
  final Profile newProfile;
  const UpdateProfile(this.newProfile);
}
