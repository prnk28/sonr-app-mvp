part of 'core.dart';

// Cubit Name Enum
enum CubitType { Direction, Progress }
enum BlocType { Data, Device, User, Signal }

extension Events on BuildContext {
  // -- Retrieval Methods --
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
      case BlocType.Signal:
        return BlocProvider.of<SignalBloc>(this);
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

// -- Global Screen Size --
  setScreenSize() {
    // Get Screen Size
    double width = MediaQuery.of(this).size.width;
    double height = MediaQuery.of(this).size.height;
    screenSize = Size(width, height);
  }
}
