import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'zebra123_platform_interface.dart';

/// An implementation of [Zebra123Platform] that uses method channels.
class MethodChannelZebra123 extends Zebra123Platform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('method');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
