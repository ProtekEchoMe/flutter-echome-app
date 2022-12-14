import 'dart:convert';

import 'package:dismissible_expanded_list/model/entry.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:echo_me_mobile/data/network/apis/asset_return/asset_return_api.dart';
import 'package:echo_me_mobile/models/asset_return/return_order_detail.dart';
import 'package:echo_me_mobile/models/equipment_data/equipment_data.dart';
import 'package:echo_me_mobile/stores/error/error_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:echo_me_mobile/utils/extension/sortExtension.dart';

import 'package:echo_me_mobile/data/repository.dart';


import 'package:mobx/mobx.dart';

part 'asset_return_scan_expand_store.g.dart';

class AssetReturnScanExpandStore = _AssetReturnScanExpandStore with _$AssetReturnScanExpandStore;

abstract class _AssetReturnScanExpandStore with Store {
  final String TAG = "_AssetReturnScanExpandStore";

  final ErrorStore errorStore = ErrorStore();

  _AssetReturnScanExpandStore(this.repository);

  final Repository repository;

  String? rtnNum;

  List? orderLineMapList;

  Map rfidCodeMapper = {};
  List<String> fetchedContainerRfidList = [];
  Map itemCodeRfidMapper = {};
  Map containerCodeRfidMapper = {};

  Map itemCodeCheckedRfidMapper = {};
  Map containerItemCodeCheckedRfidMapper = {};

  Map itemRfidStatus = {}; // checked, scanned, out-of-bound
  Map containerRfidStatus = {};

  // Main Data Source
  List<ReturnOrderDetail>? orderLineDTOList = [];

  @observable
  Map orderLineDTOMap = ObservableMap();

  // Map orderLineDTOMap = {};

  List<String> scannedRFIDList = [];

  @observable
  int totalCheckedSKU = 0;

  @observable
  int totalSKU = 0;

  @observable
  int totalCheckedQty = 0;

  @observable
  int addedQty = 0;

  @observable
  int outOfListQty = 0;

  @observable
  int totalQty = 0;

  @observable
  int addedContainer = 0;

  @observable
  int totalContainer = 0;

  @observable
  String activeContainer = "";

  @observable
  bool needUpdateUI = false;

  @observable
  bool needUpdateItem = false;

  @observable
  ObservableSet<String> itemRfidDataSet = ObservableSet();

  @observable
  ObservableSet<String> equipmentRfidDataSet = ObservableSet();

  // @observable
  // ObservableList<EquipmentData> equipmentData = ObservableList();

  @observable
  ObservableMap<String, EquipmentData> equipmentData = ObservableMap();

  @observable
  bool isFetchingEquData = false;

  @observable
  ObservableSet<String> checkedItem = ObservableSet();

  @observable
  ObservableList<EquipmentData> chosenEquipmentData = ObservableList();

  @observable
  ObservableList<String> dialogDisplayRFIDList = ObservableList();

  @observable
  bool isFetching = false;

  // void reset(){
  //   rtnNum = "";
  //   rfidCodeMapper = {};
  //   codeRfidMapper = {};
  //   itemRfidStatus = {};
  //   codeRfidMapper = {};
  //   orderLineDTOList = [];
  //   orderLineDTOMap = {};
  //   scannedRFIDList = [];
  // }

  @action
  void removeRFID(String containerRFID, String itemCode, {String rfid = "", int i = 0}){
    this.orderLineDTOMap[containerRFID]
        .orderLineItemsMap[itemCode].rfid.removeAt(i);
  }

  void updateRFIDStatusMap() {
    if (orderLineDTOList == null || orderLineDTOList!.isEmpty) {
      throw Exception("orderLineMapList shall not be null or empty");
    }
    orderLineDTOList!.forEach((orderLineMap) {
      if (orderLineMap.containerCode == "Not Yet Scan") {
        orderLineMap.orderLineItems?.forEach((orderLineItem) {
          List<String>? rfidList = orderLineItem.rfid;
          rfidList?.forEach((rfid) {
            itemRfidStatus[rfid] = "unScanned";
          });
        });
      } else {
        orderLineMap.orderLineItems?.forEach((orderLineItem) {
          List<String>? rfidList = orderLineItem.rfid;
          rfidList?.forEach((rfid) {
            itemRfidStatus[rfid] = "committed";
          });
        });
      }
    });
  }

  void createContainer(
      String orderNum, String containerCode, String containerRfid) {
    // orderLineMap[containerCode] = {
    //   "orderNum": orderNum,
    //   "containerCode": containerCode,
    //   "RFID": rfid,
    //   "status": "un-commited",
    //   "modifiedDate": DateTime.now().millisecondsSinceEpoch,
    //   "orderLineItems": []
    // };

    ReturnOrderDetail orderLineDTO = ReturnOrderDetail(
      orderNum: orderNum,
      containerCode: containerCode,
      rfid: containerRfid,
      modifiedDate: DateTime.now().millisecondsSinceEpoch,
      status: "un-commited",
      orderLineItems: [],
    );

    if (!orderLineDTOMap.containsKey(containerRfid)) {
      orderLineDTOList?.add(orderLineDTO);
    }

    orderLineDTOMap[containerRfid] = orderLineDTO;
  }

