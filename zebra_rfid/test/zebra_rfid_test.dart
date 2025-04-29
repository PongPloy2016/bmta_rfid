import 'package:flutter_test/flutter_test.dart';
import 'package:zebra_rfid/zebra_rfid.dart';
import 'package:zebra_rfid/zebra_rfid_platform_interface.dart';
import 'package:zebra_rfid/zebra_rfid_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockZebraRfidPlatform
    with MockPlatformInterfaceMixin
    implements ZebraRfidPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final ZebraRfidPlatform initialPlatform = ZebraRfidPlatform.instance;

  test('$MethodChannelZebraRfid is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelZebraRfid>());
  });

  test('getPlatformVersion', () async {
    ZebraRfid zebraRfidPlugin = ZebraRfid();
    MockZebraRfidPlatform fakePlatform = MockZebraRfidPlatform();
    ZebraRfidPlatform.instance = fakePlatform;

    expect(await zebraRfidPlugin.getPlatformVersion(), '42');
  });
}
