part of 'user_bloc.dart';

abstract class UserEvent extends Equatable {
  const UserEvent();

  @override
  List<Object> get props => [];
}

// Get User Ready on Device
class Initialize extends UserEvent {
  const Initialize();
}

// Login/Signup to account save info data bloc
class Register extends UserEvent {
  const Register();
}

// Update Profile/Contact Info
class UpdateProfile extends UserEvent {
  final Profile data;
  const UpdateProfile(this.data);
}
