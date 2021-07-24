class UserDoc {
  UserDoc({required this.sName, required this.pushToken});

  final String sName;
  final String pushToken;

  UserDoc.fromJson(Map<String, Object?> json)
      : this(
          sName: json['sName']! as String,
          pushToken: json['pushToken']! as String,
        );

  Map<String, Object?> toJson() {
    return {
      'sName': sName,
      'pushToken': pushToken,
    };
  }
}
