import 'package:flutter_test/flutter_test.dart';
import 'package:zebra123/zebra123.dart';
import 'package:zebra123/zebra123_platform_interface.dart';
import 'package:zebra123/zebra123_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockZebra123Platform
    with MockPlatformInterfaceMixin
    implements Zebra123Platform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final Zebra123Platform initialPlatform = Zebra123Platform.instance;

  test('$MethodChannelZebra123 is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelZebra123>());
  });

  test('getPlatformVersion', () async {
    Zebra123 zebra123Plugin = Zebra123();
    MockZebra123Platform fakePlatform = MockZebra123Platform();
    Zebra123Platform.instance = fakePlatform;

    expect(await zebra123Plugin.getPlatformVersion(), '42');
  });
}
