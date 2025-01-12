import "package:bookfinder_app/models/book_tracking_models.dart";
import "package:bookfinder_app/models/user_models.dart";

class MockUser extends User {
  final String password;

  const MockUser({
    required super.userId,
    required super.nameSurname,
    required super.email,
    required this.password,
    required super.followedUsers,
  });
}

class MockBookTrackingData extends BookTrackingData {
  final String userId;

  MockBookTrackingData({
    required this.userId,
    required super.bookId,
    required super.status,
  });
}
