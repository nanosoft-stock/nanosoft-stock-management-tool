abstract class LocateStockRepository {
  Future<List> getIds({required String searchBy});

  Future<List> getIdSpecificData({required String searchBy, required List selectedIds});
}
