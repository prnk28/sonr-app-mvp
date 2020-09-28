part of 'user_bloc.dart';

abstract class UserEvent extends Equatable {
  const UserEvent();

  @override
  List<Object> get props => [];
}

// Login to account save info data bloc
class Login extends UserEvent {
  const Login();
}

// Register for new account, save info
class SignUp extends UserEvent {
  const SignUp();
}

// Register for new account, save info
class ChangePreferences extends UserEvent {
  const ChangePreferences();
}

// Get online/local account status
class CheckStatus extends UserEvent {
  const CheckStatus();
}

// Update Profile/Contact Info
class UpdateProfile extends UserEvent {
  final Profile data;
  const UpdateProfile(this.data);
}

// Update Account Settings
class UpdateAccount extends UserEvent {
  const UpdateAccount();
}
