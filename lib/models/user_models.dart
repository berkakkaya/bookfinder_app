class User {
  final String userId;
  final String nameSurname;
  final String email;

  const User({
    required this.userId,
    required this.nameSurname,
    required this.email,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      userId: json["userId"],
      nameSurname: json["nameSurname"],
      email: json["email"],
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
