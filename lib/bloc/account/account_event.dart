part of 'account_bloc.dart';

abstract class AccountEvent extends Equatable {
  const AccountEvent();

  @override
  List<Object> get props => [];
}

// Login to account save info data bloc
class Login extends AccountEvent {
  const Login();
}

// Register for new account, save info
class SignUp extends AccountEvent {
  const SignUp();
}

// Register for new account, save info
class ChangePreferences extends AccountEvent {
  const ChangePreferences();
}

// Get online account status
class CheckOnlineStatus extends AccountEvent {
  const CheckOnlineStatus();
}
