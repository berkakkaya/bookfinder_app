import "package:bookfinder_app/models/user_models.dart";

class MockUser extends User {
  final String password;

  const MockUser({
    required super.userId,
    required super.nameSurname,
    required super.email,
    required this.password,
  });
}
