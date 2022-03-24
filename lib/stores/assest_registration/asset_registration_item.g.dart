// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'asset_registration_item.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$AssetRegistrationItem on _AssetRegistrationItem, Store {
  final _$orderIdAtom = Atom(name: '_AssetRegistrationItem.orderId');

  @override
  String get orderId {
    _$orderIdAtom.reportRead();
    return super.orderId;
  }

  @override
  set orderId(String value) {
    _$orderIdAtom.reportWrite(value, super.orderId, () {
      super.orderId = value;
    });
  }

  final _$supplierNameAtom = Atom(name: '_AssetRegistrationItem.supplierName');

  @override
  String get supplierName {
    _$supplierNameAtom.reportRead();
    return super.supplierName;
  }

  @override
  set supplierName(String value) {
    _$supplierNameAtom.reportWrite(value, super.supplierName, () {
      super.supplierName = value;
    });
  }

  final _$statusAtom = Atom(name: '_AssetRegistrationItem.status');

  @override
  RegistrationItemStatus get status {
    _$statusAtom.reportRead();
    return super.status;
  }

  @override
  set status(RegistrationItemStatus value) {
    _$statusAtom.reportWrite(value, super.status, () {
      super.status = value;
    });
  }

  final _$_AssetRegistrationItemActionController =
      ActionController(name: '_AssetRegistrationItem');

  @override
  void updateStatus(RegistrationItemStatus status) {
    final _$actionInfo = _$_AssetRegistrationItemActionController.startAction(
        name: '_AssetRegistrationItem.updateStatus');
    try {
      return super.updateStatus(status);
    } finally {
      _$_AssetRegistrationItemActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
orderId: ${orderId},
supplierName: ${supplierName},
status: ${status}
    ''';
  }
}
