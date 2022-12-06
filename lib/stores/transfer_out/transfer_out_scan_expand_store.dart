import 'dart:convert';
import 'dart:ffi';

import 'package:dismissible_expanded_list/model/entry.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:echo_me_mobile/data/network/apis/asset_registration/asset_registration_api.dart';
import 'package:echo_me_mobile/data/network/apis/transfer_out/transfer_out_api.dart';
import 'package:echo_me_mobile/models/equipment_data/equipment_data.dart';
import 'package:echo_me_mobile/models/transfer_out/rfid_tag_item.dart';
import 'package:echo_me_mobile/models/transfer_out/transfer_out_order_detail.dart';
import 'package:echo_me_mobile/stores/error/error_store.dart';
import 'package:echo_me_mobile/utils/ascii_to_text.dart';

// import 'package:expandablelist_test/util.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:echo_me_mobile/utils/extension/sortExtension.dart';

import 'package:echo_me_mobile/data/repository.dart';

import 'package:mobx/mobx.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';

part 'transfer_out_scan_expand_store.g.dart';

class TOScanExpandStore = _TOScanExpandStore with _$TOScanExpandStore;

abstract class _TOScanExpandStore with Store {
  final String TAG = "_ARScanExpandStore";

  final ErrorStore errorStore = ErrorStore();

  _TOScanExpandStore(this.repository);

  final Repository repository;

  String? toNum;

  List? orderLineMapList;

  Map rfidCodeMapper = {};
  List<String> fetchedContainerRfidList = [];
  Map itemCodeRfidMapper = {};
  Map containerCodeRfidMapper = {};

  Map itemCodeCheckedRfidMapper = {};
  Map containerItemCodeCheckedRfidMapper = {};

  Map itemOrderLineItemMapper = {};

  Map itemRfidStatus = {}; // checked, scanned, out-of-bound
  Map containerRfidStatus = {};

  // used as check within list/ out of list
  Set<String> skuCodeSet = Set();

  // Main Data Source
  List<TransferOutOrderDetail>? orderLineDTOList = [];
  Map orderLineDTOMap = {};

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
  int totalContainer = 0;

  @observable
  String activeContainer = "";

  @observable
  bool needUpdateUI = false;

  @observable
  ObservableSet<String> itemRfidDataSet = ObservableSet();

  @observable
  ObservableSet<String> equipmentRfidDataSet = ObservableSet();

  @observable
  ObservableList<EquipmentData> equipmentData = ObservableList();

  @observable
  bool isFetchingEquData = false;

  @observable
  ObservableSet<String> checkedItem = ObservableSet();

  @observable
  ObservableList<EquipmentData> chosenEquipmentData = ObservableList();

  @observable
  bool isFetching = false;

  // void reset(){
  //   regNum = "";
  //   rfidCodeMapper = {};
  //   codeRfidMapper = {};
  //   itemRfidStatus = {};
  //   codeRfidMapper = {};
  //   orderLineDTOList = [];
  //   orderLineDTOMap = {};
  //   scannedRFIDList = [];
  // }

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

