import 'package:flutter/material.dart';
import 'package:sonar_app/bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'modals/modals.dart';
import 'screens/screens.dart';

enum CubitType { Direction, Exchange, Peers }
enum BlocType { Device, File, Sonr }

extension Events on BuildContext {
  // -- Retrieval Methods --
  getBloc(BlocType type) {
    switch (type) {
      case BlocType.Sonr:
        return BlocProvider.of<SonrBloc>(this);
        break;
      case BlocType.Device:
        return BlocProvider.of<DeviceBloc>(this);
        break;
      case BlocType.File:
        return BlocProvider.of<FileBloc>(this);
        break;
    }
    return null;
  }

  getCubit(CubitType type) {
    switch (type) {
      case CubitType.Direction:
        return BlocProvider.of<DeviceBloc>(this).directionCubit;
        break;
      case CubitType.Exchange:
        return BlocProvider.of<SonrBloc>(this).exchangeProgress;
        break;
      case CubitType.Peers:
        return BlocProvider.of<SonrBloc>(this).availablePeers;
        break;
    }
    return null;
  }
}

// -- BLoC Retreival Methods -- //
getRequestListener() {
  return BlocListener<SonrBloc, SonrState>(
    listenWhen: (previousState, state) {
      // Current States
      if (state is NodeInvited) {
        return true;
      } else if (state is NodeReceiveInProgress) {
        return true;
      } else if (state is NodeReceiveSuccess) {
        return true;
      }
      return false;
    },
    listener: (context, state) {
      if (state is NodeInvited) {
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
