import 'package:stock_management_tool/core/local_database/models/category_field_hive_model.dart';
import 'package:stock_management_tool/core/local_database/models/category_hive_model.dart';
import 'package:stock_management_tool/core/local_database/models/container_hive_model.dart';
import 'package:stock_management_tool/core/local_database/local_database.dart';
import 'package:stock_management_tool/core/local_database/models/item_hive_model.dart';
import 'package:stock_management_tool/core/local_database/models/stock_hive_model.dart';
import 'package:stock_management_tool/core/local_database/models/user_hive_model.dart';
import 'package:stock_management_tool/core/local_database/models/warehouse_location_hive_model.dart';
import 'package:stock_management_tool/core/resources/data_state.dart';
import 'package:stock_management_tool/core/services/network_services.dart';
import 'package:stock_management_tool/core/services/socket_io_services.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class LocalDatabaseRepository {
  LocalDatabaseRepository(
    this._localDB,
    this._networkServices,
    this._socketIoServices,
  );

  final LocalDatabase _localDB;
  final NetworkServices _networkServices;
  final SocketIoServices _socketIoServices;

  late IO.Socket socket;

  Future<void> fetchData() async {
    await _fetchCategories();
    await _fetchWarehouseLocations();
    await _fetchContainers();
    await _fetchItems();
    await _fetchCategoryFields();
    await _fetchStocks();
  }

  Future<void> fetchUser(String email) async {
    DataState result = await _networkServices.get("users/$email");
    if (result is DataSuccess) {
      Map<String, dynamic> user = result.data[0];

      await _localDB.addUser(UserHiveModel.fromMap(user));
    } else {
      throw result.error!;
    }
  }

  Future<void> _fetchCategories() async {
    DataState result = await _networkServices.get("categories");

    if (result is DataSuccess) {
      List categories = result.data;

      List<CategoryHiveModel> models = [];
      for (Map<String, dynamic> category in categories) {
        models.add(CategoryHiveModel.fromMap(category));
      }

      await _localDB.addCategories(models);
    } else {
      throw result.error!;
    }
  }

  Future<void> _fetchWarehouseLocations() async {
    DataState result = await _networkServices.get("warehouse-locations");

    if (result is DataSuccess) {
      List warehouseLocations = result.data;

      List<WarehouseLocationHiveModel> models = [];
      for (Map<String, dynamic> warehouseLocation in warehouseLocations) {
        models.add(WarehouseLocationHiveModel.fromMap(warehouseLocation));
      }

      await _localDB.addWarehouseLocations(models);
    } else {
      throw result.error!;
    }
  }

  Future<void> _fetchContainers() async {
    DataState result = await _networkServices.get("containers");

    if (result is DataSuccess) {
      List containers = result.data;

      List<ContainerHiveModel> models = [];
      for (Map<String, dynamic> container in containers) {
        models.add(ContainerHiveModel.fromMap(container));
      }

      await _localDB.addContainers(models);
    } else {
      throw result.error!;
    }
  }

  Future<void> _fetchItems() async {
    DataState result = await _networkServices.get("items");

    if (result is DataSuccess) {
      List items = result.data;

      List<ItemHiveModel> models = [];
      for (Map<String, dynamic> item in items) {
        models.add(ItemHiveModel.fromMap(item));
      }

      await _localDB.addItems(models);
    } else {
      throw result.error!;
    }
  }

  Future<void> _fetchCategoryFields() async {
    DataState result = await _networkServices.get("fields");

    if (result is DataSuccess) {
      List categoryFields = result.data;

      List<CategoryFieldHiveModel> models = [];
      for (Map<String, dynamic> field in categoryFields) {
        models.add(CategoryFieldHiveModel.fromMap(field));
      }

      await _localDB.addCategoryFields(models);
    } else {
      throw result.error!;
    }
  }

  Future<void> _fetchStocks() async {
    DataState result = await _networkServices.get("stocks");

    if (result is DataSuccess) {
      List stocks = result.data;

      List<StockHiveModel> models = [];
      for (Map<String, dynamic> stock in stocks) {
        models.add(StockHiveModel.fromMap(stock));
      }

      await _localDB.addStocks(models);
    } else {
      throw result.error!;
    }
  }

  Future<void> listenToCloudDatabaseChange() async {
    socket = _socketIoServices.getSocket;

    socket.on('database', _databaseListener);
  }

  void _databaseListener(doc) async {
    print(doc);

    if (doc != null) {
      switch (doc["table"]) {
        case "users":
          await _userListener(doc);

          break;
        case "categories":
          await _categoryListener(doc);

          break;
        case "warehouse_locations":
          await _warehouseLocationListener(doc);

          break;
        case "containers":
          await _containerListener(doc);

          break;
        case "items":
          await _itemListener(doc);

          break;
        case "fields":
          await _categoryFieldListener(doc);

          break;
        case "stocks":
          await _stockListener(doc);

          break;
      }
    }
  }

  Future<void> _userListener(doc) async {
    switch (doc["operation"]) {
      case "INSERT":
        break;
      case "UPDATE":
        if (_localDB.user.userUUID == doc["data"]["user_uuid"]) {
          await _localDB.updateUserAt(
            0,
            UserHiveModel.fromMap(doc["data"]),
          );
        }

        break;
      case "DELETE":
        if (_localDB.user.userUUID == doc["data"]["user_uuid"]) {
          await _localDB.deleteUserAt(0);
        }

        break;
    }
  }

  Future<void> _categoryListener(doc) async {
    switch (doc["operation"]) {
      case "INSERT":
        await _localDB.addCategory(CategoryHiveModel.fromMap(doc["data"]));

        break;
      case "UPDATE":
        break;
      case "DELETE":
        List categories = _localDB.categories.toList();
        int index =
            categories.indexWhere((e) => e.category == doc["data"]["category"]);

        if (index != -1) {
          await _localDB.deleteCategoryAt(index);
        }

        break;
    }
  }

  Future<void> _warehouseLocationListener(doc) async {
    switch (doc["operation"]) {
      case "INSERT":
        await _localDB.addWarehouseLocation(
            WarehouseLocationHiveModel.fromMap(doc["data"]));

        break;
      case "UPDATE":
        break;
      case "DELETE":
        List warehouseLocations = _localDB.warehouseLocations.toList();
        int index = warehouseLocations.indexWhere((e) =>
            e.warehouseLocationId == doc["data"]["warehouse_location_id"]);

        if (index != -1) {
          await _localDB.deleteWarehouseLocationAt(index);
        }

        break;
    }
  }

  Future<void> _containerListener(doc) async {
    switch (doc["operation"]) {
      case "INSERT":
        await _localDB.addContainer(ContainerHiveModel.fromMap(doc["data"]));

        break;
      case "UPDATE":
        List containers = _localDB.containers.toList();
        int index = containers
            .indexWhere((e) => e.containerId == doc["data"]["container_id"]);

        if (index != -1) {
          await _localDB.updateContainerAt(
              index, ContainerHiveModel.fromMap(doc["data"]));
        }

        break;
      case "DELETE":
        List containers = _localDB.containers.toList();
        int index = containers
            .indexWhere((e) => e.containerId == doc["data"]["container_id"]);

        if (index != -1) {
          await _localDB.deleteContainerAt(index);
        }

        break;
    }
  }

  Future<void> _itemListener(doc) async {
    switch (doc["operation"]) {
      case "INSERT":
        await _localDB.addItem(ItemHiveModel.fromMap(doc["data"]));

        break;
      case "UPDATE":
        List items = _localDB.items.toList();
        int index = items.indexWhere((e) => e.itemId == doc["data"]["item_id"]);

        if (index != -1) {
          await _localDB.updateItemAt(
              index, ItemHiveModel.fromMap(doc["data"]));
        }

        break;
      case "DELETE":
        List items = _localDB.items.toList();
        int index = items.indexWhere((e) => e.itemId == doc["data"]["item_id"]);

        if (index != -1) {
          await _localDB.deleteItemAt(index);
        }

        break;
    }
  }

  Future<void> _categoryFieldListener(doc) async {
    switch (doc["operation"]) {
      case "INSERT":
        await _localDB
            .addCategoryField(CategoryFieldHiveModel.fromMap(doc["data"]));

        break;
      case "UPDATE":
        List categoryFields = _localDB.categoryFields.toList();
        int index = categoryFields
            .indexWhere((e) => e.fieldUUID == doc["data"]["field_uuid"]);

        if (index != -1) {
          await _localDB.updateCategoryFieldAt(
              index, CategoryFieldHiveModel.fromMap(doc["data"]));
        }

        break;
      case "DELETE":
        List categoryFields = _localDB.categoryFields.toList();
        int index = categoryFields
            .indexWhere((e) => e.fieldUUID == doc["data"]["field_uuid"]);

        if (index != -1) {
          await _localDB.deleteCategoryFieldAt(index);
        }

        break;
    }
  }

  Future<void> _stockListener(doc) async {
    switch (doc["operation"]) {
      case "INSERT":
        DataState result =
            await _networkServices.get("stocks/${doc["data"]["item_id"]}");

        if (result is DataSuccess) {
          Map<String, dynamic> stock = result.data[0];

          await _localDB.addStock(StockHiveModel.fromMap(stock));
        } else {
          throw result.error!;
        }

        break;
      case "UPDATE":
        List stocks = _localDB.stocks.toList();
        int index =
            stocks.indexWhere((e) => e.itemId == doc["data"]["item_id"]);

        if (index != -1) {
          DataState result =
              await _networkServices.get("stocks/${doc["data"]["item_id"]}");

          if (result is DataSuccess) {
            Map<String, dynamic> stock = result.data[0];

            await _localDB.updateStockAt(index, StockHiveModel.fromMap(stock));
          } else {
            throw result.error!;
          }
        }

        break;
      case "DELETE":
        List stocks = _localDB.stocks.toList();
        int index =
            stocks.indexWhere((e) => e.itemId == doc["data"]["item_id"]);

        if (index != -1) {
          await _localDB.deleteStockAt(index);
        }

        break;
    }
  }
}
