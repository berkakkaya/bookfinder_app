import "package:bookfinder_app/consts/mock_datas.dart";
import "package:bookfinder_app/models/bookdata_models.dart";
import "package:bookfinder_app/models/mock_datamodels.dart";

class MockApiDb {
  final List<MockUser> mockUsers = [];
  final List<BookData> mockBookDatas = [];

  MockApiDb({bool fillWithMockDatas = true}) {
    if (fillWithMockDatas) {
      mockUsers.addAll(mockUserDatas);
      mockBookDatas.addAll(mockBookDatas);
    }
  }
}
