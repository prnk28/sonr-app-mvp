class UserManager {
  static checkLocationPermission() async {
    if (await Geolocator().checkGeolocationPermissionStatus() ==
        GeolocationStatus.granted) {
      return true;
    } else {
      return false;
    }
  }
}