class User {
  final String userId;
  final String nameSurname;
  final String email;
  Set<String> followedUsers;

  User({
    required this.userId,
    required this.nameSurname,
    required this.email,
    required this.followedUsers,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      userId: json["userId"],
      nameSurname: json["nameSurname"],
      email: json["email"],
      followedUsers: Set<String>.from(json["followedUsers"]),
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is User && other.userId == userId;
  }

  @override
  int get hashCode => userId.hashCode;
}