  void addRfidIntocontainerItemCodeCheckedRfidMapper(
      String containerRfid, String itemCode, String rfid) {
    if (!containerItemCodeCheckedRfidMapper.containsKey(containerRfid)) {
      print("aR1");
      containerItemCodeCheckedRfidMapper[containerRfid] = {};
    }
    Map itemCodeCheckedRfidMapper =
    containerItemCodeCheckedRfidMapper[containerRfid];
    if (!itemCodeCheckedRfidMapper.containsKey(itemCode)) {
      print("aR2");
      itemCodeCheckedRfidMapper[itemCode] = [];
      this.itemCodeCheckedRfidMapper[itemCode] = [];
    }
    print("aR3");
    itemCodeCheckedRfidMapper[itemCode].add(rfid);
    this.itemCodeCheckedRfidMapper[itemCode].add(rfid);
  }

  void addItemIntoContainer(String containerRfid, String rfid) {
    //using key as unit identifier to avoid duplicate records are added into the list[orderLineDTOMap]

    //check the status of rfid
    // if it is unchecked, checkinNum += 1, and add it into containerCode
    String unScannedStr = "unScanned";
    String unScannedStrMapper = "Not Yet Scan";
    print("a1");
    if (itemRfidStatus.containsKey(rfid)) {
      print("a2");
      String rfidStatus = itemRfidStatus[rfid];

      if (rfidStatus != unScannedStr) {
        print("a3");
        return;
      }
      print("a4");

      String itemCode = rfidCodeMapper[rfid];
      OrderLineItems orderLineItems =
      orderLineDTOMap[unScannedStrMapper].orderLineItemsMap[itemCode];

      addRfidIntocontainerItemCodeCheckedRfidMapper(
          containerRfid, itemCode, rfid);
      addRfidIntocontainerItemCodeCheckedRfidMapper(
          unScannedStrMapper, itemCode, rfid);

      print("a5");
      orderLineItems.checkedinQty = orderLineItems.checkedinQty! + 1;
      this.totalCheckedQty += 1;
      this.addedQty += 1;
      // TODO -- revise the object movement
      if (!orderLineDTOMap[containerRfid]
          .orderLineItemsMap
          .containsKey(itemCode)) {
        print("a6");
        OrderLineItems newOrderLineItems = OrderLineItems.clone(orderLineItems);
        newOrderLineItems.checkedinQty = 1;
        newOrderLineItems.rfid = [rfid];
        orderLineDTOMap[containerRfid].orderLineItems.add(newOrderLineItems);
        orderLineDTOMap[containerRfid].orderLineItemsMap[itemCode] =
            newOrderLineItems;
      } else {
        // orderLineDTOMap[containerRfid].orderLineItems.add(orderLineItems);
        print("a7");
        OrderLineItems targetContainerOrderLineItems =
        orderLineDTOMap[containerRfid].orderLineItemsMap[itemCode];
        targetContainerOrderLineItems.checkedinQty =
        (targetContainerOrderLineItems.checkedinQty! + 1);
        targetContainerOrderLineItems.rfid?.add(rfid);
      }

      itemRfidStatus[rfid] = "Scanned";
    } else {
      print("a8");
      containerRfid = "Out of List";
      String itemCode = rfid;
      OrderLineItems orderLineItems = OrderLineItems(
          productName: rfid,
          rfid: [rfid],
          status: "temp",
          itemCode: rfid,
          productCode: rfid,
          checkedinQty: 1,
          totalQty: 1);

      if (!orderLineDTOMap.containsKey(containerRfid)) {
        print("a9");
        createContainer("", containerRfid, containerRfid);
      }
      if (!orderLineDTOMap[containerRfid]
          .orderLineItemsMap
          .containsKey(itemCode)) {
        print("a10");
        orderLineDTOMap[containerRfid].orderLineItems.add(orderLineItems);
        orderLineDTOMap[containerRfid].orderLineItemsMap[itemCode] =
            orderLineItems;
      }
      print("a11");
      addRfidIntocontainerItemCodeCheckedRfidMapper(
          containerRfid, itemCode, rfid);
      this.outOfListQty += 1;
    }

    int now = DateTime.now().millisecondsSinceEpoch;

    for (final orderLine in orderLineDTOList!) {
      if (orderLine.rfid == containerRfid) {
        orderLine.modifiedDate = now;
        orderLine.status = "checking";
        break;
      }
    }
    orderLineDTOMap[containerRfid].modifiedDate = now;
    orderLineDTOMap[containerRfid].status = "checking";
  }

  // void addScannedRFID(String containerRfid, List rfidList) {
  //   rfidList.forEach((rfid) {
  //     if (rfidCodeMapper.containsKey(rfid)) {
  //       String itemCode = rfidCodeMapper[rfid];
  //       Map targetMap = orderLineDTOMap[containerRfid].orderLineItemsMap;
  //       OrderLineItems targetProductMap = targetMap[itemCode];
  //       targetProductMap.checkedinQty = targetProductMap.checkedinQty! + 1;
  //     } else {
  //       if (!orderLineDTOMap.containsKey("Out of List")) {
  //         createContainer(rtnNum!, "Out of List", "Out of List");
  //       }
  //       addItemIntoContainer("Out of List", rfid);
  //     }
  //   });
  // }