    TransferOutOrderDetail orderLineDTO = TransferOutOrderDetail(
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
      containerItemCodeCheckedRfidMapper[containerRfid] = {};
    }
    Map itemCodeCheckedRfidMapper =
    containerItemCodeCheckedRfidMapper[containerRfid];
    if (!itemCodeCheckedRfidMapper.containsKey(itemCode)) {
      itemCodeCheckedRfidMapper[itemCode] = [];
      this.itemCodeCheckedRfidMapper[itemCode] = [];
    }
    itemCodeCheckedRfidMapper[itemCode].add(rfid);
    this.itemCodeCheckedRfidMapper[itemCode].add(rfid);
  }

  void addItemIntoContainer(String containerRfid, String rfid) {
    //using key as unit identifier to avoid duplicate records are added into the list[orderLineDTOMap]
    if (containerRfid == "Out of List"){
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
        createContainer("", containerRfid, containerRfid);
      }
      if (!orderLineDTOMap[containerRfid]
          .orderLineItemsMap
          .containsKey(itemCode)) {
        orderLineDTOMap[containerRfid].orderLineItems.add(orderLineItems);
        orderLineDTOMap[containerRfid].orderLineItemsMap[itemCode] =
            orderLineItems;
      }

      this.outOfListQty += 1;

      return;
    }
    //check the status of rfid
    // if it is unchecked, checkinNum += 1, and add it into containerCode
    if (!itemRfidStatus.containsKey(rfid)) {
      // not yet committed from backend
      //key part

      String itemCode = rfidCodeMapper[rfid];
      // OrderLineItems orderLineItems =
      //     orderLineDTOMap[unScannedStrMapper].orderLineItemsMap[itemCode];

      addRfidIntocontainerItemCodeCheckedRfidMapper(
          containerRfid, itemCode, rfid);
      // addRfidIntocontainerItemCodeCheckedRfidMapper(
      //     unScannedStrMapper, itemCode, rfid);

      // orderLineItems.checkedinQty = orderLineItems.checkedinQty! + 1;
      this.totalCheckedQty += 1;
      this.addedQty += 1;
      // TODO -- revise the object movement
      if (!orderLineDTOMap[containerRfid]
          .orderLineItemsMap
          .containsKey(itemCode)) {
        // OrderLineItems newOrderLineItems = OrderLineItems.clone(orderLineItems);
        OrderLineItems orderLineItems = itemOrderLineItemMapper[itemCode];
        OrderLineItems newOrderLineItems = OrderLineItems.clone(orderLineItems);
        newOrderLineItems.checkedinQty = 1;
        newOrderLineItems.rfid = [rfid];
        orderLineDTOMap[containerRfid].orderLineItems.add(newOrderLineItems);
        orderLineDTOMap[containerRfid].orderLineItemsMap[itemCode] =
            newOrderLineItems;
      } else {
        // orderLineDTOMap[containerRfid].orderLineItems.add(orderLineItems);

        OrderLineItems targetContainerOrderLineItems =
        orderLineDTOMap[containerRfid].orderLineItemsMap[itemCode];
        targetContainerOrderLineItems.checkedinQty =
        (targetContainerOrderLineItems.checkedinQty! + 1);
        targetContainerOrderLineItems.rfid?.add(rfid);
      }

      itemRfidStatus[rfid] = "Scanned";
    } else {
      // mean already scanned
      String itemCode = rfid;
      addRfidIntocontainerItemCodeCheckedRfidMapper(
          containerRfid, itemCode, rfid);
      // containerRfid = "Out of List";

      // OrderLineItems orderLineItems = OrderLineItems(
      //     productName: rfid,
      //     rfid: [rfid],
      //     status: "temp",
      //     itemCode: rfid,
      //     productCode: rfid,
      //     checkedinQty: 1,
      //     totalQty: 1);
      //
      // if (!orderLineDTOMap.containsKey(containerRfid)) {
      //   createContainer("", containerRfid, containerRfid);
      // }
      // if (!orderLineDTOMap[containerRfid]
      //     .orderLineItemsMap
      //     .containsKey(itemCode)) {
      //   orderLineDTOMap[containerRfid].orderLineItems.add(orderLineItems);
      //   orderLineDTOMap[containerRfid].orderLineItemsMap[itemCode] =
      //       orderLineItems;
      // }
      //
      // this.outOfListQty += 1;
    }


    // update dashboard info
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

  //need to fix if used
  void addScannedRFID(String containerRfid, List rfidList) {
    rfidList.forEach((rfid) {
      if (rfidCodeMapper.containsKey(rfid)) {
        String itemCode = rfidCodeMapper[rfid];
        Map targetMap = orderLineDTOMap[containerRfid].orderLineItemsMap;
        OrderLineItems targetProductMap = targetMap[itemCode];
        targetProductMap.checkedinQty = targetProductMap.checkedinQty! + 1;
      } else {
        if (!orderLineDTOMap.containsKey("Out of List")) {
          createContainer(toNum!, "Out of List", "Out of List");
        }
        addItemIntoContainer("Out of List", rfid);
      }
    });
  }

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

        //use as orderLineItemInfo template
        itemOrderLineItemMapper[itemCode] = orderLineMap;


      });
    });
    print("");
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
    orderLineDTOList?.sortOrderLineBy(["modifiedDate", "status"], [1, 1]);
    orderLineDTOList?.forEach((orderLineContainerMap) {
      String? containerRFID = orderLineContainerMap.rfid;
      String? containerCode = orderLineContainerMap.containerCode;
      TransferOutOrderDetail orderLineDTO = orderLineDTOMap[containerRFID];
      int? modifiedDateTimeStamp = orderLineDTO.modifiedDate;
      String datetimeStr =
      DateTime.fromMillisecondsSinceEpoch(modifiedDateTimeStamp!).toString();
      // String datetimeStr = DateTime.fromMillisecondsSinceEpoch(createdTimeStamp).toString();
      datetimeStr = datetimeStr.substring(0, datetimeStr.length -4);
      String? containerStatus = orderLineDTO.status;
      Map orderLineItemsMap = orderLineDTO.orderLineItemsMap as Map;
      // String? containerRFID = orderLineDTO.rfid;

      ExpandableListItem containerExpandableList = ExpandableListItem(
          id: containerRFID ?? containerCode,
          title: containerCode ?? containerRFID,
          subTitle: "Last update: ${datetimeStr}",
          selected: false,
          badgeText: containerStatus,
          badgeColor: Color(0xFFFFE082),
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

        badgeText += "/${totalQty}";

        // if (containerCode != "Not Yet Scan" && itemCodeRfidMapper.containsKey(itemCode)) {
        //   badgeText += "/${itemCodeRfidMapper[itemCode].length}";
        // } else {
        //   badgeText += "/${totalQty}";
        // }

        ExpandableListItem orderLineExpandableListItem = ExpandableListItem(
            id: itemCode,
            title: productName,
            subTitle: "PCode: $productCode, ICode: $itemCode",
            selected: false,
            badgeText: badgeText,
            badgeColor: itemCodeRfidMapper.containsKey(itemCode) ?
            ((checkedinQty! >= itemCodeRfidMapper[itemCode].length!)
                ? Color(0xFF44b468) : Color(0xFFFFE082)) :
            Color(0xFF44b468),
            badgeTextColor:
            itemCodeRfidMapper.containsKey(itemCode) ?
            ((checkedinQty! >= itemCodeRfidMapper[itemCode].length)
                ? Color(0xFFFFFFFF) : Color(0xFF000000)) :
            Color(0xFFFFFFFF),
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
        // key logic
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
        ?.map((e) => TransferOutOrderDetail.fromJson(e))
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

  Future<void> fetchOrderDetail(String toNum, int site) async {
    // String jsonStr = await __readFile('assets/orderLine.json');
    // regNum = "GDC0980203";
    reset();
    this.toNum = toNum;
    // AssetTransferOutOrderDetailResponse result = await repository.getAssetTransferOutOrderDetail(regNum: "GDC0980203", site: 2);
    TransferOutOrderDetailResponse result = await repository
        .getTransferOutOrderDetail(toNum: toNum, site: site);
    // String jsonStr = await __readFile('assets/mockorderLine2.json');
    orderLineDTOList = result.itemList;
    int containerNum = result.rowNumber;

    // update corrsponding data based on fetched result;

    // updateNotYetScanRFID(); // useless in transfer in module
    updateOrderLineDTOMap(); // after fetch DTOList --> turn it into DTOMap
    updateContainerItemCodeCheckedRfidMapper(); // update containerItemCodeCheckedRfidMapper
    // used as showing ui --> which rfid is checked --> under what container and what item
    turnOrderLineIntoMapper(); // update Mapper --> as basic info
    // rfidCodeMapper, containerCodeRfidMapper, itemCodeRfidMapper
    updateRFIDStatusMap(); // update itemRfidStatus --> all result is scanned //TODO need to update the logic based on its condition
    // to know which rfid is not yet scan/ already scanned

    updateDashBoard(); // to update all info in the dashboard

    // orderLineMapList = json.decode(jsonStr);
    // orderLineDTOList =
    // orderLineMapList?.map((e) => TransferOutOrderDetail.fromJson(e)).toList();

    print("");
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
    toNum = "";
    rfidCodeMapper = {};
    itemRfidStatus = {};
    itemCodeRfidMapper = {};
    containerCodeRfidMapper = {};
    orderLineDTOList = [];
    orderLineDTOMap = {};
    scannedRFIDList = [];
    activeContainer = "";
  }

  @action
  void resetContainer() {
    equipmentRfidDataSet.clear();
    equipmentData.clear();
    isFetchingEquData = false;
    chosenEquipmentData.clear();
    EasyDebounce.cancel('validateContainerRfid');
  }

  @action
  Future<void> validateEquipmentRfid() async {
    if (equipmentRfidDataSet.isEmpty) {
      return;
    }
    isFetchingEquData = true;
    try {
      if (equipmentRfidDataSet.isNotEmpty) {

        //TODO update corresponding container Info
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
        }) ;

        for (var e in resList) {
          EquipmentData data = EquipmentData.fromJson(e);
          equList.add(data);
          fetchedContainerRfidList.add(data.rfid!);

          if (data.rfid != null &&
              !addedContainerAssetCodeSet.contains(data.rfid!)) {

            if(activeContainer == data.rfid){
              chosenEquipmentData.add(data);
            }

            addedContainerAssetCodeSet.add(data.rfid!);
            if (!rfidCodeMapper.containsKey(data.rfid)) {
              createContainer("", data.containerCode!, data.rfid!); // create all container needed for the future
              containerCodeRfidMapper[data.containerCode] = [data.rfid];
              rfidCodeMapper[data.rfid] = data.containerCode;
            }
          }

          containerAssetCodeSet.add(data.containerCode);
        }
        equipmentData = ObservableList.of(equList);
        if (chosenEquipmentData.length > 1 &&
            containerAssetCodeSet.length > 1) {
          // throw Exception("More than one container code found");
          print("More than one container code found");
        }

        //TODO update corresponding itemSKU Info


        List<String> outOfListItemList = [];
        List<String> onTheListItemList = [];

        // update the itemCodeRfidMapper & rfidItemMapper
        var rfidTagItemResult = await repository.getRfidTagItem(itemRfid: itemRfidDataSet.toList());
        List<RfidTagItem> rfidTagItemResultList = rfidTagItemResult.itemList;
        for(RfidTagItem rfidTagItem in rfidTagItemResultList){
          if(itemCodeRfidMapper.containsKey(rfidTagItem.skuCode)){
            // within list
            onTheListItemList.add(rfidTagItem.rfid!);
            rfidCodeMapper[rfidTagItem.rfid] = rfidTagItem.skuCode; // use skuCode same as itemCode --> need check
          }else{
            outOfListItemList.add(rfidTagItem.rfid!);
          }

          // fetechItemRfidMapper[rfidTagItem.skuCode] = rfidTagItem.rfid;
        }

        // onTheListItemList.forEach((rfid) {
        //   if (itemRfidStatus.containsKey(rfid)) { // will be all scanned in TI mode
        //     // mean scanned
        //     print("$rfid is already committedd before");
        //     // onTheListItemList.add(rfid); // containerRfid, rfid
        //   } else {
        //     // mean newly scanned
        //     // first check whether already have skuCode
        //
        //     if(itemCodeRfidMapper.containsKey(rfid)){
        //       //within List
        //       onTheListItemList.add(rfid);
        //     }else{
        //       // out of list
        //       outOfListItemList.add(rfid);
        //     }
        //
        //   }
        // });



        // when you scan sth. not within skuCodeList --> Out of list
        outOfListItemList.forEach((rfid) {
          addItemIntoContainer("Out of List", rfid); // containerRfid, rfid
        });

        onTheListItemList.forEach((rfid) {
          addItemIntoContainer(
              chosenEquipmentData[0].rfid!, rfid); // containerRfid, rfid
        });
      }
    } catch (e) {
      errorStore.setErrorMessage(e.toString());
    } finally {
      // isFetchingEquData = false;
      print("f");
      needUpdateUI = true;
    }
  }

  void addEquipmentIntoOrderLine(String containerRfid) {
    createContainer("", containerRfid, containerRfid);
  }

  void addEquipment(List<String> equList) {
    if (activeContainer == "" && equList.isNotEmpty) {
      activeContainer = equList[0];
    }
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
    var initIndex = equipmentRfidDataSet.length;
    addEquipment(equList);
    addItem(itemList);
    // itemRfidDataSet.addAll(itemList);
    // equipmentRfidDataSet.addAll(equList);
    var finalIndex = equipmentRfidDataSet.length;
    if (initIndex != finalIndex) {
      isFetchingEquData = true;
      EasyDebounce.debounce(
          'validateContainerRfid', const Duration(milliseconds: 500), () {
        validateEquipmentRfid();
      });
      // validateEquipmentRfid();
    }
  }

  @action
  Future<void> complete({String toNum = ""}) async {
    try {
      isFetching = true;
      await repository.completeToRegistration(toNum: toNum);
    } catch (e) {
      errorStore.setErrorMessage(e.toString());
    } finally {
      isFetching = false;
    }
  }

  @action
  Future<void> checkInTOContainer(
      {List<String> rfid = const [],
        String toNum = "",
        bool throwError = false}) async {
    try {
      isFetching = true;
      await repository.registerToContainer(rfid: rfid, toNum: toNum);
    } catch (e) {
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
  Future<void> checkInTOItem(
      {String toNum = "",
        String containerAssetCode = "",
        List<String> itemRfid = const [],
        bool throwError = false,
        bool directTO = false}) async {
    try {
      isFetching = true;
      await repository.registerToItem(
          toNum: toNum, containerAssetCode: containerAssetCode, itemRfid: itemRfid, directTO: directTO);
    } catch (e) {
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
  Future<void> removeContainerItemRfid(String containerRfid, String rfid)async {
    String notYetScanContainerStr = "Not Yet Scan";

    if (!rfidCodeMapper.containsKey(rfid)){
      return;
    }
    String itemCode = rfidCodeMapper[rfid];
    if(itemRfidStatus.containsKey(rfid)){
      itemRfidStatus[rfid] = "un-committed"; // 1

      //2
      if(containerItemCodeCheckedRfidMapper.containsKey(containerRfid) && containerItemCodeCheckedRfidMapper[containerRfid].containsKey(itemCode)){
        List targetContainerRfidList = containerItemCodeCheckedRfidMapper[containerRfid][itemCode];
        targetContainerRfidList.removeWhere((element) => element == rfid);
      }
      if(containerItemCodeCheckedRfidMapper.containsKey(notYetScanContainerStr) && containerItemCodeCheckedRfidMapper[notYetScanContainerStr].containsKey(itemCode)) {
        List notYetScanContainerRfidList = containerItemCodeCheckedRfidMapper[notYetScanContainerStr][itemCode];
        notYetScanContainerRfidList.removeWhere((element) => element == rfid);
      }

      //3
      if(orderLineDTOMap.containsKey(containerRfid) && orderLineDTOMap[containerRfid].orderLineItemsMap.containsKey(itemCode)) {
        OrderLineItems targetOrderIineItem = orderLineDTOMap[containerRfid].orderLineItemsMap[itemCode];
        targetOrderIineItem.checkedinQty = targetOrderIineItem.checkedinQty! - 1;
        targetOrderIineItem.rfid!.removeWhere((element) => element == rfid);
      }

      if(orderLineDTOMap.containsKey(notYetScanContainerStr) && orderLineDTOMap[notYetScanContainerStr].orderLineItemsMap.containsKey(itemCode)) {
        OrderLineItems targetOrderIineItem = orderLineDTOMap[notYetScanContainerStr].orderLineItemsMap[itemCode];
        targetOrderIineItem.checkedinQty = targetOrderIineItem.checkedinQty! - 1;
        targetOrderIineItem.rfid!.removeWhere((element) => element == rfid);
      }

      // orderLineDTOMap

    }else{
      // out of list
      //2
      String outOfListStr = "Out of List";
      if(containerItemCodeCheckedRfidMapper.containsKey(outOfListStr) && containerItemCodeCheckedRfidMapper[outOfListStr].containsKey(itemCode)){
        List<String> targetContainerRfidList = containerItemCodeCheckedRfidMapper[containerRfid][itemCode];
        targetContainerRfidList.removeWhere((element) => element == rfid);
      }

      if(orderLineDTOMap.containsKey(outOfListStr) && orderLineDTOMap[outOfListStr].orderLineItemsMap.containsKey(itemCode)) {
        OrderLineItems targetOrderIineItem = orderLineDTOMap[containerRfid].orderLineItemsMap[itemCode];
        targetOrderIineItem.checkedinQty = targetOrderIineItem.checkedinQty! - 1;
        targetOrderIineItem.rfid!.removeWhere((element) => element == rfid);
      }

      this.outOfListQty -= 1;
    }

    this.itemRfidDataSet.removeWhere((element) => element == rfid);
    this.totalCheckedQty -= 1;
    this.addedQty -= 1;


  }

  @action
  Future<void> removeContainerItem(String containerRfid, String itemCode)async {
    if(containerItemCodeCheckedRfidMapper.containsKey(containerRfid) && containerItemCodeCheckedRfidMapper[containerRfid].containsKey(itemCode)){
      List targetContainerRfidList = containerItemCodeCheckedRfidMapper[containerRfid][itemCode];
      List copyList = List.from(targetContainerRfidList);
      copyList.forEach((rfid) {removeContainerItemRfid(containerRfid, rfid);});
    }
  }

  @action
  Future<void>  removeContainer(String containerRfid)async{
    if(containerItemCodeCheckedRfidMapper.containsKey(containerRfid)){
      List itemCodeList = containerItemCodeCheckedRfidMapper[containerRfid].keys.toList();
      List copyList = List.from(itemCodeList);
      copyList.forEach((itemCode) {
        removeContainerItem(containerRfid, itemCode);
      });
    }
    this.equipmentRfidDataSet.removeWhere((element) => element == containerRfid);
  }
}