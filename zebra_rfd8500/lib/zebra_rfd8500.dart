
import 'dart:async';

import 'package:flutter/services.dart';

class ZebraRfd8500 {
  static const MethodChannel _channel = MethodChannel('zebra_rfd8500');

  static Future<String?> get platformVersion async {
    final String? version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }
}
