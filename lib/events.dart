import 'package:flutter/material.dart';
import 'package:sonar_app/bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'screens/screens.dart';

enum BlocType { Device, File }

extension Events on BuildContext {
  // -- Retrieval Methods --
  getBloc(BlocType type) {
    switch (type) {
      case BlocType.Device:
        return BlocProvider.of<DeviceBloc>(this);
        break;
      case BlocType.File:
        return BlocProvider.of<FileBloc>(this);
        break;
    }
    return null;
  }
}