  void turnOrderLineIntoMapper() {
    if (orderLineDTOList == null || orderLineDTOList!.isEmpty) {
      throw Exception("orderLineMapList shall not be null or empty");
    }

    orderLineDTOList?.forEach((boxOrderLine) {
      List<OrderLineItems>? orderLineItems =
      boxOrderLine.orderLineItems?.cast<OrderLineItems>();
      String? containerRFID = boxOrderLine.rfid;
      String? containerCode = boxOrderLine.containerCode;
      if (!rfidCodeMapper.containsKey(containerRFID)) {
        rfidCodeMapper[containerRFID] = containerCode;
      }
      if (!containerCodeRfidMapper.containsKey(containerCode)) {
        containerCodeRfidMapper[containerCode] = [containerRFID];
      }
      orderLineItems?.forEach((orderLineMap) {
        List<String>? rfidList = orderLineMap.rfid;
        String? productCode = orderLineMap.productCode;
        String? itemCode = orderLineMap.itemCode;
        if (!itemCodeRfidMapper.containsKey(itemCode)) {
          itemCodeRfidMapper[itemCode] = [];
        }
        rfidList?.forEach((rfid) {
          rfidCodeMapper[rfid] = itemCode;
          itemCodeRfidMapper[itemCode].add(rfid);
        });
      });
    });
    print("");
  }

  Map getContainerBadget(List orderLineDTOList){
    Map containerRFIDCountMap = {};
    orderLineDTOMap.forEach((containerRFID, orderLineDTO) {
      Map orderLineItemsMap = orderLineDTO.orderLineItemsMap as Map;
      if (!containerRFIDCountMap.containsKey(containerRFID)){
        containerRFIDCountMap[containerRFID] = {"totalCheckedItem":0, "totalItem": 0};
      }
      orderLineItemsMap.forEach((itemCode, orderLineMap) {
        int? checkedinQty = orderLineMap.checkedinQty;
        int? totalQty = orderLineMap.totalQty;
        String? itemCode = orderLineMap.itemCode;
        if(itemCodeRfidMapper.containsKey(itemCode)){
          totalQty = itemCodeRfidMapper[itemCode].length;
        }

        containerRFIDCountMap[containerRFID]["totalCheckedItem"] += checkedinQty;
        containerRFIDCountMap[containerRFID]["totalItem"] += totalQty;

      });
    });

    return containerRFIDCountMap;
  }

  dynamic turnOrderLineDtoMapIntoWidget() async {
    List<ExpandableListItem> outputExpandableListWidget =
    <ExpandableListItem>[];
    // List orderLineMapList = await getOrderLineMap();
    // orderLineMapList.sort((m2, m1) {
    //   var r = m1["modifiedDate"].compareTo(m2["modifiedDate"]);
    //   if (r != 0) return r;
    //   return m1["modifiedDate"].compareTo(m2["modifiedDate"]);
    // });
    // orderLineMapList.sort((b, a) => (b['modifiedDate']).compareTo(a['modifiedDate']));
    // orderLineMapList.sort((b, a) => (b['modifiedDate']).compareTo(a['modifiedDate']));

    Map containerRFIDCountMap = getContainerBadget(orderLineDTOList!);

    orderLineDTOList?.sortOrderLineBy(["modifiedDate", "status"], [1, 1]);
    orderLineDTOList?.forEach((orderLineContainerMap) {
      String? containerRFID = orderLineContainerMap.rfid;
      String? containerCode = orderLineContainerMap.containerCode;
      ReturnOrderDetail orderLineDTO = orderLineDTOMap[containerRFID];
      int? modifiedDateTimeStamp = orderLineDTO.modifiedDate;
      String datetimeStr =
      DateTime.fromMillisecondsSinceEpoch(modifiedDateTimeStamp!)
          .toString();
      // String datetimeStr = DateTime.fromMillisecondsSinceEpoch(createdTimeStamp).toString();
      datetimeStr = datetimeStr.substring(0, datetimeStr.length - 4);
      // String? containerStatus = orderLineDTO.status;
      Map orderLineItemsMap = orderLineDTO.orderLineItemsMap as Map;

      String? containerBadgetText = "";
      if(containerRFID != "Not Yet Scan"){
        containerBadgetText = "{${containerRFIDCountMap[containerRFID]["totalCheckedItem"]}/ ${containerRFIDCountMap[containerRFID]["totalItem"]}}  (${orderLineItemsMap.keys.length}sku)";
      }else{
        containerBadgetText = "{${containerRFIDCountMap[containerRFID]["totalCheckedItem"]}/${containerRFIDCountMap[containerRFID]["totalItem"]}}  (${orderLineItemsMap.keys.length}sku)" ;
      }

      // String? containerRFID = orderLineDTO.rfid;

      ExpandableListItem containerExpandableList = ExpandableListItem(
          id: containerRFID ?? containerCode,
          title: containerCode ?? containerRFID,
          subTitle: "Last update: ${datetimeStr}",
          selected: false,
          badgeText: containerBadgetText,
          badgeColor: Color(0xFFFFE082),
          // badgeColor: Colors.orange,
          badgeTextColor: Color(0xFF000000),
          children: <ExpandableListItem>[]);
      orderLineItemsMap.forEach((itemCode, orderLineMap) {
        String? productName = orderLineMap.productName;
        String? productCode = orderLineMap.productCode;
        String? itemCode = orderLineMap.itemCode;
        int? checkedinQty = orderLineMap.checkedinQty;
        int? totalQty = orderLineMap.totalQty;
        String? itemStatus = orderLineMap.status;
        List rfidList = orderLineMap.rfid;
        String badgeText = "$checkedinQty";
        if (containerRFID != "Out of List") {
          Map itemCodeCheckedRfidMapper =
          containerItemCodeCheckedRfidMapper[containerRFID];
          if (itemCodeCheckedRfidMapper[itemCode].length > 0) {
            badgeText += "(+" +
                "${containerItemCodeCheckedRfidMapper[containerRFID][itemCode].length}" +
                ")";
          }
        }

        if (containerCode != "Not Yet Scan" &&
            itemCodeRfidMapper.containsKey(itemCode)) {
          badgeText += "/${itemCodeRfidMapper[itemCode].length}";
        } else {
          badgeText += "/${totalQty}";
        }

        ExpandableListItem orderLineExpandableListItem = ExpandableListItem(
            id: itemCode,
            title: productName,
            subTitle: "PCode: $productCode, ICode: $itemCode",
            selected: false,
            badgeText: badgeText,
            badgeColor: itemCodeRfidMapper.containsKey(itemCode)
                ? ((checkedinQty! >= itemCodeRfidMapper[itemCode].length!)
                ? Color(0xFF44b468)
                : Colors.red[200])
                : Color(0xFF44b468),
            badgeTextColor: itemCodeRfidMapper.containsKey(itemCode)
                ? ((checkedinQty! >= itemCodeRfidMapper[itemCode].length)
                ? Color(0xFFFFFFFF)
                : Color(0xFF000000))
                : Color(0xFFFFFFFF),
            children: <ExpandableListItem>[]);
        containerExpandableList.addChild(orderLineExpandableListItem);
      });
      outputExpandableListWidget.add(containerExpandableList);
    });
    print("orderLineMap");
    return outputExpandableListWidget;
  }

