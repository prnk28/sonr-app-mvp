class ProfileModel {
  // Initial Data
  final String firstName;
  final String lastName;
  final String profilePicture;

  // Constructor
  ProfileModel(this.firstName, this.lastName, this.profilePicture);

  // TODO: sonar_id "Add MongoDB reference ID to be able to modify/reference user details"
  // Generation Method
  toJSON() {
    return {
      'first_name' : firstName,
      'last_name' : lastName,
      'profile_picture' : profilePicture,
    };
  }
}