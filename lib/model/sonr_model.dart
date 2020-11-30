// ^ Auth Update Status Enum ^ //
enum AuthStatus {
  None,
  Invited,
  Accepted,
  Declined,
  Completed,
}

// ^ Core Library had Error ^ //
class SonrError extends Error {
  final String message;

  SonrError(this.message);
}
