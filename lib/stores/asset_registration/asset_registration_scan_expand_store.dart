import 'dart:convert';
import 'dart:ffi';

import 'package:dismissible_expanded_list/model/entry.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:echo_me_mobile/data/network/apis/asset_registration/asset_registration_api.dart';
import 'package:echo_me_mobile/models/equipment_data/equipment_data.dart';
import 'package:echo_me_mobile/stores/error/error_store.dart';
import 'package:echo_me_mobile/utils/ascii_to_text.dart';
// import 'package:expandablelist_test/util.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:echo_me_mobile/models/asset_registration/registration_order_detail.dart';
import 'package:echo_me_mobile/utils/extension/sortExtension.dart';

import 'package:echo_me_mobile/data/repository.dart';

import 'package:mobx/mobx.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';

part 'asset_registration_scan_expand_store.g.dart';

class ARScanExpandStore = _ARScanExpandStore
    with _$ARScanExpandStore;


abstract class _ARScanExpandStore with Store{

  final String TAG = "_ARScanExpandStore";

  final ErrorStore errorStore = ErrorStore();

  _ARScanExpandStore(this.repository);

  final Repository repository;

  String? regNum;

  List? orderLineMapList;

  Map rfidCodeMapper = {};
  Map itemCodeRfidMapper = {};
  Map containerCodeRfidMapper = {};

  Map itemCodeCheckedRfidMapper = {};

  Map itemRfidStatus = {}; // checked, scanned, out-of-bound
  Map containerRfidStatus = {};

