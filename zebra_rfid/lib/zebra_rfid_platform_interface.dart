import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'zebra_rfid_method_channel.dart';

abstract class ZebraRfidPlatform extends PlatformInterface {
  /// Constructs a ZebraRfidPlatform.
  ZebraRfidPlatform() : super(token: _token);

  static final Object _token = Object();

  static ZebraRfidPlatform _instance = MethodChannelZebraRfid();

  /// The default instance of [ZebraRfidPlatform] to use.
  ///
  /// Defaults to [MethodChannelZebraRfid].
  static ZebraRfidPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [ZebraRfidPlatform] when
  /// they register themselves.
  static set instance(ZebraRfidPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
