part of 'sonr_service.dart';

// ^ Sonr Service Status Enum ^ //
enum SonrStatus {
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
  final String method;
  final String message;

  SonrError(this.method, this.message);
}
