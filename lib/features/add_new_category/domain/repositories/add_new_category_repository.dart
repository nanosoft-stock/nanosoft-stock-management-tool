abstract class AddNewCategoryRepository {
  void listenToCloudDataChange(
      {required Map addNewCategoryData, required Function(Map) onChange});

  Map<String, dynamic> getOptions();

  Map<String, dynamic> getFieldDataFields();

  Map<String, dynamic> getToolTips();

  List<String> getInitialRearrangeAbleFields();

  Map<String, dynamic> getInitialFieldDetails();

  Map<String, dynamic> getFieldAutoFillData(String field);

  Future<void> addNewCategory();
}
