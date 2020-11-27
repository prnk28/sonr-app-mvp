import 'package:flutter/material.dart';
import 'package:sonar_app/bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sonr_core/sonr_core.dart';
import 'modals/modals.dart';
import 'screens/screens.dart';

enum CubitType { Direction, Progress, Lobby, Authentication }
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
      case CubitType.Authentication:
        return BlocProvider.of<SonrBloc>(this).authentication;
        break;
      case CubitType.Progress:
        return BlocProvider.of<SonrBloc>(this).progress;
        break;
      case CubitType.Lobby:
        return BlocProvider.of<SonrBloc>(this).lobby;
        break;
    }
    return null;
  }

// -- BLoC Retreival Methods -- //
  getRequestListener() {
    return BlocListener<AuthenticationCubit, AuthMessage>(
      cubit: getCubit(CubitType.Authentication),
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
        }
      },
    );
  }
}
