import 'dart:ffi';

import 'package:easy_debounce/easy_debounce.dart';
import 'package:echo_me_mobile/data/repository.dart';
import 'package:echo_me_mobile/models/equipment_data/equipment_data.dart';
import 'package:echo_me_mobile/models/site_code/loc_site_item.dart';
import 'package:echo_me_mobile/stores/error/error_store.dart';
import 'package:echo_me_mobile/utils/ascii_to_text.dart';
import 'package:mobx/mobx.dart';

part 'site_code_item_store.g.dart';

class SiteCodeItemStore = _SiteCodeItemStore
    with _$SiteCodeItemStore;

abstract class _SiteCodeItemStore with Store {
  final String TAG = "_SiteCodeItemStore";

  final ErrorStore errorStore = ErrorStore();


  final Repository repository;

  _SiteCodeItemStore(this.repository);
  
  @observable
  int page = 0;

  @observable
  int limit = 10;

  @observable
  int totalCount = 0;

  @observable
  ObservableList<LocSiteItem> siteCodeDataList = ObservableList();

  // @observable
  // ObservableList<String?> siteCodeNameList = ObservableList();

  @computed
  ObservableList<String?> get siteCodeNameList {
    ObservableList<String?> tempObList = ObservableList<String?>();
    siteCodeDataList.forEach((element) {
      tempObList.add(element.siteCode);
    });
    return tempObList;
  }



  @observable
  bool isFetchingEquData = false;

  @observable
  ObservableSet<String> checkedSite = ObservableSet();

  @observable
  ObservableList<LocSiteItem> chosenSite = ObservableList();

  @observable
  bool isFetching = false;



  // @action
  // Future<void> validateEquipmentRfid() async {
  //   if (equipmentRfidDataSet.isEmpty) {
  //     return;
  //   }
  //   isFetchingEquData = true;
  //   try {
  //     if (equipmentRfidDataSet.isNotEmpty) {
  //       List<String> list =
  //       equipmentRfidDataSet.map((e) => AscToText.getString(e)).toList();
  //       var result = await repository.getEquipmentDetail(rfid: list);
  //       var resList = result["itemList"] as List;
  //       List<EquipmentData> equList = [];
  //       Set<String> addedContainerAssetCode = chosenEquipmentData
  //           .map((element) => element.containerAssetCode ?? "")
  //           .toSet();
  //
  //       // Check for different containerAssetCode --> Remark same number of cartoon
  //       // have same containerAssetCode and containerCode
  //       Set<String?> containerAssetCodeSet = Set<String?>();
  //
  //       for (var e in resList) {
  //         EquipmentData data = EquipmentData.fromJson(e);
  //         equList.add(data);
  //
  //         if (data.rfid != null &&
  //             !addedContainerAssetCode.contains(data.rfid!)) {
  //           chosenEquipmentData.add(data);
  //           addedContainerAssetCode.add(data.rfid!);
  //         }
  //
  //         containerAssetCodeSet.add(data.containerCode);
  //
  //       }
  //       equipmentData = ObservableList.of(equList);
  //       if (chosenEquipmentData.length > 1 && containerAssetCodeSet.length > 1) {
  //         throw Exception("More than one container code found");
  //       }
  //     }
  //   } catch (e) {
  //     errorStore.setErrorMessage(e.toString());
  //   } finally {
  //     isFetchingEquData = false;
  //   }
  // }



  @action
  Future<void> listLocSite(
      {int page = 0, int limit = 10, String siteCode = "", bool throwError = false}) async {
    try {
      isFetching = true;
      await repository.listSiteCode(page: page, limit: limit, siteCode: siteCode);
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
  void addAllItem(List<LocSiteItem> list){
    print("????????");
    print(list);
    print(siteCodeDataList);
    print(siteCodeNameList);
    siteCodeDataList.addAll(list);
    // siteCodeNameList.addAll(list.map((e) => e.siteCode).toList());
    print(siteCodeNameList.length);
    print(siteCodeDataList.length);
    print("????????");
  }

  @action
  Future<void> fetchData({int page = 0, int limit = 10, String siteCode = "", bool throwError = false}) async {
    isFetching = true;
    try{
      var data = await repository.listSiteCode(page:page, limit: limit, siteCode: siteCode);
      int totalRow = data.rowNumber;
      List<LocSiteItem> list = data.itemList.map((LocSiteItem e) => e).toList();
      totalCount = totalRow;
      page = page;
      siteCodeDataList.clear();
      siteCodeNameList.clear();
      addAllItem(list);
    }catch(e){
      print(e);
      errorStore.setErrorMessage("error in fetching data");
    }finally{
      isFetching = false;
      print("finally");
    }
  }
}


  // //TODO:: [bugs]just using containerAssetCode got problem to verify --> multi containers
  // @action
  // Future<void> registerItem(
  //     {String regNum = "",
  //       String containerAssetCode = "",
  //       List<String> itemRfid = const [],
  //       bool throwError = false}) async {
  //   try {
  //     isFetching = true;
  //     await repository.registerItem(
  //         regNum: regNum,
  //         containerAssetCode: containerAssetCode,
  //         itemRfid: itemRfid);
  //   } catch (e) {
  //     if (throwError == true) {
  //       rethrow;
  //     } else {
  //       errorStore.setErrorMessage(e.toString());
  //     }
  //   } finally {
  //     isFetching = false;
  //   }
  // }

