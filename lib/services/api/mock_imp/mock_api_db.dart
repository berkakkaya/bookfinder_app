import "package:bookfinder_app/consts/mock_datas.dart" as mock_datas;
import "package:bookfinder_app/models/book_tracking_models.dart";
import "package:bookfinder_app/models/bookdata_models.dart";
import "package:bookfinder_app/models/mock_datamodels.dart";

class MockApiDb {
  final List<MockUser> mockUsers = [];
  final List<BookData> mockBookDatas = [];
  final List<BookTrackingData> mockBookTrackingDatas = [];

  MockApiDb({bool fillWithMockDatas = true}) {
    if (fillWithMockDatas) {
      mockUsers.addAll(mock_datas.mockUserDatas);
      mockBookDatas.addAll(mock_datas.mockBookDatas);
    }
  }
}
