abstract class PrintIdRepository {
  Future<List<String>> getIds(String printableId, String countString);

  Future<void> printItemIds(List<String> newIds);

  Future<void> printContainerIds(List<String> newIds);
}
