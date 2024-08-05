import 'package:hive/hive.dart';
import 'package:stock_management_tool/core/local_database/models/category_field_hive_model.dart';
import 'package:stock_management_tool/core/local_database/models/category_hive_model.dart';
import 'package:stock_management_tool/core/local_database/models/container_hive_model.dart';
import 'package:stock_management_tool/core/local_database/models/item_hive_model.dart';
import 'package:stock_management_tool/core/local_database/models/stock_hive_model.dart';
import 'package:stock_management_tool/core/local_database/models/user_hive_model.dart';
import 'package:stock_management_tool/core/local_database/models/warehouse_location_hive_model.dart';

class LocalDatabase {
  Box<UserHiveModel>? userModelBox;
  Box<CategoryHiveModel>? categoryModelBox;
  Box<WarehouseLocationHiveModel>? warehouseLocationModelBox;
  Box<ContainerHiveModel>? containerModelBox;
  Box<ItemHiveModel>? itemModelBox;
  Box<CategoryFieldHiveModel>? categoryFieldModelBox;
  Box<StockHiveModel>? stockModelBox;

  Future<void> init() async {
    Hive.registerAdapter(UserHiveModelAdapter());
    Hive.registerAdapter(CategoryHiveModelAdapter());
    Hive.registerAdapter(WarehouseLocationHiveModelAdapter());
    Hive.registerAdapter(ContainerHiveModelAdapter());
    Hive.registerAdapter(ItemHiveModelAdapter());
    Hive.registerAdapter(CategoryFieldHiveModelAdapter());
    Hive.registerAdapter(StockHiveModelAdapter());

    userModelBox = await Hive.openBox<UserHiveModel>('user');
    categoryModelBox = await Hive.openBox<CategoryHiveModel>('category');
    warehouseLocationModelBox =
        await Hive.openBox<WarehouseLocationHiveModel>('warehouse_location');
    containerModelBox = await Hive.openBox<ContainerHiveModel>('container');
    itemModelBox = await Hive.openBox<ItemHiveModel>('item');
    categoryFieldModelBox =
        await Hive.openBox<CategoryFieldHiveModel>('category_field');
    stockModelBox = await Hive.openBox<StockHiveModel>('stock');

    await userModelBox?.clear();
    await categoryModelBox?.clear();
    await warehouseLocationModelBox?.clear();
    await containerModelBox?.clear();
    await itemModelBox?.clear();
    await categoryFieldModelBox?.clear();
    await stockModelBox?.clear();
  }

  // User
  UserHiveModel get user => userModelBox!.values.first;

  Future<void> addUser(UserHiveModel user) async {
    await userModelBox!.add(user);
  }

  Future<void> updateUserAt(int index, UserHiveModel user) async {
    await userModelBox!.putAt(index, user);
  }

  Future<void> deleteUserAt(int index) async {
    await userModelBox!.deleteAt(index);
  }

  Stream<BoxEvent> userStream() => userModelBox!.watch();

  // Category
  Iterable<CategoryHiveModel> get categories => categoryModelBox!.values;

  Future<void> addCategory(CategoryHiveModel category) async {
    await categoryModelBox!.add(category);
  }

  Future<void> addCategories(List<CategoryHiveModel> categories) async {
    await categoryModelBox!.addAll(categories);
  }

  Future<void> updateCategoryAt(int index, CategoryHiveModel category) async {
    await categoryModelBox!.putAt(index, category);
  }

  Future<void> deleteCategoryAt(int index) async {
    await categoryModelBox!.deleteAt(index);
  }

  Stream<BoxEvent> categoryStream() => categoryModelBox!.watch();

  // Warehouse Location
  Iterable<WarehouseLocationHiveModel> get warehouseLocations =>
      warehouseLocationModelBox!.values;

  Future<void> addWarehouseLocation(
      WarehouseLocationHiveModel warehouseLocation) async {
    await warehouseLocationModelBox!.add(warehouseLocation);
  }

  Future<void> addWarehouseLocations(
      List<WarehouseLocationHiveModel> warehouseLocations) async {
    await warehouseLocationModelBox!.addAll(warehouseLocations);
  }

  Future<void> updateWarehouseLocationAt(
      int index, WarehouseLocationHiveModel warehouseLocation) async {
    await warehouseLocationModelBox!.putAt(index, warehouseLocation);
  }

  Future<void> deleteWarehouseLocationAt(int index) async {
    await warehouseLocationModelBox!.deleteAt(index);
  }

  Stream<BoxEvent> warehouseLocationStream() =>
      warehouseLocationModelBox!.watch();

  // Container
  Iterable<ContainerHiveModel> get containers => containerModelBox!.values;

  Future<void> addContainer(ContainerHiveModel container) async {
    await containerModelBox!.add(container);
  }

  Future<void> addContainers(List<ContainerHiveModel> containers) async {
    await containerModelBox!.addAll(containers);
  }

  Future<void> updateContainerAt(
      int index, ContainerHiveModel container) async {
    await containerModelBox!.putAt(index, container);
  }

  Future<void> deleteContainerAt(int index) async {
    await containerModelBox!.deleteAt(index);
  }

  Stream<BoxEvent> containerStream() => containerModelBox!.watch();

  // Item
  Iterable<ItemHiveModel> get items => itemModelBox!.values;

  Future<void> addItem(ItemHiveModel item) async {
    await itemModelBox!.add(item);
  }

  Future<void> addItems(List<ItemHiveModel> items) async {
    await itemModelBox!.addAll(items);
  }

  Future<void> updateItemAt(int index, ItemHiveModel item) async {
    await itemModelBox!.putAt(index, item);
  }

  Future<void> deleteItemAt(int index) async {
    await itemModelBox!.deleteAt(index);
  }

  Stream<BoxEvent> itemStream() => itemModelBox!.watch();

  // Category Field
  Iterable<CategoryFieldHiveModel> get categoryFields =>
      categoryFieldModelBox!.values;

  Future<void> addCategoryField(CategoryFieldHiveModel categoryField) async {
    await categoryFieldModelBox!.add(categoryField);
  }

  Future<void> addCategoryFields(
      List<CategoryFieldHiveModel> categoryFields) async {
    await categoryFieldModelBox!.addAll(categoryFields);
  }

  Future<void> updateCategoryFieldAt(
      int index, CategoryFieldHiveModel categoryField) async {
    await categoryFieldModelBox!.putAt(index, categoryField);
  }

  Future<void> deleteCategoryFieldAt(int index) async {
    await categoryFieldModelBox!.deleteAt(index);
  }

  Stream<BoxEvent> categoryFieldStream() => categoryFieldModelBox!.watch();

  // Stock
  Iterable<StockHiveModel> get stocks => stockModelBox!.values;

  Future<void> addStock(StockHiveModel stock) async {
    await stockModelBox!.add(stock);
  }

  Future<void> addStocks(List<StockHiveModel> stocks) async {
    await stockModelBox!.addAll(stocks);
  }

  Future<void> updateStockAt(int index, StockHiveModel stock) async {
    await stockModelBox!.putAt(index, stock);
  }

  Future<void> deleteStockAt(int index) async {
    await stockModelBox!.deleteAt(index);
  }

  Stream<BoxEvent> stockStream() => stockModelBox!.watch();
}
