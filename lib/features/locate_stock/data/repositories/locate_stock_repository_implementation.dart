import 'package:stock_management_tool/features/locate_stock/domain/repositories/locate_stock_repository.dart';
import 'package:stock_management_tool/injection_container.dart';
import 'package:stock_management_tool/services/firestore.dart';

class LocateStockRepositoryImplementation implements LocateStockRepository {
  @override
  Future<List> getIds({required String searchBy}) async {
    List allLocations = await _fetchAllLocations();

    if (searchBy == "Warehouse Location Id") {
      return allLocations.firstWhere(
          (element) => element.keys.contains("warehouse_locations"))["warehouse_locations"];
    } else if (searchBy == "Container Id") {
      return allLocations
          .firstWhere((element) => element.keys.contains("containers"))["containers"];
    } else if (searchBy == "Item Id") {
      return allLocations.firstWhere((element) => element.keys.contains("items"))["items"];
    }

    return [];
  }

  @override
  Future<List> getIdSpecificData({required String searchBy, required List selectedIds}) async {
    List selectedIdDetails = [];

    for (var id in selectedIds) {
      if (searchBy == "Warehouse Location Id") {
        selectedIdDetails.add(await _fetchWarehouseLocationDetails(id: id));
      } else if (searchBy == "Container Id") {
        selectedIdDetails.add(await _fetchContainerDetails(id: id));
      } else if (searchBy == "Item Id") {
        selectedIdDetails.add(await _fetchItemDetails(id: id));
      }
    }

    print(selectedIdDetails);

    return selectedIdDetails;
  }

  Future<List> _fetchAllLocations() async {
    List allLocations =
        await sl.get<Firestore>().getDocuments(path: "all_locations", includeDocRef: true);

    allLocations = allLocations.map((element) {
      Map map = {};

      for (var key in element.keys) {
        if (key == "docRef") {
          map["docRef"] = element["docRef"]["stringValue"];
        } else {
          map[key] = element[key]["arrayValue"]["values"].map((ele) => ele["stringValue"]).toList();
        }
      }

      return map;
    }).toList();

    return allLocations;
  }

  Future<Map> _fetchWarehouseLocationDetails({required String id}) async {
    Map data = {};

    data["id"] = id;

    List list = await sl.get<Firestore>().filterQuery(
      path: "",
      query: {
        "from": [
          {
            "collectionId": "stock_data",
            "allDescendants": false,
          }
        ],
        "where": {
          "fieldFilter": {
            "field": {
              "fieldPath": "`warehouse location`",
            },
            "op": "EQUAL",
            "value": {
              "stringValue": id,
            },
          },
        },
      },
    );

    data["containers"] = list.map((e) => e["container id"]["stringValue"]).toList()
      ..sort((a, b) => a.compareTo(b));
    data["items"] = list
        .map((e) => {
              "item id": e["item id"]["stringValue"],
              "container id": e["container id"]["stringValue"]
            })
        .toList()
      ..sort((a, b) => a["item id"].compareTo(b["item id"]));

    return data;
  }

  Future<Map> _fetchContainerDetails({required String id}) async {
    Map data = {};

    data["id"] = id;

    List list = await sl.get<Firestore>().filterQuery(
      path: "",
      query: {
        "from": [
          {
            "collectionId": "stock_data",
            "allDescendants": false,
          }
        ],
        "where": {
          "fieldFilter": {
            "field": {
              "fieldPath": "`container id`",
            },
            "op": "EQUAL",
            "value": {
              "stringValue": id,
            },
          },
        },
      },
    );

    data["warehouse_location_id"] = list.first["warehouse location"]["stringValue"];
    data["items"] = list.map((e) => e["item id"]["stringValue"]).toList()
      ..sort((a, b) => a.compareTo(b));

    return data;
  }

