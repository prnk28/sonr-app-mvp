part of 'core.dart';

// ** Frontend BLoC Event Enums ** //
// Data Event Enum
enum DataEventType { QueueFile, FindFile, OpenFile }

// Device Event Enum
enum DeviceEventType { Initialize }

// User Event Enum
enum UserEventType { CheckProfile, Register, SetStatus, UpdateProfile }

// Web Event Enum
enum WebEventType { Connect, Search, Active, Invite, Authorize }

// BLoC/Cubit Name Enum
enum CubitType { Direction, Progress }

extension Events on BuildContext {
// ** DataBLoC Applicable Events for Frontend ** //
  emitDataBlocEvent(DataEventType event, {Metadata file}) async {
    // Switch by Event
    switch (event) {
      case DataEventType.QueueFile:
        BlocProvider.of<DataBloc>(this).add(QueueFile());
        break;
      case DataEventType.FindFile:
        BlocProvider.of<DataBloc>(this).add(FindFile());
        break;
      case DataEventType.OpenFile:
        BlocProvider.of<DataBloc>(this).add(OpenFile(file));
        break;
    }
  }

// ** DeviceBLoC Applicable Events for Frontend ** //
  emitDeviceBlocEvent(DeviceEventType event) {
    switch (event) {
      case DeviceEventType.Initialize:
        BlocProvider.of<DeviceBloc>(this).add(Initialize());
        break;
    }
  }

// ** UserBLoC Applicable Events for Frontend ** //
  emitUserBlocEvent(UserEventType event,
      {Profile newProfile, Status newStatus}) {
    switch (event) {
      case UserEventType.CheckProfile:
        BlocProvider.of<UserBloc>(this).add(CheckProfile());
        break;
      case UserEventType.Register:
        BlocProvider.of<UserBloc>(this).add(Register());
        break;
      case UserEventType.UpdateProfile:
        if (newProfile != null) {
          BlocProvider.of<UserBloc>(this).add(UpdateProfile(newProfile));
        } else {
          log.e("Profile Data not provided for UserBloc:UpdateProfile Event");
        }
        break;
      case UserEventType.SetStatus:
        BlocProvider.of<UserBloc>(this).node.status = newStatus;
        break;
    }
  }

// ** WebBLoC Applicable Events for Frontend ** //
  emitWebBlocEvent(WebEventType event,
      {bool decision, Peer match, dynamic offer, dynamic answer}) {
    switch (event) {
      case WebEventType.Connect:
        BlocProvider.of<WebBloc>(this).add(Connect());
        break;
      case WebEventType.Search:
        BlocProvider.of<WebBloc>(this).add(Update(Status.Searching));
        break;
      case WebEventType.Active:
        BlocProvider.of<WebBloc>(this).add(Update(Status.Available));
        break;
      case WebEventType.Invite:
        BlocProvider.of<WebBloc>(this)
            .add(Update(Status.Pending, from: match));
        break;
      case WebEventType.Authorize:
        BlocProvider.of<WebBloc>(this).add(Update(Status.Authorized,
            decision: decision, from: match, offer: offer));
        break;
    }
  }

// *********************** //
// ** Retrieval Methods ** //
// *********************** //
  getCubit(CubitType type) {
    switch (type) {
      case CubitType.Direction:
        return BlocProvider.of<DeviceBloc>(this).directionCubit;
        break;
      case CubitType.Progress:
        return BlocProvider.of<DataBloc>(this).progressCubit;
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
