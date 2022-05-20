import 'dart:ffi';

import 'package:easy_debounce/easy_debounce.dart';
import 'package:echo_me_mobile/data/repository.dart';
import 'package:echo_me_mobile/models/equipment_data/equipment_data.dart';
import 'package:echo_me_mobile/stores/error/error_store.dart';
import 'package:echo_me_mobile/utils/ascii_to_text.dart';
import 'package:mobx/mobx.dart';

part 'asset_registration_scan_store.g.dart';

class AssetRegistrationScanStore = _AssetRegistrationScanStore
    with _$AssetRegistrationScanStore;

abstract class _AssetRegistrationScanStore with Store {
  final String TAG = "_AssetRegistrationScanStore";

  final ErrorStore errorStore = ErrorStore();

  final Repository repository;

  _AssetRegistrationScanStore(this.repository);

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

  @action
  void reset() {
    itemRfidDataSet.clear();
    equipmentRfidDataSet.clear();
    equipmentData.clear();
    isFetchingEquData = false;
    checkedItem.clear();
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
        List<String> list =
            equipmentRfidDataSet.map((e) => AscToText.getString(e)).toList();
        var result = await repository.getEquipmentDetail(rfid: list);
        var resList = result["itemList"] as List;
        List<EquipmentData> equList = [];
        Set<String> addedContainerAssetCode = chosenEquipmentData
            .map((element) => element.containerAssetCode ?? "")
            .toSet();


        Set<String?> containerCodeSet = Set<String?>();

        // var duplicatedFlag = false;
        // String? tmpCode = "";
        // int seq = 0;

        for (var e in resList) {
          // seq ++;
          EquipmentData data = EquipmentData.fromJson(e);
          equList.add(data);
          // if (data.containerAssetCode != null && chosenEquipmentData.isEmpty) {
          //   chosenEquipmentData.add(data);
          // }
          if (data.rfid != null &&
              !addedContainerAssetCode.contains(data.rfid!)) {
            chosenEquipmentData.add(data);
            addedContainerAssetCode.add(data.rfid!);
          }
          // check containerCode duplication
          // if (data.containerCode != tmpCode && seq > 1){
          //   duplicatedFlag = true;
          // }
          //  tmpCode = data.containerCode;
          containerCodeSet.add(data.containerCode);

        }
        equipmentData = ObservableList.of(equList);
        if (chosenEquipmentData.length > 1 && containerCodeSet.length > 1) {
          throw Exception("More than one container code found");
        }
      }
    } catch (e) {
      errorStore.setErrorMessage(e.toString());
    } finally {
      isFetchingEquData = false;
    }
  }

  @action
  void updateDataSet(
      {List<String> itemList = const [], List<String> equList = const []}) {
    var initIndex = equipmentRfidDataSet.length;
    itemRfidDataSet.addAll(itemList);
    equipmentRfidDataSet.addAll(equList);
    var finalIndex = equipmentRfidDataSet.length;
    if (initIndex != finalIndex) {
      isFetchingEquData = true;
      EasyDebounce.debounce(
          'validateContainerRfid', const Duration(milliseconds: 500), () {
        validateEquipmentRfid();
      });
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