  // Main Data Source
  List<RegistrationOrderDetail>? orderLineDTOList = [];
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
    if (orderLineDTOList == null || orderLineDTOList!.isEmpty){
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

  void createContainer(String orderNum, String containerCode, String containerRfid) {
    // orderLineMap[containerCode] = {
    //   "orderNum": orderNum,
    //   "containerCode": containerCode,
    //   "RFID": rfid,
    //   "status": "un-commited",
    //   "modifiedDate": DateTime.now().millisecondsSinceEpoch,
    //   "orderLineItems": []
    // };

    RegistrationOrderDetail orderLineDTO = RegistrationOrderDetail(
        orderNum: orderNum,
        containerCode: containerCode,
        rfid: containerRfid,
        modifiedDate: DateTime.now().millisecondsSinceEpoch,
        status: "un-commited",
        orderLineItems: [],
        );


    if (!orderLineDTOMap.containsKey(containerRfid)){
      orderLineDTOList?.add(orderLineDTO);
    }

    orderLineDTOMap[containerRfid] = orderLineDTO;

  }

  void addItemIntoContainer(String containerRfid, String rfid) {
    //using key as unit identifier to avoid duplicate records are added into the list[orderLineDTOMap]

    //check the status of rfid
    // if it is unchecked, checkinNum += 1, and add it into containerCode
    String unScannedStr = "unScanned";
    String unScannedStrMapper = "Not Yet Scan";
    if(itemRfidStatus.containsKey(rfid)){
      String rfidStatus = itemRfidStatus[rfid];

      if(rfidStatus != unScannedStr){
        return;
      }

      String itemCode = rfidCodeMapper[rfid];
      OrderLineItems orderLineItems = orderLineDTOMap[unScannedStrMapper].orderLineItemsMap[itemCode];

      if (!itemCodeCheckedRfidMapper.containsKey(itemCode)){
        itemCodeCheckedRfidMapper[itemCode] = [];
      }
      itemCodeCheckedRfidMapper[itemCode].add(rfid);

      orderLineItems.checkedinQty = orderLineItems.checkedinQty! + 1;
      this.totalCheckedQty += 1;
      this.addedQty += 1;
      // TODO -- revise the object movement
      if (!orderLineDTOMap[containerRfid].orderLineItemsMap.containsKey(itemCode)){
        orderLineDTOMap[containerRfid].orderLineItems.add(orderLineItems);
        orderLineDTOMap[containerRfid].orderLineItemsMap[itemCode] = orderLineItems;
      }else{
        orderLineDTOMap[containerRfid].orderLineItems.add(orderLineItems);

        OrderLineItems targetContainerOrderLineItems = orderLineDTOMap[containerRfid].orderLineItemsMap[itemCode].checkedinQty;
        targetContainerOrderLineItems.checkedinQty = orderLineItems.checkedinQty! + 1;

      }

      itemRfidStatus[rfid] = "Scanned";

    }else {
      containerRfid = "Out of List";
      String itemCode = rfid;
      OrderLineItems orderLineItems = OrderLineItems(productName: rfid , rfid: [rfid], status: "temp", itemCode: rfid, productCode: rfid, checkedinQty: 1, totalQty: 1);

      if (!orderLineDTOMap.containsKey(containerRfid)){
        createContainer("", containerRfid, containerRfid);
      }
      if (!orderLineDTOMap[containerRfid].orderLineItemsMap.containsKey(itemCode)) {
        orderLineDTOMap[containerRfid].orderLineItems.add(orderLineItems);
        orderLineDTOMap[containerRfid].orderLineItemsMap[itemCode] =
            orderLineItems;
      }

      this.outOfListQty += 1;
    }

    int now = DateTime.now().millisecondsSinceEpoch;

    for(final orderLine in orderLineDTOList!){
      if (orderLine.rfid == containerRfid){
        orderLine.modifiedDate = now;
        orderLine.status = "checking";
        break;
      }
    }
    orderLineDTOMap[containerRfid].modifiedDate = now;
    orderLineDTOMap[containerRfid].status = "checking";
  }



  void addScannedRFID(String containerRfid, List rfidList) {

    rfidList.forEach((rfid) {
      if(rfidCodeMapper.containsKey(rfid)){
        String itemCode = rfidCodeMapper[rfid];
        Map targetMap = orderLineDTOMap[containerRfid].orderLineItemsMap;
        OrderLineItems targetProductMap = targetMap[itemCode];
        targetProductMap.checkedinQty = targetProductMap.checkedinQty! + 1;
      }else{
        if(!orderLineDTOMap.containsKey("Out of List")){
          createContainer(regNum!, "Out of List", "Out of List");
        }
        addItemIntoContainer("Out of List", rfid);
      }
    });

  }


  void turnOrderLineIntoMapper() {
    if (orderLineDTOList == null || orderLineDTOList!.isEmpty){
      throw Exception("orderLineMapList shall not be null or empty");
    }

    orderLineDTOList?.forEach((boxOrderLine) {
      List<OrderLineItems>? orderLineItems = boxOrderLine.orderLineItems?.cast<OrderLineItems>();
      String? containerRFID = boxOrderLine.rfid;
      String? containerCode = boxOrderLine.containerCode;
      if (!rfidCodeMapper.containsKey(containerRFID)){
        rfidCodeMapper[containerRFID] = containerCode;
      }
      if(!containerCodeRfidMapper.containsKey(containerCode)){
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
      RegistrationOrderDetail orderLineDTO = orderLineDTOMap[containerRFID];
      int? modifiedDateTimeStamp = orderLineDTO.modifiedDate;
      DateTime date =
      DateTime.fromMillisecondsSinceEpoch(modifiedDateTimeStamp!);
      String? containerStatus = orderLineDTO.status;
      Map orderLineItemsMap = orderLineDTO.orderLineItemsMap as Map;
      // String? containerRFID = orderLineDTO.rfid;
      ExpandableListItem containerExpandableList = ExpandableListItem(
          id: containerCode?? containerRFID,
          title: containerCode?? containerRFID,
          subTitle: "Last update: ${date.toString()}",
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
        String badgeText = "$checkedinQty" ;
            if (itemCodeCheckedRfidMapper.containsKey(itemCode)){
              badgeText += "(" + "${itemCodeCheckedRfidMapper[itemCode].length}" + ")";
            }

            if (containerCode != "Not Yet Scan"){
              badgeText +=  "/${itemCodeRfidMapper[itemCode].length}";
            }else{
              badgeText +=  "/${totalQty}";
            }


        ExpandableListItem orderLineExpandableListItem = ExpandableListItem(
            id: itemCode,
            title: productName,
            subTitle: "PCode: $productCode, ICode: $itemCode",
            selected: false,
            badgeText: badgeText,
            badgeColor: (checkedinQty! >= itemCodeRfidMapper[itemCode].length!)
                ? Color(0xFF44b468)
                : Color(0xFFFFE082),
            badgeTextColor: (checkedinQty! >= itemCodeRfidMapper[itemCode].length)
                ? Color(0xFFFFFFFF)
                : Color(0xFF000000),
            children: <ExpandableListItem>[]);
        containerExpandableList.addChild(orderLineExpandableListItem);
      });
      outputExpandableListWidget.add(containerExpandableList);
    });
    print("orderLineMap");
    return outputExpandableListWidget;
  }


  void updateDashBoard(){
    if (orderLineDTOList == null || orderLineDTOList!.isEmpty){
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
        totalCheckedQty += checkedinQty!;
        this.totalQty += totalQty!;
        if (checkedinQty >= totalQty){
          totalCheckedSKU += 1;
        }
      });

    });

  }

  void updateNotYetScanRFID(){
    orderLineDTOList?.forEach((orderLineInfo) {
      if(orderLineInfo.containerCode == "Not Yet Scan"){
        orderLineInfo.rfid = orderLineInfo.containerCode;
      }
    });
  }

  void updateOrderLineDTOMap(){
    if (orderLineDTOList == null || orderLineDTOList!.isEmpty){
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

  Future<void> loadOrderLineJson() async {
    // String jsonStr = await __readFile('assets/orderLine.json');
    String jsonStr = await __readFile('assets/mockorderLine2.json');
    orderLineMapList = json.decode(jsonStr);
    turnOrderLineIntoMapper();
    updateRFIDStatusMap();
    orderLineDTOList =
        orderLineMapList?.map((e) => RegistrationOrderDetail.fromJson(e)).toList();
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

  Future<void> fetchOrderDetail(String regNum) async {
    // String jsonStr = await __readFile('assets/orderLine.json');
    // regNum = "GDC0980203";
    reset();
    this.regNum = regNum;
    // AssetRegistrationOrderDetailResponse result = await repository.getAssetRegistrationOrderDetail(regNum: "GDC0980203", site: 2);
    AssetRegistrationOrderDetailResponse result = await repository.getAssetRegistrationOrderDetail(regNum: regNum, site: 2);
    // String jsonStr = await __readFile('assets/mockorderLine2.json');
    orderLineDTOList = result.itemList;
    int containerNum = result.rowNumber;

    // update corrsponding data based on fetched result;

    updateNotYetScanRFID();
    updateOrderLineDTOMap();
    turnOrderLineIntoMapper();
    updateRFIDStatusMap();

    updateDashBoard();


    // orderLineMapList = json.decode(jsonStr);
    // orderLineDTOList =
        // orderLineMapList?.map((e) => RegistrationOrderDetail.fromJson(e)).toList();

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
    regNum = "";
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
  void resetContainer(){
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
        List<String> list2 =
        equipmentRfidDataSet.toList();
        // List<String> list2 =
        // equipmentRfidDataSet.map((e) => AscToText.getString(e)).toList();
        var result = await repository.getEquipmentDetail(rfid: list2);
        var resList = result["itemList"] as List;
        List<EquipmentData> equList = [];
        Set<String> addedContainerAssetCode = chosenEquipmentData
            .map((element) => element.containerAssetCode ?? "")
            .toSet();

        // Check for different containerAssetCode --> Remark same number of cartoon
        // have same containerAssetCode and containerCode
        Set<String?> containerAssetCodeSet = Set<String?>();

        for (var e in resList) {
          EquipmentData data = EquipmentData.fromJson(e);
          equList.add(data);

          if (data.rfid != null &&
              !addedContainerAssetCode.contains(data.rfid!)) {
            chosenEquipmentData.add(data);
            addedContainerAssetCode.add(data.rfid!);
            createContainer("", data.containerCode!, data.rfid!);
          }

          containerAssetCodeSet.add(data.containerCode);

        }
        equipmentData = ObservableList.of(equList);
        if (chosenEquipmentData.length > 1 && containerAssetCodeSet.length > 1) {
          // throw Exception("More than one container code found");
          print("More than one container code found");
        }

        List<String> outOfListItemList = [];
        List<String> onTheListItemList = [];


        itemRfidDataSet.forEach((rfid) {
          if(itemRfidStatus.containsKey(rfid)) {
            onTheListItemList.add(rfid); // containerRfid, rfid
          }else{
            outOfListItemList.add(rfid);
          }
        });

        outOfListItemList.forEach((rfid) {
          addItemIntoContainer("Out of List", rfid); // containerRfid, rfid
        });

        onTheListItemList.forEach((rfid) {
          addItemIntoContainer(chosenEquipmentData[0].rfid!, rfid); // containerRfid, rfid
        });

      }
    } catch (e) {
      errorStore.setErrorMessage(e.toString());
    } finally {
      // isFetchingEquData = false;
      print("f");
    }
  }

  void addEquipmentIntoOrderLine(String containerRfid){
    createContainer("", containerRfid, containerRfid);
  }


  void addEquipment(List<String> equList){
    if (activeContainer == ""){
      activeContainer = equList[0];
    }
    equipmentRfidDataSet.addAll(equList);

  }

  void addItem(List<String> itemList){
    itemRfidDataSet.addAll(itemList);
  }

  void takeOutEquipment(List<String> equList){
    if (activeContainer == ""){
      activeContainer = equList[0];
    }
    equipmentRfidDataSet.addAll(equList);
  }

  void takeOutItem(List<String> itemList){
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
      // EasyDebounce.debounce(
      //     'validateContainerRfid', const Duration(milliseconds: 500), () {
      //   validateEquipmentRfid();
      // });
      validateEquipmentRfid();
    }
  }

  @action
  Future<void> complete({String regNum = ""}) async {
    try {
      isFetching = true;
      await repository.completeAssetRegistration(regNum: regNum);
    } catch (e) {
      errorStore.setErrorMessage(e.toString());
    } finally {
      isFetching = false;
    }
  }

  @action
  Future<void> registerContainer(
      {List<String> rfid = const [],
        String regNum = "",
        bool throwError = false}) async {
    try {
      isFetching = true;
      await repository.registerContainer(rfid: rfid, regNum: regNum);
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

  //TODO:: [bugs]just using containerAssetCode got problem to verify --> multi containers
  @action
  Future<void> registerItem(
      {String regNum = "",
        String containerAssetCode = "",
        List<String> itemRfid = const [],
        bool throwError = false}) async {
    try {
      isFetching = true;
      await repository.registerItem(
          regNum: regNum,
          containerAssetCode: containerAssetCode,
          itemRfid: itemRfid);
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
}