  void updateDashBoard() {
    if (orderLineDTOList == null || orderLineDTOList!.isEmpty) {
      throw Exception("orderLine shall not null or empty");
    }

    totalQty = 0;
    totalCheckedQty = 0;
    totalCheckedSKU = 0;
    addedQty = 0;
    totalContainer = orderLineDTOList?.length ?? 0;
    if (totalContainer != 0) {
      totalContainer -= 1; // # cancel Not Yet Scan Container
    }
    totalSKU = 0;

    orderLineDTOList?.forEach((containerInfo) {
      List<OrderLineItems>? orderLineItems = containerInfo.orderLineItems;
      totalSKU += orderLineItems!.length;
      orderLineItems.forEach((orderLineItem) {
        int? checkedinQty = orderLineItem.checkedinQty;
        int? totalQty = orderLineItem.totalQty;
        String? itemCode = orderLineItem.itemCode;
        totalCheckedQty += checkedinQty!;
        this.totalQty += totalQty!;
        if (itemCodeCheckedRfidMapper[itemCode].length >=
            itemCodeRfidMapper[itemCode].length) {
          totalCheckedSKU += 1;
        }
      });
    });
  }

  void updateNotYetScanRFID() {
    orderLineDTOList?.forEach((orderLineInfo) {
      if (orderLineInfo.containerCode == "Not Yet Scan") {
        orderLineInfo.rfid = orderLineInfo.containerCode;
      }
    });
  }

  void updateOrderLineDTOMap() {
    if (orderLineDTOList == null || orderLineDTOList!.isEmpty) {
      throw Exception("orderLine shall not null or empty");
    }

    orderLineDTOList?.forEach((orderLineInfo) {
      String? containerRfid = orderLineInfo.rfid;
      orderLineDTOMap[containerRfid] = orderLineInfo;
      orderLineInfo.orderLineItems?.forEach((orderLineItem) {
        String? itemCode = orderLineItem.itemCode;
        orderLineInfo.addOrderLineItemsMapItem(itemCode!, orderLineItem);
      });
    });
  }

  void updateContainerItemCodeCheckedRfidMapper() {
    if (orderLineDTOList == null || orderLineDTOList!.isEmpty) {
      throw Exception("orderLine shall not null or empty");
    }

    orderLineDTOList?.forEach((orderLineInfo) {
      String? containerRfid = orderLineInfo.rfid;
      String? containerCode = orderLineInfo.containerCode;
      if (!containerItemCodeCheckedRfidMapper.containsKey(containerRfid)) {
        containerItemCodeCheckedRfidMapper[containerRfid] = {};
      }
      orderLineDTOMap[containerRfid] = orderLineInfo;
      orderLineInfo.orderLineItems?.forEach((orderLineItem) {
        String? itemCode = orderLineItem.itemCode;
        List<String>? itemRfid = orderLineItem.rfid;
        if (!itemCodeCheckedRfidMapper.containsKey(itemCode)) {
          itemCodeCheckedRfidMapper[itemCode] = [];
        }

        if ("Not Yet Scan" != containerCode) {
          itemCodeCheckedRfidMapper[itemCode].addAll(itemRfid);
        }

        if (!containerItemCodeCheckedRfidMapper[containerRfid]
            .containsKey(itemCode)) {
          containerItemCodeCheckedRfidMapper[containerRfid][itemCode] = [];
        }
      });
    });
  }

  Future<void> loadOrderLineJson() async {
    // String jsonStr = await __readFile('assets/orderLine.json');
    String jsonStr = await __readFile('assets/mockorderLine2.json');
    orderLineMapList = json.decode(jsonStr);
    turnOrderLineIntoMapper();
    updateRFIDStatusMap();
    orderLineDTOList = orderLineMapList
        ?.map((e) => ReturnOrderDetail.fromJson(e))
        .toList();
    // orderLineDTOMap = {};
    orderLineDTOList?.forEach((orderLineInfo) {
      String? containerCode = orderLineInfo.containerCode;
      orderLineDTOMap[containerCode] = orderLineInfo;
      orderLineInfo.orderLineItems?.forEach((orderLineItem) {
        String? itemCode = orderLineItem.itemCode;
        orderLineInfo.addOrderLineItemsMapItem(itemCode!, orderLineItem);
      });
    });
    print("");
    // turnOrderLineIntoMapper();
    // turnOrderLineListIntoOrderLineMap(orderLineMapList!);
  }

