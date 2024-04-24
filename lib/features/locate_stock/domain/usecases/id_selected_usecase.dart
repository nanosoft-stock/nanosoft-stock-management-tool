import 'package:stock_management_tool/core/usecase/usecase.dart';

class IdSelectedUseCase extends UseCase {
  IdSelectedUseCase();

  @override
  Future call({params}) async {
    int index = params["index"];
    List selectedIds = params["ids"];
    List<Map<String, dynamic>> locatedItems = params["located items"];
    locatedItems[index]["selected ids"] = selectedIds;
    // locatedItems[index]["selected ids"] = selectedIds.map((e) => [
    //       {
    //         "id": "",
    //         "type": "",
    //         "warehouse": [
    //           {
    //             "warehouse location id": "",
    //           }
    //         ],
    //         "container": [
    //           {
    //             "warehouse location id": "",
    //             "container id": "",
    //             "container history": [
    //               {
    //                 "date": "",
    //                 "movement type": "",
    //                 "user": "",
    //                 "new location": {
    //                   "warehouse location id": "",
    //                 },
    //               },
    //             ],
    //           }
    //         ],
    //         "item": [
    //           {
    //             "warehouse location id": "",
    //             "container id": "",
    //             "item id": "",
    //             "item history": [
    //               {
    //                 "date": "",
    //                 "movement type": "",
    //                 "user": "",
    //                 "new location": {
    //                   "warehouse location id": "",
    //                   "container id": "",
    //                 },
    //               }
    //             ]
    //           }
    //         ],
    //       },
    //     ]);

    return locatedItems;
  }
}
