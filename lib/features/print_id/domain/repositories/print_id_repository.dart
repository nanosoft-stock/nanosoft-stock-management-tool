abstract class PrintIdRepository {
  Future<List<String>> getItemIds(String countString);

  Future<List<String>> getContainerIds(String countString);

  Future<void> printItemIds(List<String> newIds);

  Future<void> printContainerIds(List<String> newIds);
}
