abstract class ModifyCategoryRepository {
  void listenToCloudDataChange(
      {required Map modifyCategoryData, required Function(Map) onChange});

  List<String> getAllCategories();

  Map<String, dynamic> getOptions();

  Map<String, dynamic> getFieldDataFields();

  Map<String, dynamic> getToolTips();

  List<String> getRearrangeAbleFields(String category);

  Map<String, dynamic> getFieldDetails(String category);

  Map<String, dynamic> getFieldAutoFillData(String field);

  Future<void> modifyCategory(Map<String, dynamic> modifyCategoryData);
}
