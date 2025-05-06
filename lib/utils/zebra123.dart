import 'package:flutter/services.dart';

class Zebra123 {
  static const MethodChannel _channel = MethodChannel('zebra123');

  static Future<String?> getPlatformVersion() async {
    final String? version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  static Future<String?> startScan() async {
    final String? result = await _channel.invokeMethod('startScan');
    return result;
  }
}