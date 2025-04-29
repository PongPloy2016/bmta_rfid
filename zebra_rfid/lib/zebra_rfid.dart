
import 'zebra_rfid_platform_interface.dart';

class ZebraRfid {
  Future<String?> getPlatformVersion() {
    return ZebraRfidPlatform.instance.getPlatformVersion();
  }
}
