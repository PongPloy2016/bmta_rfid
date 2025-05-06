import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'zebra123_method_channel.dart';

abstract class Zebra123Platform extends PlatformInterface {
  /// Constructs a Zebra123Platform.
  Zebra123Platform() : super(token: _token);

  static final Object _token = Object();

  static Zebra123Platform _instance = MethodChannelZebra123();

  /// The default instance of [Zebra123Platform] to use.
  ///
  /// Defaults to [MethodChannelZebra123].
  static Zebra123Platform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [Zebra123Platform] when
  /// they register themselves.
  static set instance(Zebra123Platform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