  Future<void> fetchOrderDetail(String rtnNum, int site) async {
    // String jsonStr = await __readFile('assets/orderLine.json');
    try {
      // rtnNum = "GDC0980203";
      reset();
      this.rtnNum = rtnNum;
      // AssetReturnOrderDetailResponse result = await repository.getAssetReturnOrderDetail(rtnNum: "GDC0980203", site: 2);
      AssetReturnOrderDetailResponse result = await repository
          .getAssetReturnOrderDetail(rtnNum: rtnNum, site: site);
      // String jsonStr = await __readFile('assets/mockorderLine2.json');
      orderLineDTOList = result.itemList;
      int containerNum = result.rowNumber;

      // update corrsponding data based on fetched result;

      updateNotYetScanRFID();
      updateOrderLineDTOMap();
      updateContainerItemCodeCheckedRfidMapper();
      turnOrderLineIntoMapper();
      updateRFIDStatusMap();

      updateDashBoard();

      // orderLineMapList = json.decode(jsonStr);
      // orderLineDTOList =
      // orderLineMapList?.map((e) => ReturnOrderDetail.fromJson(e)).toList();

      print("");
    }catch(e,s){
      errorStore.setErrorMessage(e.toString());
      print(s);
    }
    // turnOrderLineIntoMapper();
    // turnOrderLineListIntoOrderLineMap(orderLineMapList!);
  }

  Future<String> __readFile(String fileName) async {
    final String response = await rootBundle.loadString(fileName);
    // final data = await json.decode(response);
    // print(data);
    return response;
  }

  @action
  void reset() {
    itemRfidDataSet.clear();
    equipmentRfidDataSet.clear();
    equipmentData.clear();
    isFetchingEquData = false;
    checkedItem.clear();
    chosenEquipmentData.clear();
    EasyDebounce.cancel('validateContainerRfid');
    rtnNum = "";
    rfidCodeMapper = {};
    itemRfidStatus = {};
    itemCodeRfidMapper = {};
    containerCodeRfidMapper = {};
    orderLineDTOList = [];
    orderLineDTOMap = {};
    scannedRFIDList = [];
    activeContainer = "";
    outOfListQty = 0;

    orderLineMapList;
    rfidCodeMapper = {};
    fetchedContainerRfidList = [];
    itemCodeRfidMapper = {};
    containerCodeRfidMapper = {};
    itemCodeCheckedRfidMapper = {};
    containerItemCodeCheckedRfidMapper = {};
    itemRfidStatus = {}; // checked, scanned, out-of-bound
    containerRfidStatus = {};
    // Main Data Source
    orderLineDTOList = [];
    orderLineDTOMap = {};
    scannedRFIDList = [];
    totalCheckedSKU = 0;
    totalSKU = 0;
    totalCheckedQty = 0;
    addedQty = 0;
    outOfListQty = 0;
    totalQty = 0;
    addedContainer = 0;
    totalContainer = 0;
    activeContainer = "";
    needUpdateUI = false;
  }

  @action
  void resetContainer() {
    equipmentRfidDataSet.clear();
    equipmentData.clear();
    isFetchingEquData = false;
    chosenEquipmentData.clear();
    EasyDebounce.cancel('validateContainerRfid');
  }

  // @action
  // Future<void> validateEquipmentRfid() async {
  //   if (equipmentRfidDataSet.isEmpty) {
  //     return;
  //   }
  //   isFetchingEquData = true;
  //   try {
  //     if (equipmentRfidDataSet.isNotEmpty) {
  //       List<String> list2 = equipmentRfidDataSet.toList();
  //       // List<String> list2 =
  //       // equipmentRfidDataSet.map((e) => AscToText.getString(e)).toList();
  //
  //       List<String> fetchContainerRfidList = [];
  //       equipmentRfidDataSet.forEach((containerRfid) {
  //         if (!fetchedContainerRfidList.contains(containerRfid)) {
  //           fetchContainerRfidList.add(containerRfid);
  //         }
  //       });
  //
  //       var result =
  //           await repository.getEquipmentDetail(rfid: fetchContainerRfidList);
  //       var resList = result["itemList"] as List;
  //       List<EquipmentData> equList = [];
  //       Set<String> addedContainerAssetCodeSet = Set();
  //
  //       // Check for different containerAssetCode --> Remark same number of cartoon
  //       // have same containerAssetCode and containerCode
  //       Set<String?> containerAssetCodeSet = addedContainerAssetCodeSet =
  //           chosenEquipmentData
  //               .map((element) => element.containerAssetCode ?? "")
  //               .toSet(); // update Set;
  //
  //       Map containerRfidFetchResultMap = {};
  //       resList.forEach((e) {
  //         EquipmentData data = EquipmentData.fromJson(e);
  //         containerRfidFetchResultMap[data.rfid] = data;
  //       });
  //
  //       for (var e in resList) {
  //         EquipmentData data = EquipmentData.fromJson(e);
  //         equList.add(data);
  //         fetchedContainerRfidList.add(data.rfid!);
  //
  //         if (data.rfid != null &&
  //             !addedContainerAssetCodeSet.contains(data.rfid!)) {
  //           if (activeContainer == data.rfid) {
  //             chosenEquipmentData.add(data);
  //           }
  //
  //           addedContainerAssetCodeSet.add(data.rfid!);
  //           if (!rfidCodeMapper.containsKey(data.rfid)) {
  //             createContainer("", data.containerCode!, data.rfid!);
  //             containerCodeRfidMapper[data.containerCode] = [data.rfid];
  //             rfidCodeMapper[data.rfid] = data.containerCode;
  //           }
  //         }
  //
  //         containerAssetCodeSet.add(data.containerCode);
  //       }
  //       equipmentData = ObservableList.of(equList);
  //       if (chosenEquipmentData.length > 1 &&
  //           containerAssetCodeSet.length > 1) {
  //         // throw Exception("More than one container code found");
  //         print("More than one container code found");
  //       }
  //
  //       List<String> outOfListItemList = [];
  //       List<String> onTheListItemList = [];
  //
  //       itemRfidDataSet.forEach((rfid) {
  //         if (itemRfidStatus.containsKey(rfid)) {
  //           onTheListItemList.add(rfid); // containerRfid, rfid
  //         } else {
  //           outOfListItemList.add(rfid);
  //         }
  //       });
  //
  //       outOfListItemList.forEach((rfid) {
  //         addItemIntoContainer("Out of List", rfid); // containerRfid, rfid
  //       });
  //
  //       onTheListItemList.forEach((rfid) {
  //         addItemIntoContainer(
  //             chosenEquipmentData[0].rfid!, rfid); // containerRfid, rfid
  //       });
  //     }
  //   } catch (e, s) {
  //     errorStore.setErrorMessage(e.toString());
  //   } finally {
  //     // isFetchingEquData = false;
  //     needUpdateUI = true;
  //     print("finish validate equipment --> needUpdateUI: $needUpdateUI");
  //   }
  // }

