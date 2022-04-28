import 'package:flutter/material.dart';

class ExamplePage extends StatefulWidget {
  ExamplePage({Key? key}) : super(key: key);

  @override
  State<ExamplePage> createState() => _ExamplePageState();
}

class _ExamplePageState extends State<ExamplePage> with ScanPageBase {
  @override
  Widget build(BuildContext context) {
    return Container();
  }

  @override
  void someFunction() {
    // TODO: implement someFunction
  }
}

abstract class ScanPageBase<T> implements ScanBaseStore {
  final List<String> _scannedList = [];
  final List<T> _list = [];


  void _addToList(String value) {
    _scannedList.add(value);
  }
}

abstract class ScanBaseStore {
  void someFunction();
}
