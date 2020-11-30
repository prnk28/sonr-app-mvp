// ^ Device Status Enum ^ //
enum DeviceStatus {
  // Default
  Initial,

  // Start Up
  Active,
  NoProfile,

  // Permissions
  LocationGranted,
  CameraGranted,
  PhotosGranted,
  NotificationsGranted,
}

// ^ Enum defines Type of Permission ^ //
enum PermissionType {
  Location,
  Camera,
  Photos,
  Notifications,
}

// ^ Required Permission not found ^
class ProfileError extends Error {
  final String message;

  ProfileError(this.message);
}

// ^ Required Permission not found ^
class RequiredPermissionsError extends Error {
  final String message;

  RequiredPermissionsError(this.message);
}

// ^ Device wasnt granted permission ^
class PermissionFailure extends Error {
  final String message;
  PermissionFailure(this.message);
}
