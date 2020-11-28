
part of 'sonr_store.dart';

// ^ Sonr Service Status Enum ^ //
enum SonrStatus {
  // Default
  Offline,
  // Bi-Directional
  Available,
  Searching,
  Pending,

  // Uni-Directional
  Receiving,
  Transferring,
  CompletedTransfer,
  CompletedReceive
}

// ^ Core Library had Error ^ //
class SonrError extends Error {
  final String message;

  SonrError(this.message);
}