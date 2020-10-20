part of 'core.dart';

// ** Frontend BLoC Event Enums ** //
// Data Event Enum
enum DataEventType { QueueIncomingFile, QueueOutgoingFile, FindFile, OpenFile }

// Device Event Enum
enum DeviceEventType { Initialize }

// User Event Enum
enum UserEventType { CheckProfile, Register, SetStatus, UpdateProfile }

// Web Event Enum
enum WebEventType { Connect, Search, Active, Invite, Authorize }

// Cubit Name Enum
enum CubitType { Direction, Progress }
enum BlocType { Data, Device, User, Web }

extension Events on BuildContext {
// *********************** //
// ** Retrieval Methods ** //
// *********************** //
  getBloc(BlocType type) {
    switch (type) {
      case BlocType.Data:
        return BlocProvider.of<DataBloc>(this);
        break;
      case BlocType.Device:
        return BlocProvider.of<DeviceBloc>(this);
        break;
      case BlocType.User:
        return BlocProvider.of<UserBloc>(this);
        break;
      case BlocType.Web:
        return BlocProvider.of<WebBloc>(this);
        break;
    }
    return null;
  }

  getCubit(CubitType type) {
    switch (type) {
      case CubitType.Direction:
        return BlocProvider.of<DeviceBloc>(this).directionCubit;
        break;
      case CubitType.Progress:
        return BlocProvider.of<DataBloc>(this).progress;
        break;
    }
    return null;
  }

// ******************* //
// ** Miscellaneous ** //
// ******************* //
  setScreenSize() {
    // Get Screen Size
    double width = MediaQuery.of(this).size.width;
    double height = MediaQuery.of(this).size.height;
    screenSize = Size(width, height);
  }
}
