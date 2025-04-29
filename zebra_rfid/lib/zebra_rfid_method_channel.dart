import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'zebra_rfid_platform_interface.dart';

/// An implementation of [ZebraRfidPlatform] that uses method channels.
class MethodChannelZebraRfid extends ZebraRfidPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('zebra_rfid');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
