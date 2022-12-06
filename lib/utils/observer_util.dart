import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter/material.dart';

Widget wrapObserver(Widget widget){
  return Observer(
    builder: (context) {
      return widget;
    },
  );
}