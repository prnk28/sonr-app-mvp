part of 'core.dart';

// ******************************** //
// ** Frontend BLoC Event Enums ** //
// ******************************* //
// Data Event Enum
enum DataEventType { QueueFile, FindFile, OpenFile }

// Device Event Enum
enum DeviceEventType { GetLocation }

// User Event Enum
enum UserEventType { Initialize, Register, SetStatus, UpdateProfile }

// Web Event Enum
enum WebEventType { Connect, Search, Active, Invite, Authorize }

// ********************************************* //
// ** DataBLoC Applicable Events for Frontend ** //
// ********************************************* //
// Method to Emit Data Event
emitDataBlocEvent(DataEventType event, BuildContext context) {
  // Switch by Event
  switch (event) {
    case DataEventType.QueueFile:
      BlocProvider.of<DataBloc>(context).add(QueueFile());
      break;
    case DataEventType.FindFile:
      BlocProvider.of<DataBloc>(context).add(FindFile());
      break;
    case DataEventType.OpenFile:
      BlocProvider.of<DataBloc>(context).add(OpenFile());
      break;
  }
}

// *********************************************** //
// ** DeviceBLoC Applicable Events for Frontend ** //
// *********************************************** //

// Method to Emit Device Event
emitDeviceBlocEvent(DeviceEventType event, BuildContext context) {
  switch (event) {
    case DeviceEventType.GetLocation:
      BlocProvider.of<DeviceBloc>(context).add(GetLocation());
      break;
  }
}

// ********************************************* //
// ** UserBLoC Applicable Events for Frontend ** //
// ********************************************* //

// Method to Emit User Event
emitUserBlocEvent(UserEventType event, BuildContext context,
    {Profile newData, PeerStatus newStatus}) {
  switch (event) {
    case UserEventType.Initialize:
      BlocProvider.of<UserBloc>(context).add(Initialize());
      break;
    case UserEventType.Register:
      BlocProvider.of<UserBloc>(context).add(Register());
      break;
    case UserEventType.UpdateProfile:
      if (newData != null) {
        BlocProvider.of<UserBloc>(context).add(UpdateProfile(newData));
      } else {
        log.e("Profile Data not provided for UserBloc:UpdateProfile Event");
      }
      break;
    case UserEventType.SetStatus:
      BlocProvider.of<UserBloc>(context).node.status = newStatus;
      break;
  }
}

// ******************************************** //
// ** WebBLoC Applicable Events for Frontend ** //
// ******************************************** //
// Method to Emit Web Event
emitWebBlocEvent(WebEventType event, BuildContext context,
    {bool authDecision, dynamic webMessage, Peer match, Metadata metaData}) {
  switch (event) {
    case WebEventType.Connect:
      BlocProvider.of<WebBloc>(context).add(Connect());
      break;
    case WebEventType.Search:
      BlocProvider.of<WebBloc>(context).add(Search());
      break;
    case WebEventType.Active:
      BlocProvider.of<WebBloc>(context).add(Active());
      break;
    case WebEventType.Invite:
      BlocProvider.of<WebBloc>(context).add(Invite(match, metaData));
      break;
    case WebEventType.Authorize:
      BlocProvider.of<WebBloc>(context)
          .add(Authorize(authDecision, webMessage));
      break;
  }
}

// *********************** //
// ** Retrieval Methods ** //
// *********************** //
enum CubitType { Direction }
enum BlocType { Data, Device, User, Web }

getCubit(CubitType type, BuildContext context) {
  switch (type) {
    case CubitType.Direction:
      return BlocProvider.of<DeviceBloc>(context).directionCubit;
      break;
  }
  return null;
}

getBloc(BlocType type, BuildContext context) {
  switch (type) {
    case BlocType.Data:
      return BlocProvider.of<DataBloc>(context);
      break;
    case BlocType.Device:
      return BlocProvider.of<DeviceBloc>(context);
      break;
    case BlocType.User:
      return BlocProvider.of<UserBloc>(context);
      break;
    case BlocType.Web:
      return BlocProvider.of<WebBloc>(context);
      break;
  }
}
