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

// -- BLoC Retreival Methods -- //
getRequestListener() {
  return BlocListener<UserBloc, UserState>(
    listenWhen: (previousState, state) {
      // Current States
      if (state is NodeRequestInitial) {
        return true;
      } else if (state is NodeReceiveInProgress) {
        return true;
      } else if (state is NodeReceiveSuccess) {
        return true;
      }
      return false;
    },
    listener: (context, state) {
      if (state is NodeRequestInitial) {
        // Display Bottom Sheet
        showModalBottomSheet<void>(
            shape: windowBorder(),
            barrierColor: Colors.black87,
            isDismissible: false,
            context: context,
            builder: (context) {
              return Window.showAuth(context, state);
            });
      } else if (state is NodeReceiveInProgress) {
        // Display Bottom Sheet
        showModalBottomSheet<void>(
            shape: windowBorder(),
            barrierColor: Colors.black87,
            isDismissible: false,
            context: context,
            builder: (context) {
              return Window.showTransferring(context, state);
            });
      } else if (state is NodeReceiveSuccess) {
        // Pop Current View
        Navigator.pop(context);

        // Show Current View
        showDialog(
            barrierColor: Colors.black87,
            context: context,
            builder: (context) {
              return Popup.showImage(context, state);
            });
      }
    },
  );
}
