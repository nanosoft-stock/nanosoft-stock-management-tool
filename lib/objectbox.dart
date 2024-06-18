import 'dart:io';

import 'package:stock_management_tool/core/data/local_database/models/category_objectbox_model.dart';
import 'package:stock_management_tool/core/data/local_database/models/container_id_objectbox_model.dart';
import 'package:stock_management_tool/core/data/local_database/models/input_fields_objectbox_model.dart';
import 'package:stock_management_tool/core/data/local_database/models/item_id_objectbox_model.dart';
import 'package:stock_management_tool/core/data/local_database/models/product_objectbox_model.dart';
import 'package:stock_management_tool/core/data/local_database/models/stock_location_history_objectbox_model.dart';
import 'package:stock_management_tool/core/data/local_database/models/stock_objectbox_model.dart';
import 'package:stock_management_tool/core/data/local_database/models/warehouse_location_id_objectbox_model.dart';

import 'objectbox.g.dart';

class ObjectBox {
  ObjectBox();

  late Store store;

  Box<CategoryObjectBoxModel>? categoryModelBox;
  Box<InputFieldsObjectBoxModel>? inputFieldsBox;
  Box<ProductObjectBoxModel>? productModelBox;
  Box<StockObjectBoxModel>? stockModelBox;
  Box<ItemIdObjectBoxModel>? itemIdBox;
  Box<ContainerIdObjectBoxModel>? containerIdBox;
  Box<WarehouseLocationIdObjectBoxModel>? warehouseLocationIdBox;
  Box<StockLocationHistoryObjectBoxModel>? stockLocationHistoryModelBox;