  Future<Map> _fetchItemDetails({required String id}) async {
    Map data = {};

    data["id"] = id;

    List list = await sl.get<Firestore>().filterQuery(
      path: "",
      query: {
        "from": [
          {
            "collectionId": "stock_data",
            "allDescendants": false,
          }
        ],
        "where": {
          "fieldFilter": {
            "field": {
              "fieldPath": "`item id`",
            },
            "op": "EQUAL",
            "value": {
              "stringValue": id,
            },
          },
        },
      },
    );

    data["warehouse_location_id"] = list.first["warehouse location"]["stringValue"];
    data["container_id"] = list.first["container id"]["stringValue"];

    return data;
  }

// Future<void> _addAllLocations() async {
//   warehouseLocations = warehouseLocations.map((e) => {"stringValue": e.toUpperCase()}).toList();
//
//   await sl.get<Firestore>().createDocument(
//     path: "all_locations",
//     data: {
//       "warehouse_locations": {
//         "arrayValue": {
//           "values": [warehouseLocations],
//         }
//       }
//     },
//   );
//
//   containers = containers.map((e) => {"stringValue": e.toUpperCase()}).toList();
//
//   await sl.get<Firestore>().createDocument(
//     path: "all_locations",
//     data: {
//       "containers": {
//         "arrayValue": {
//           "values": [containers],
//         }
//       }
//     },
//   );
//
//   items = items.map((e) => {"stringValue": e.toUpperCase()}).toList();
//
//   await sl.get<Firestore>().createDocument(
//     path: "all_locations",
//     data: {
//       "items": {
//         "arrayValue": {
//           "values": [items],
//         }
//       }
//     },
//   );
// }
//
// List items = ["901290", "901291", "901292", "901293", "901294", "901295"];
// List containers = ["BOX 4290", "BOX 4291", "BOX 4292", "BOX 4293", "BOX 4294", "BOX 4295"];
// List warehouseLocations = [
//   "A01R01L1A",
//   "A01R01L1B",
//   "A01R01L2A",
//   "A01R01L2B",
//   "A01R01L3A",
//   "A01R01L3B",
//   "A01R01L4A",
//   "A01R01L4B",
//   "A01R02L1A",
//   "A01R02L1B",
//   "A01R02L2B",
//   "A01R02L3A",
//   "A01R02L3B",
//   "A01R02L4A",
//   "A01R02L4B",
//   "A01R03L1A",
//   "A01R03L1B",
//   "A01R03L2B",
//   "A01R03L3A",
//   "A01R03L3B",
//   "A01R03L4A",
//   "A01R03L4B",
//   "A01R04L1A",
//   "A01R04L1B",
//   "A01R04L2B",
//   "A01R04L3A",
//   "A01R04L3B",
//   "A01R04L4A",
//   "A01R04L4B",
//   "A01R05L1A",
//   "A01R05L1B",
//   "A01R05L2B",
//   "A01R05L3A",
//   "A01R05L3B",
//   "A01R05L4A",
//   "A01R05L4B",
//   "A01R06L1A",
//   "A01R06L1B",
//   "A01R06L2B",
//   "A01R06L3A",
//   "A01R06L3B",
//   "A01R06L4A",
//   "A01R06L4B",
//   "A01R07L1A",
//   "A01R07L1B",
//   "A01R07L2B",
//   "A01R07L3A",
//   "A01R07L3B",
//   "A01R07L4A",
//   "A01R07L4B",
//   "A01R08L1A",
//   "A01R08L1B",
//   "A01R08L2B",
//   "A01R08L3A",
//   "A01R08L3B",
//   "A01R08L4A",
//   "A01R08L4B",
//   "A01R09L1A",
//   "A01R09L1B",
//   "A01R09L2B",
//   "A01R09L3A",
//   "A01R09L3B",
//   "A01R09L4A",
//   "A01R09L4B",
//   "A01R10L1A",
//   "A01R10L1B",
//   "A01R10L2B",
//   "A01R10L3A",
//   "A01R10L3B",
//   "A01R10L4A",
//   "A01R10L4B",
//   "A01R11L1A",
//   "A01R11L1B",
//   "A01R11L2B",
//   "A01R11L3A",
//   "A01R11L3B",
//   "A01R11L4A",
//   "A01R11L4B",
//   "A02R01L1A",
//   "A02R01L1B",
//   "A02R01L2A",
//   "A02R01L2B",
//   "A02R01L3A",
//   "A02R01L3B",
//   "A02R01L4A",
//   "A02R01L4B",
//   "A02R02L1A",
//   "A02R02L1B",
//   "A02R02L2B",
//   "A02R02L3A",
//   "A02R02L3B",
//   "A02R02L4A",
//   "A02R02L4B",
//   "A02R03L1A",
//   "A02R03L1B",
//   "A02R03L2B",
//   "A02R03L3A",
//   "A02R03L3B",
//   "A02R03L4A",
//   "A02R03L4B",
//   "A02R04L1A",
//   "A02R04L1B",
//   "A02R04L2B",
//   "A02R04L3A",
//   "A02R04L3B",
//   "A02R04L4A",
//   "A02R04L4B",
//   "A02R05L1A",
//   "A02R05L1B",
//   "A02R05L2B",
//   "A02R05L3A",
//   "A02R05L3B",
//   "A02R05L4A",
//   "A02R05L4B",
//   "A02R06L1A",
//   "A02R06L1B",
//   "A02R06L2B",
//   "A02R06L3A",
//   "A02R06L3B",
//   "A02R06L4A",
//   "A02R06L4B",
//   "A02R07L1A",
//   "A02R07L1B",
//   "A02R07L2B",
//   "A02R07L3A",
//   "A02R07L3B",
//   "A02R07L4A",
//   "A02R07L4B",
//   "A02R08L1A",
//   "A02R08L1B",
//   "A02R08L2B",
//   "A02R08L3A",
//   "A02R08L3B",
//   "A02R08L4A",
//   "A02R08L4B",
//   "A02R09L1A",
//   "A02R09L1B",
//   "A02R09L2B",
//   "A02R09L3A",
//   "A02R09L3B",
//   "A02R09L4A",
//   "A02R09L4B",
//   "A02R10L1A",
//   "A02R10L1B",
//   "A02R10L2B",
//   "A02R10L3A",
//   "A02R10L3B",
//   "A02R10L4A",
//   "A02R10L4B",
//   "A03R01L1B",
//   "A03R01L2A",
//   "A03R01L2B",
//   "A03R01L3A",
//   "A03R01L3B",
//   "A03R01L4A",
//   "A03R01L4B",
//   "A03R02L1A",
//   "A03R02L1B",
//   "A03R02L2B",
//   "A03R02L3A",
//   "A03R02L3B",
//   "A03R02L4A",
//   "A03R02L4B",
//   "A03R03L1A",
//   "A03R03L1B",
//   "A03R03L2B",
//   "A03R03L3A",
//   "A03R03L3B",
//   "A03R03L4A",
//   "A03R03L4B",
//   "A03R04L1A",
//   "A03R04L1B",
//   "A03R04L2B",
//   "A03R04L3A",
//   "A03R04L3B",
//   "A03R04L4A",
//   "A03R04L4B",
//   "A03R05L1A",
//   "A03R05L1B",
//   "A03R05L2B",
//   "A03R05L3A",
//   "A03R05L3B",
//   "A03R05L4A",
//   "A03R05L4B",
//   "A03R06L1A",
//   "A03R06L1B",
//   "A03R06L2B",
//   "A03R06L3A",
//   "A03R06L3B",
//   "A03R06L4A",
//   "A03R06L4B",
//   "A03R07L1A",
//   "A03R07L1B",
//   "A03R07L2B",
//   "A03R07L3A",
//   "A03R07L3B",
//   "A03R07L4A",
//   "A03R07L4B",
//   "A03R08L1A",
//   "A03R08L1B",
//   "A03R08L2B",
//   "A03R08L3A",
//   "A03R08L3B",
//   "A03R08L4A",
//   "A03R08L4B",
//   "A03R09L1A",
//   "A03R09L1B",
//   "A03R09L2B",
//   "A03R09L3A",
//   "A03R09L3B",
//   "A03R09L4A",
//   "A03R09L4B",
//   "A03R10L1A",
//   "A03R10L1B",
//   "A03R10L2B",
//   "A03R10L3A",
//   "A03R10L3B",
//   "A03R10L4A",
//   "A03R10L4B",
//   "DS01L1",
//   "DS01L2",
//   "DS01L3",
//   "DS01L4",
//   "DS01L5",
//   "DS01L6",
//   "MBENCH01",
//   "MBENCH02",
//   "MBENCH03",
//   "MBENCH04",
//   "MBENCH05",
//   "MBENCH06",
//   "MDESK01",
//   "MDESK02",
//   "MS01L1",
//   "MS01L2",
//   "MS01L3",
//   "MS01L4",
//   "MS01L5",
//   "MS02L1",
//   "MS02L2",
//   "MS02L3",
//   "MS02L4",
//   "MS02L5",
//   "MS03L1",
//   "MS03L2",
//   "MS03L3",
//   "MS03L4",
//   "MS03L5",
//   "MS04L1",
//   "MS04L2",
//   "MS04L3",
//   "MS04L4",
//   "MS04L5",
//   "MS05L1",
//   "MS05L2",
//   "MS05L3",
//   "MS05L4",
//   "MS05L5",
//   "MS06L1",
//   "MS06L2",
//   "MS06L3",
//   "MS06L4",
//   "MS06L5",
//   "MS07L1",
//   "MS07L2",
//   "MS07L3",
//   "MS07L4",
//   "MS07L5",
//   "MS08L1",
//   "MS08L2",
//   "MS08L3",
//   "MS08L4",
//   "MS08L5",
//   "MS09L1",
//   "MS09L2",
//   "MS09L3",
//   "MS09L4",
//   "MS09L5",
//   "MS10L1",
//   "MS10L2",
//   "MS10L3",
//   "MS10L4",
//   "MS10L5",
//   "MS11L1",
//   "MS11L2",
//   "MS11L3",
//   "MS11L4",
//   "MS11L5",
//   "MS12L1",
//   "MS12L2",
//   "MS12L3",
//   "MS12L4",
//   "MS12L5",
//   "MS13L1",
//   "MS13L2",
//   "MS13L3",
//   "MS13L4",
//   "MS13L5",
//   "MS14L1",
//   "MS14L2",
//   "MS14L3",
//   "MS14L4",
//   "MS14L5",
//   "OFDESK01",
//   "OFDESK02",
//   "OFDESK03",
//   "OFDESK04",
//   "OS01L1",
//   "OS01L2",
//   "OS01L3",
//   "OS01L4",
//   "OS01L5",
//   "PACKBENCH01",
//   "PACKBENCH02",
//   "RCY MISC",
//   "RCY PARTS",
//   "RCY TFT",
//   "RCYBATTERIES",
//   "SC01L1",
//   "SC01L2",
//   "SC01L3",
//   "SC01L4",
//   "SC01L5",
//   "SC02L1",
//   "SC02L2",
//   "SC02L3",
//   "SC02L4",
//   "SC02L5",
//   "SC03L1",
//   "SC03L2",
//   "SC03L3",
//   "SC03L4",
//   "SC03L5",
//   "SC04L1",
//   "SC04L2",
//   "SC04L3",
//   "SC04L4",
//   "SC04L5",
//   "SC05L1",
//   "SC05L2",
//   "SC05L3",
//   "SC05L4",
//   "SC05L5",
//   "SC06L1",
//   "SC06L2",
//   "SC06L3",
//   "SC06L4",
//   "SC06L5",
//   "SF01L1",
//   "SF01L2",
//   "SF01L3",
//   "SF01L4",
//   "SF01L5",
//   "SHUTTER 1",
//   "SHUTTER 2",
//   "TBENCH01",
//   "TBENCH02",
//   "TBENCH03",
//   "TBENCH04",
//   "TBENCH05",
//   "TBENCH06",
//   "TBENCH07",
//   "TBENCH08",
//   "TDESK01",
//   "TDESK02",
//   "TECHBAY01",
//   "TECHBAY02",
//   "TECHBAY03",
//   "TECHBAY04",
//   "TECHBAY05",
//   "TECHBAY06",
//   "TS01L1",
//   "TS01L2",
//   "TS01L3",
//   "TS01L4",
//   "TS01L5",
//   "TS02L1",
//   "TS02L2",
//   "TS02L3",
//   "TS02L4",
//   "TS02L5",
//   "TS03L1",
//   "TS03L2",
//   "TS03L3",
//   "TS03L4",
//   "TS03L5",
//   "TS04L1",
//   "TS04L2",
//   "TS04L3",
//   "TS04L4",
//   "TS04L5",
//   "TS05L1",
//   "TS05L2",
//   "TS05L3",
//   "TS05L4",
//   "TS05L5",
//   "TS06L1",
//   "TS06L2",
//   "TS06L3",
//   "TS06L4",
//   "TS06L5",
//   "WH1 CHECKING",
//   "WH1 HOLD",
//   "WH1 STAGED",
//   "WH2 CHECKING",
//   "WH2 HOLD",
//   "WH2 STAGED"
// ];
}
