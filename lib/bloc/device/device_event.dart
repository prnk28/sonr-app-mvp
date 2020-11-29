part of 'device_bloc.dart';

abstract class DeviceEvent extends Equatable {
  const DeviceEvent();

  @override
  List<Object> get props => [];
}

// ** Enum defines Type of Permission **
enum PermissionType {
  Location,
  Camera,
  Photos,
  Notifications,
}

// ^ StartApp Event ^ //
//(Sets Device Parameters, Checks for Required Permissions, Locates Profile, and starts Sonr)
class StartApp extends DeviceEvent {
  final SonrController sonrController;
  const StartApp(this.sonrController);
}

// ^ RequestPermission Event ^ //
// (Requests User for a App Permission)
class RequestPermission extends DeviceEvent {
  final PermissionType type;
  const RequestPermission(this.type);
}

// ^ CreateProfile Event ^ //
// (Creates New Profile from Contact Object)
class CreateUser extends DeviceEvent {
  final Contact contact;
  final BuildContext context;
  const CreateUser(this.context, this.contact);
}

// *********************
// ** Direction Cubit **
// *********************
class DirectionCubit extends Cubit<double> {
  DirectionCubit() : super(0);

  void update(double newValue) {
    emit(newValue);
  }
}