  @action
  Future<void> validateContainerRfid() async {
    if (equipmentRfidDataSet.isEmpty) {
      return;
    }
    isFetchingEquData = true;
    try {
      if (equipmentRfidDataSet.isNotEmpty) {
        List<String> list2 = equipmentRfidDataSet.toList();
        // List<String> list2 =
        // equipmentRfidDataSet.map((e) => AscToText.getString(e)).toList();

        List<String> fetchContainerRfidList = [];
        equipmentRfidDataSet.forEach((containerRfid) {
          if (!fetchedContainerRfidList.contains(containerRfid)) {
            fetchContainerRfidList.add(containerRfid);
          }
        });

        var result =
        await repository.getEquipmentDetail(rfid: fetchContainerRfidList);
        var resList = result["itemList"] as List;
        List<EquipmentData> equList = [];
        Set<String> addedContainerAssetCodeSet = Set();

        // Check for different containerAssetCode --> Remark same number of cartoon
        // have same containerAssetCode and containerCode
        Set<String?> containerAssetCodeSet = addedContainerAssetCodeSet =
            chosenEquipmentData
                .map((element) => element.containerAssetCode ?? "")
                .toSet(); // update Set;

        Map containerRfidFetchResultMap = {};
        resList.forEach((e) {
          EquipmentData data = EquipmentData.fromJson(e);
          containerRfidFetchResultMap[data.rfid] = data;
        });

        for (var e in resList) {
          EquipmentData data = EquipmentData.fromJson(e);
          equList.add(data);
          fetchedContainerRfidList.add(data.rfid!);

          if (data.rfid != null &&
              !addedContainerAssetCodeSet.contains(data.rfid!)) {
            if (activeContainer == data.rfid) {
              chosenEquipmentData.add(data);
            }

            addedContainerAssetCodeSet.add(data.rfid!);
            if (!rfidCodeMapper.containsKey(data.rfid)) {
              createContainer("", data.containerCode!, data.rfid!);
              containerCodeRfidMapper[data.containerCode] = [data.rfid];
              rfidCodeMapper[data.rfid] = data.containerCode;
            }
          }

          containerAssetCodeSet.add(data.containerCode);
        }


        equList.forEach((containerData) {
          String containerRFID = containerData.rfid!;
          if (!equipmentData.containsKey(containerRFID)){
            equipmentData[containerRFID] = containerData;
          }
        });

        if (chosenEquipmentData.length > 1 &&
            containerAssetCodeSet.length > 1) {
          // throw Exception("More than one container code found");
          print("More than one container code found");
        }

      }
    } catch (e, s) {
      errorStore.setErrorMessage(e.toString());
    } finally {
      // isFetchingEquData = false;
      needUpdateItem = true;
      needUpdateUI = true;
      print("finish validate equipment --> needUpdateUI: $needUpdateUI");
    }
  }

  @action
  Future<void> validateItemRfid() async {
    if (itemRfidDataSet.isEmpty) {
      return;
    }
    isFetchingEquData = true;
    try {
      if (itemRfidDataSet.isNotEmpty) {


        List<String> outOfListItemList = [];
        List<String> onTheListItemList = [];

        itemRfidDataSet.forEach((rfid) {
          if (itemRfidStatus.containsKey(rfid)) {
            onTheListItemList.add(rfid); // containerRfid, rfid
          } else {
            outOfListItemList.add(rfid);
          }
        });

        outOfListItemList.forEach((rfid) {
          addItemIntoContainer("Out of List", rfid); // containerRfid, rfid
        });
        //
        // onTheListItemList.forEach((rfid) {
        //   addItemIntoContainer(
        //       chosenEquipmentData[0].rfid!, rfid); // containerRfid, rfid
        // });

        onTheListItemList.forEach((rfid) {
          addItemIntoContainer(equipmentData[activeContainer]?.rfid ?? "", rfid); // containerRfid, rfid
        });
      }
    } catch (e, s) {
      errorStore.setErrorMessage(e.toString());
    } finally {
      // isFetchingEquData = false;
      needUpdateUI = true;
      print("finish validate item --> needUpdateUI: $needUpdateUI");
    }
  }