  Future<void> create() async {
    store = await openStore();

    categoryModelBox = Box<CategoryObjectBoxModel>(store);
    inputFieldsBox = Box<InputFieldsObjectBoxModel>(store);
    productModelBox = Box<ProductObjectBoxModel>(store);
    stockModelBox = Box<StockObjectBoxModel>(store);
    itemIdBox = Box<ItemIdObjectBoxModel>(store);
    containerIdBox = Box<ContainerIdObjectBoxModel>(store);
    warehouseLocationIdBox = Box<WarehouseLocationIdObjectBoxModel>(store);
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

  void removeInputFieldsList(List<int> ids) async {
    inputFieldsBox!.removeMany(ids);
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

  void removeProductsList(List<int> ids) async {
    productModelBox!.removeMany(ids);
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

  void removeStock(int id) async {
    stockModelBox!.remove(id);
  }

  void removeStockList(List<int> ids) async {
    stockModelBox!.removeMany(ids);
  }

  Future<void> removeAllStocks() async {
    await stockModelBox!.removeAllAsync();
  }

  // Item Id
  void addItemId(ItemIdObjectBoxModel itemId) {
    itemIdBox!.put(itemId);
  }

  Future<void> addItemIdAsync(ItemIdObjectBoxModel itemId) async {
    await itemIdBox!.putAsync(itemId);
  }

  List<int> addItemIdList(List<ItemIdObjectBoxModel> itemIds) {
    return itemIdBox!.putMany(itemIds);
  }

  List<ItemIdObjectBoxModel> getItemIds() {
    return itemIdBox!.getAll();
  }

  Future<List<ItemIdObjectBoxModel>> getItemIdAsync() async {
    return await itemIdBox!.getAllAsync();
  }

  Stream<List<ItemIdObjectBoxModel>> getItemIdStream(
      {bool triggerImmediately = false}) {
    final builder = itemIdBox!.query();
    return builder
        .watch(triggerImmediately: triggerImmediately)
        .map((event) => event.find());
  }

  void removeItem(int id) async {
    itemIdBox!.remove(id);
  }

  Future<void> removeAllItemIds() async {
    await itemIdBox!.removeAllAsync();
  }

  // Container Id
  void addContainerId(ContainerIdObjectBoxModel containerId) {
    containerIdBox!.put(containerId);
  }

  Future<void> addContainerIdAsync(
      ContainerIdObjectBoxModel containerId) async {
    await containerIdBox!.putAsync(containerId);
  }

  List<int> addContainerIdList(List<ContainerIdObjectBoxModel> containerIds) {
    return containerIdBox!.putMany(containerIds);
  }

  List<ContainerIdObjectBoxModel> getContainerIds() {
    return containerIdBox!.getAll();
  }

  Future<List<ContainerIdObjectBoxModel>> getContainerIdAsync() async {
    return await containerIdBox!.getAllAsync();
  }

  Stream<List<ContainerIdObjectBoxModel>> getContainerIdStream(
      {bool triggerImmediately = false}) {
    final builder = containerIdBox!.query();
    return builder
        .watch(triggerImmediately: triggerImmediately)
        .map((event) => event.find());
  }

  void removeContainer(int id) async {
    containerIdBox!.remove(id);
  }

  Future<void> removeAllContainerIds() async {
    await containerIdBox!.removeAllAsync();
  }

  //Warehouse Location Id
  void addWarehouseLocationId(
      WarehouseLocationIdObjectBoxModel warehouseLocationId) {
    warehouseLocationIdBox!.put(warehouseLocationId);
  }

  Future<void> addWarehouseLocationIdAsync(
      WarehouseLocationIdObjectBoxModel warehouseLocationId) async {
    await warehouseLocationIdBox!.putAsync(warehouseLocationId);
  }

  List<int> addWarehouseLocationIdList(
      List<WarehouseLocationIdObjectBoxModel> warehouseLocationIds) {
    return warehouseLocationIdBox!.putMany(warehouseLocationIds);
  }

  List<WarehouseLocationIdObjectBoxModel> getWarehouseLocationIds() {
    return warehouseLocationIdBox!.getAll();
  }

  Future<List<WarehouseLocationIdObjectBoxModel>>
      getWarehouseLocationIdAsync() async {
    return await warehouseLocationIdBox!.getAllAsync();
  }

  Stream<List<WarehouseLocationIdObjectBoxModel>> getWarehouseLocationIdStream(
      {bool triggerImmediately = false}) {
    final builder = warehouseLocationIdBox!.query();
    return builder
        .watch(triggerImmediately: triggerImmediately)
        .map((event) => event.find());
  }

  void removeWarehouseLocation(int id) async {
    warehouseLocationIdBox!.remove(id);
  }

  Future<void> removeAllWarehouseLocationIds() async {
    await warehouseLocationIdBox!.removeAllAsync();
  }

  // Location History
  void addStockLocationHistory(StockLocationHistoryObjectBoxModel history) {
    stockLocationHistoryModelBox!.put(history);
  }

  Future<void> addStockLocationHistoryAsync(
      StockLocationHistoryObjectBoxModel history) async {
    stockLocationHistoryModelBox!.putAsync(history);
  }

  List<int> addStockLocationHistoryList(
      List<StockLocationHistoryObjectBoxModel> histories) {
    return stockLocationHistoryModelBox!.putMany(histories);
  }

  List<StockLocationHistoryObjectBoxModel> getStockLocationHistory() {
    return stockLocationHistoryModelBox!.getAll();
  }

  Future<List<StockLocationHistoryObjectBoxModel>>
      getStockLocationHistoryAsync() async {
    return await stockLocationHistoryModelBox!.getAllAsync();
  }

  Stream<List<StockLocationHistoryObjectBoxModel>>
      getStockLocationHistoryStream({bool triggerImmediately = false}) {
    final builder = stockLocationHistoryModelBox!.query();
    return builder
        .watch(triggerImmediately: triggerImmediately)
        .map((event) => event.find());
  }

  void removeStockLocationHistory(int id) async {
    stockLocationHistoryModelBox!.remove(id);
  }

  void removeStockLocationHistoryList(List<int> ids) async {
    stockLocationHistoryModelBox!.removeMany(ids);
  }

  Future<void> removeAllStockLocationHistory() async {
    await stockLocationHistoryModelBox!.removeAllAsync();
  }

  // Database
  Future<void> clearDatabase() async {
    final file = File(store.directoryPath);
    store.close();
    file.delete(recursive: true);
  }
}
