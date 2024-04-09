import 'dart:io';

import 'package:stock_management_tool/core/data/local_database/models/category_model.dart';
import 'package:stock_management_tool/core/data/local_database/models/input_fields_model.dart';
import 'package:stock_management_tool/core/data/local_database/models/product_model.dart';
import 'package:stock_management_tool/core/data/local_database/models/stock_location_history_model.dart';
import 'package:stock_management_tool/core/data/local_database/models/stock_model.dart';

import 'objectbox.g.dart';

class ObjectBox {
  ObjectBox();

  late Store store;

  Box<CategoryModel>? categoryModelBox;
  Box<InputFieldsModel>? inputFieldsBox;
  Box<ProductModel>? productModelBox;
  Box<StockModel>? stockModelBox;
  Box<StockLocationHistoryModel>? stockLocationHistoryModelBox;

  Future<void> create() async {
    store = await openStore();

    categoryModelBox = Box<CategoryModel>(store);
    inputFieldsBox = Box<InputFieldsModel>(store);
    productModelBox = Box<ProductModel>(store);
    stockModelBox = Box<StockModel>(store);
    stockLocationHistoryModelBox = Box<StockLocationHistoryModel>(store);
  }

  // Categories
  void addCategory(CategoryModel category) {
    categoryModelBox!.put(category);
  }

  Future<void> addCategoryAsync(CategoryModel category) async {
    await categoryModelBox!.putAsync(category);
  }

  Future<List<int>> addCategoryList(List<CategoryModel> category) async {
    return await categoryModelBox!.putManyAsync(category);
  }

  List<CategoryModel> getCategories() {
    return categoryModelBox!.getAll();
  }

  Future<List<CategoryModel>> getCategoriesAsync() async {
    return await categoryModelBox!.getAllAsync();
  }

  Stream<List<CategoryModel>> getCategoryStream() {
    final builder = categoryModelBox!.query();
    return builder.watch(triggerImmediately: true).map((event) => event.find());
  }

  // Input Fields
  void addInputField(InputFieldsModel field) {
    inputFieldsBox!.put(field);
  }

  Future<void> addInputFieldAsync(InputFieldsModel field) async {
    await inputFieldsBox!.putAsync(field);
  }

  Future<List<int>> addInputFieldList(List<InputFieldsModel> fields) async {
    return await inputFieldsBox!.putManyAsync(fields);
  }

  List<InputFieldsModel> getInputFields() {
    return inputFieldsBox!.getAll();
  }

  Future<List<InputFieldsModel>> getInputFieldsAsync() async {
    return await inputFieldsBox!.getAllAsync();
  }

  Stream<List<InputFieldsModel>> getInputFieldStream() {
    final builder = inputFieldsBox!.query();
    return builder.watch(triggerImmediately: true).map((event) => event.find());
  }

  Future<void> removeAllInputFields() async {
    await inputFieldsBox!.removeAllAsync();
  }

  // Products
  void addProduct(ProductModel product) {
    productModelBox!.put(product);
  }

  Future<void> addProductAsync(ProductModel product) async {
    await productModelBox!.putAsync(product);
  }

  Future<List<int>> addProductList(List<ProductModel> products) async {
    return await productModelBox!.putManyAsync(products);
  }

  List<ProductModel> getProducts() {
    return productModelBox!.getAll();
  }

  Future<List<ProductModel>> getProductsAsync() async {
    return await productModelBox!.getAllAsync();
  }

  Stream<List<ProductModel>> getProductStream() {
    final builder = productModelBox!.query();
    return builder.watch(triggerImmediately: true).map((event) => event.find());
  }

  Future<void> removeAllProducts() async {
    await productModelBox!.removeAllAsync();
  }

  // Stock
  Future<void> addStock(StockModel stock) async {
    await stockModelBox!.putAsync(stock);
  }

  Future<List<int>> addStockList(List<StockModel> stocks) async {
    return await stockModelBox!.putManyAsync(stocks);
  }

  // Location History
  Future<void> addLocationHistory(StockLocationHistoryModel stock) async {
    await stockLocationHistoryModelBox!.putAsync(stock);
  }

  Future<List<int>> addLocationHistoryList(List<StockLocationHistoryModel> stocks) async {
    return await stockLocationHistoryModelBox!.putManyAsync(stocks);
  }

  Future<void> clearDatabase() async {
    final file = File(store.directoryPath);
    file.delete(recursive: true);
    store.close();
  }
}
