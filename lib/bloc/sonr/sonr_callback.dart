part of 'sonr_bloc.dart';
// ********************************
// ** Callbacks for Node Events ***
// ********************************

// ^ Lobby Has Been Updated ^ //
void handleRefreshed(dynamic data) async {
  // Check Type
  if (data is Lobby) {}
}

// ^ Node Has Been Invited ^ //
void handleInvited(dynamic data) async {
  if (data is AuthMessage) {}
}

// ^ Node Has Been Denied ^ //
void handleDenied(dynamic data) async {
  if (data is AuthMessage) {}
}

// ^ File has Succesfully Queued ^ //
void handleQueued(dynamic data) async {
  if (data is Metadata) {}
}

// ^ Transfer Has Updated Progress ^ //
void handleProgressed(dynamic data) async {
  if (data is ProgressMessage) {}
}

// ^ Transfer Has Succesfully Completed ^ //
void handleCompleted(dynamic data) async {
  if (data is CompletedMessage) {}
}
