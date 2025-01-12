import "package:bookfinder_app/consts/mock_datas.dart" as mock_datas;
import "package:bookfinder_app/models/bookdata_models.dart";
import "package:bookfinder_app/models/feed_models.dart";
import "package:bookfinder_app/models/library_models.dart";
import "package:bookfinder_app/models/mock_datamodels.dart";

class MockApiDb {
  final List<MockUser> mockUsers = [];
  final List<BookData> mockBookDatas = [];
  final List<MockBookTrackingData> mockBookTrackingDatas = [];
  final List<BookListItemWithBooks> mockBookListItems = [];
  final List<BaseFeedEntry> mockFeedEntries = [];

  MockApiDb({bool fillWithMockDatas = true}) {
    if (fillWithMockDatas) {
      mockUsers.addAll(mock_datas.mockUserDatas);
      mockBookDatas.addAll(mock_datas.mockBookDatas);

      for (int i = 0; i < mockUsers.length; i++) {
        final user = mockUsers[i];

        mockBookListItems.add(
          BookListItemWithBooks(
            bookListId: i.toString(),
            authorId: user.userId,
            title: "_likedBooks",
            bookCount: 0,
            isPrivate: true,
            books: [],
          ),
        );
      }
    }
  }
}