  void addEquipmentIntoOrderLine(String containerRfid) {
    createContainer("", containerRfid, containerRfid);
  }

  void addEquipment(List<String> equList) {

    equList.forEach((equ) {
      if (!equipmentRfidDataSet.contains(equ)) {
        addedContainer += 1;
        totalContainer += 1;
      }
      equipmentRfidDataSet.add(equ);
    });
    equipmentRfidDataSet.addAll(equList);
  }

  void addItem(List<String> itemList) {
    itemRfidDataSet.addAll(itemList);
  }

  void takeOutEquipment(List<String> equList) {
    if (activeContainer == "") {
      activeContainer = equList[0];
    }
    equipmentRfidDataSet.addAll(equList);
  }

  void takeOutItem(List<String> itemList) {
    itemRfidDataSet.addAll(itemList);
  }

  @action
  void updateDataSet(
      {List<String> itemList = const [], List<String> equList = const []}) {
    var initIndexEqu = equipmentRfidDataSet.length;
    var initIndexItem = itemRfidDataSet.length;

    addEquipment(equList);
    addItem(itemList);

    var finalIndexItem = itemRfidDataSet.length;
    var finalIndexEqu = equipmentRfidDataSet.length;
    // itemRfidDataSet.addAll(itemList);
    // equipmentRfidDataSet.addAll(equList);
    // var finalIndex = equipmentRfidDataSet.length;
    if ((initIndexEqu != finalIndexEqu) || (initIndexItem != finalIndexItem)) {
      isFetchingEquData = true;
      EasyDebounce.debounce(
          'validateContainerRfid', const Duration(milliseconds: 500), () {
        // validateEquipmentRfid();
        validateContainerRfid().then((containerMap){
          // selection the activeContainer
        });

        // validateItemRfid();
        // validateContainerRfid().then((value) {
        // });

      });
      // validateEquipmentRfid();
    }
    print(itemRfidDataSet);
  }

  @action
  Future<void> complete({String rtnNum = ""}) async {
    try {
      isFetching = true;
      await repository.completeArRegistration(rtnNum: rtnNum);
    } catch (e, s) {
      errorStore.setErrorMessage(e.toString());
    } finally {
      isFetching = false;
    }
  }


  @action
  Future<void> registerContainer(
      {List<String> rfid = const [],
        String rtnNum = "",
        bool throwError = false}) async {
    try {
      isFetching = true;
      await repository.registerArContainer(rfid: rfid, rtnNum: rtnNum);
    } catch (e, s) {
      if (throwError == true) {
        rethrow;
      } else {
        errorStore.setErrorMessage(e.toString());
      }
    } finally {
      isFetching = false;
    }
  }

  //TODO:: [bugs]just using containerAssetCode got problem to verify --> multi containers
  @action
  Future<void> registerItem(
      {String rtnNum = "",
        String containerAssetCode = "",
        List<String> itemRfid = const [],
        bool throwError = false}) async {
    try {
      isFetching = true;
      await repository.registerArItem(
          rtnNum: rtnNum,
          containerAssetCode: containerAssetCode,
          itemRfid: itemRfid);
    } catch (e, s) {
      print(s);
      if (throwError == true) {
        rethrow;
      } else {
        errorStore.setErrorMessage(e.toString());
      }
    } finally {
      isFetching = false;
    }
  }

