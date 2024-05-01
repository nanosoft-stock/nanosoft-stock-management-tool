import 'dart:io';

import 'package:stock_management_tool/core/data/local_database/models/category_objectbox_model.dart';
import 'package:stock_management_tool/core/data/local_database/models/input_fields_objectbox_model.dart';
import 'package:stock_management_tool/core/data/local_database/models/product_objectbox_model.dart';
import 'package:stock_management_tool/core/data/local_database/models/stock_location_history_objectbox_model.dart';
import 'package:stock_management_tool/core/data/local_database/models/stock_objectbox_model.dart';

import 'objectbox.g.dart';

class ObjectBox {
  ObjectBox();

  late Store store;

  Box<CategoryObjectBoxModel>? categoryModelBox;
  Box<InputFieldsObjectBoxModel>? inputFieldsBox;
  Box<ProductObjectBoxModel>? productModelBox;
  Box<StockObjectBoxModel>? stockModelBox;
  Box<StockLocationHistoryObjectBoxModel>? stockLocationHistoryModelBox;

  Future<void> create() async {
    store = await openStore();

    categoryModelBox = Box<CategoryObjectBoxModel>(store);
    inputFieldsBox = Box<InputFieldsObjectBoxModel>(store);
    productModelBox = Box<ProductObjectBoxModel>(store);
    stockModelBox = Box<StockObjectBoxModel>(store);
    stockLocationHistoryModelBox =
        Box<StockLocationHistoryObjectBoxModel>(store);
  }

  // Categories
  void addCategory(CategoryObjectBoxModel category) {
    categoryModelBox!.put(category);
  }

  Future<void> addCategoryAsync(CategoryObjectBoxModel category) async {
    await categoryModelBox!.putAsync(category);
  }

  List<int> addCategoryList(List<CategoryObjectBoxModel> category) {
    return categoryModelBox!.putMany(category);
  }

  List<CategoryObjectBoxModel> getCategories() {
    return categoryModelBox!.getAll();
  }

  Future<List<CategoryObjectBoxModel>> getCategoriesAsync() async {
    return await categoryModelBox!.getAllAsync();
  }

  Stream<List<CategoryObjectBoxModel>> getCategoryStream(
      {bool triggerImmediately = false}) {
    final builder = categoryModelBox!.query();
    return builder
        .watch(triggerImmediately: triggerImmediately)
        .map((event) => event.find());
  }

  // Input Fields
  void addInputField(InputFieldsObjectBoxModel field) {
    inputFieldsBox!.put(field);
  }

  Future<void> addInputFieldAsync(InputFieldsObjectBoxModel field) async {
    await inputFieldsBox!.putAsync(field);
  }

  List<int> addInputFieldList(List<InputFieldsObjectBoxModel> fields) {
    return inputFieldsBox!.putMany(fields);
  }

  List<InputFieldsObjectBoxModel> getInputFields() {
    return inputFieldsBox!.getAll();
  }

  Future<List<InputFieldsObjectBoxModel>> getInputFieldsAsync() async {
    return await inputFieldsBox!.getAllAsync();
  }

  Stream<List<InputFieldsObjectBoxModel>> getInputFieldStream(
      {bool triggerImmediately = false}) {
    final builder = inputFieldsBox!.query();
    return builder
        .watch(triggerImmediately: triggerImmediately)
        .map((event) => event.find());
  }

  Future<void> removeAllInputFields() async {
    await inputFieldsBox!.removeAllAsync();
  }

  // Products
  void addProduct(ProductObjectBoxModel product) {
    productModelBox!.put(product);
  }

  Future<void> addProductAsync(ProductObjectBoxModel product) async {
    await productModelBox!.putAsync(product);
  }

  List<int> addProductList(List<ProductObjectBoxModel> products) {
    return productModelBox!.putMany(products);
  }

  List<ProductObjectBoxModel> getProducts() {
    return productModelBox!.getAll();
  }

  Future<List<ProductObjectBoxModel>> getProductsAsync() async {
    return await productModelBox!.getAllAsync();
  }

  Stream<List<ProductObjectBoxModel>> getProductStream(
      {bool triggerImmediately = false}) {
    final builder = productModelBox!.query();
    return builder
        .watch(triggerImmediately: triggerImmediately)
        .map((event) => event.find());
  }

  Future<void> removeAllProducts() async {
    await productModelBox!.removeAllAsync();
  }

  // Stock
  void addStock(StockObjectBoxModel stock) {
    stockModelBox!.put(stock);
  }

  Future<void> addStockAsync(StockObjectBoxModel stock) async {
    await stockModelBox!.putAsync(stock);
  }

  List<int> addStockList(List<StockObjectBoxModel> stocks) {
    return stockModelBox!.putMany(stocks);
  }

  List<StockObjectBoxModel> getStocks() {
    return stockModelBox!.getAll();
  }

  Future<List<StockObjectBoxModel>> getStocksAsync() async {
    return await stockModelBox!.getAllAsync();
  }

  Stream<List<StockObjectBoxModel>> getStockStream(
      {bool triggerImmediately = false}) {
    final builder = stockModelBox!.query();
    return builder
        .watch(triggerImmediately: triggerImmediately)
        .map((event) => event.find());
  }

  Future<void> removeAllStocks() async {
    await stockModelBox!.removeAllAsync();
  }

  // Location History
  Future<void> addLocationHistory(
      StockLocationHistoryObjectBoxModel stock) async {
    await stockLocationHistoryModelBox!.putAsync(stock);
  }

  List<int> addLocationHistoryList(
      List<StockLocationHistoryObjectBoxModel> stocks) {
    return stockLocationHistoryModelBox!.putMany(stocks);
  }

  // Database
  Future<void> clearDatabase() async {
    final file = File(store.directoryPath);
    file.delete(recursive: true);
    store.close();
  }
}
