// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stock_take_item.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$StockTakeItemHolder on _StockTakeItemHolder, Store {
  final _$orderIdAtom = Atom(name: '_StockTakeItemHolder.orderId');

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

  final _$statusAtom = Atom(name: '_StockTakeItemHolder.status');

  @override
  String get status {
    _$statusAtom.reportRead();
    return super.status;
  }

  @override
  set status(String value) {
    _$statusAtom.reportWrite(value, super.status, () {
      super.status = value;
    });
  }

  @override
  String toString() {
    return '''
orderId: ${orderId},
status: ${status}
    ''';
  }
}
