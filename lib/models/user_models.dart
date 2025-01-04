class User {
  final String userId;
  final String nameSurname;
  final String email;

  const User({
    required this.userId,
    required this.nameSurname,
    required this.email,
  });
}

class MockUser extends User {
  final String password;

  const MockUser({
    required super.userId,
    required super.nameSurname,
    required super.email,
    required this.password,
  });
}
