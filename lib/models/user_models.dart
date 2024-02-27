class User {
  String userId;
  String userZip;
  int userAge;
  String gender;
  List<int>? prefDistance;
  List<int>? prefAge;
  Map<String, double>? userMatches;

  User({
    required this.userId,
    required this.userZip,
    required this.userAge,
    required this.gender,
    this.prefDistance,
    this.prefAge,
    this.userMatches,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      userId: json['user_id'] ?? '',
      userZip: json['user_zip'] ?? '',
      userAge: json['user_age'] ?? 0,
      gender: json['gender'] ?? '',
      prefDistance: json['pref_distance'] != null
          ? List<int>.from(json['pref_distance'])
          : null,
      prefAge:
          json['pref_age'] != null ? List<int>.from(json['pref_age']) : null,
      userMatches: json['user_matches'] != null
          ? Map<String, double>.from(json['user_matches'].map(
              (key, value) => MapEntry<String, double>(key, value.toDouble())))
          : null,
    );
  }
}