  @action
  Future<void> removeContainerItemRfid(
      String containerRfid, String rfid) async {
    String notYetScanContainerStr = "Not Yet Scan";
    this.itemRfidDataSet.removeWhere((element) => element == rfid);
    // if (!rfidCodeMapper.containsKey(rfid)){
    //   return;
    // }
    String itemCode = rfidCodeMapper[rfid];
    print("1");
    if (itemRfidStatus.containsKey(rfid)) {
      itemRfidStatus[rfid] = "un-committed"; // 1
      print("1");
      //2
      if (containerItemCodeCheckedRfidMapper.containsKey(containerRfid) &&
          containerItemCodeCheckedRfidMapper[containerRfid]
              .containsKey(itemCode)) {
        print("2");
        List targetContainerRfidList =
        containerItemCodeCheckedRfidMapper[containerRfid][itemCode];
        targetContainerRfidList.removeWhere((element) => element == rfid);
      }
      if (containerItemCodeCheckedRfidMapper
          .containsKey(notYetScanContainerStr) &&
          containerItemCodeCheckedRfidMapper[notYetScanContainerStr]
              .containsKey(itemCode)) {
        print("3");
        List notYetScanContainerRfidList =
        containerItemCodeCheckedRfidMapper[notYetScanContainerStr]
        [itemCode];
        notYetScanContainerRfidList.removeWhere((element) => element == rfid);
      }

      //3
      if (orderLineDTOMap.containsKey(containerRfid) &&
          orderLineDTOMap[containerRfid]
              .orderLineItemsMap
              .containsKey(itemCode)) {
        print("4");
        OrderLineItems targetOrderIineItem =
        orderLineDTOMap[containerRfid].orderLineItemsMap[itemCode];
        targetOrderIineItem.checkedinQty =
            targetOrderIineItem.checkedinQty! - 1;
        targetOrderIineItem.rfid!.removeWhere((element) => element == rfid);


        // orderLineDTOList?.removeWhere((orderLine) => orderLine.rfid == rfid);
        orderLineDTOList?.forEach((orderLineContainer) {
          if (orderLineContainer.rfid == containerRfid){
            orderLineContainer.orderLineItems?.forEach((orderLineItems) {
              if (orderLineItems.itemCode == itemCode){
                orderLineItems.rfid?.removeWhere((rfidIter) => rfidIter == rfid);
              }
            });
          }
        });


      }

      if (orderLineDTOMap.containsKey(notYetScanContainerStr) &&
          orderLineDTOMap[notYetScanContainerStr]
              .orderLineItemsMap
              .containsKey(itemCode)) {
        print("5");
        OrderLineItems targetOrderIineItem =
        orderLineDTOMap[notYetScanContainerStr].orderLineItemsMap[itemCode];
        targetOrderIineItem.checkedinQty =
            targetOrderIineItem.checkedinQty! - 1;
        targetOrderIineItem.rfid!.removeWhere((element) => element == rfid);
      }

      if (rfidCodeMapper.containsKey(rfid)){
        print("6");
        this.totalCheckedQty -= 1;
        this.addedQty -= 1;
      }

      // if (orderLineDTOMap[containerRfid].orderLineItemsMap.isEmpty){
      //   orderLineDTOMap.removeWhere((containerRfid, _) => containerRfid == containerRfid);
      // }


      // orderLineDTOMap

    } else {
      // out of list
      //2
      print("7");
      itemCode = rfid;
      String outOfListStr = "Out of List";
      if (containerItemCodeCheckedRfidMapper.containsKey(outOfListStr) &&
          containerItemCodeCheckedRfidMapper[outOfListStr]
              .containsKey(itemCode)) {
        print("8");
        // List targetContainerRfidList = containerItemCodeCheckedRfidMapper[containerRfid][itemCode];
        List targetContainerRfidList = containerItemCodeCheckedRfidMapper[outOfListStr][itemCode];
        targetContainerRfidList.removeWhere((element) => element == rfid);
        if(targetContainerRfidList.isEmpty){
          containerItemCodeCheckedRfidMapper[outOfListStr].remove(itemCode);
        }
      }

      if (orderLineDTOMap.containsKey(outOfListStr) &&
          orderLineDTOMap[outOfListStr]
              .orderLineItemsMap
              .containsKey(itemCode)) {
        print("9");
        // OrderLineItems targetOrderIineItem = orderLineDTOMap[containerRfid].orderLineItemsMap[itemCode];
        OrderLineItems targetOrderIineItem = orderLineDTOMap[outOfListStr].orderLineItemsMap[itemCode];
        targetOrderIineItem.checkedinQty =
            targetOrderIineItem.checkedinQty! - 1;
        targetOrderIineItem.rfid!.removeWhere((element) => element == rfid);
        if (targetOrderIineItem.rfid!.isEmpty){
          orderLineDTOMap[outOfListStr].orderLineItemsMap.remove(itemCode);
        }

      }

      this.outOfListQty -= 1;
      print("10");
    }
    print(itemRfidDataSet);

  }


  @action
  Future<void> removeContainerItem(
      String containerRfid, String itemCode) async {
    // List targetContainerRfidList = containerItemCodeCheckedRfidMapper[containerRfid][itemCode];
    // List copyList = List.from(targetContainerRfidList);
    // copyList.forEach((rfid) {removeContainerItemRfid(containerRfid, rfid);});

    if (containerItemCodeCheckedRfidMapper.containsKey(containerRfid) &&
        containerItemCodeCheckedRfidMapper[containerRfid]
            .containsKey(itemCode)) {
      print("ci1");
      List targetContainerRfidList =
      containerItemCodeCheckedRfidMapper[containerRfid][itemCode];
      List copyList = List.from(targetContainerRfidList);
      copyList.forEach((rfid) {
        removeContainerItemRfid(containerRfid, rfid);
      });
    }
  }

  @action
  Future<void> removeContainer(String containerRfid) async {
    print("c1");

    if (containerItemCodeCheckedRfidMapper.containsKey(containerRfid)) {
      List itemCodeList =
      containerItemCodeCheckedRfidMapper[containerRfid].keys.toList();
      List copyList = List.from(itemCodeList);
      copyList.forEach((itemCode) {
        print("c2");
        removeContainerItem(containerRfid, itemCode);
      });
    }

    if(containerRfid != "Out of List"){
      print("c3");
      containerItemCodeCheckedRfidMapper.removeWhere((containerIter, _) => containerIter == containerRfid);
      orderLineDTOMap.removeWhere((containerIter, _) => containerIter == containerRfid);
    }


    this.equipmentRfidDataSet.removeWhere((element) {
      print("c4");
      if (element == containerRfid) {
        print("c5");
        totalContainer -= 1;
        addedContainer -= 1;
        return true;
      }
      print("c6");
      return false;
    });

    String containerCode = rfidCodeMapper[containerRfid];
    if (containerCode != null && containerCode == activeContainer) {
      if (equipmentRfidDataSet.isNotEmpty) {
        print("c7");
        activeContainer = equipmentRfidDataSet.elementAt(0).toString();
      } else {
        activeContainer = "";
      }
    }
  }
}
