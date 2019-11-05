class SonarClientInfo {
  String websocketsID;
  String model;
  int manufactureYear;
  int vehicleAge;
  String color;

  String get wsID {
    return websocketsID;
  }

  set wsID(String clientWsID) {
    websocketsID = clientWsID;
  }
}