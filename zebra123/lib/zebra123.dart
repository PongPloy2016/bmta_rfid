
import 'zebra123_platform_interface.dart';

class Zebra123 {
  Future<String?> getPlatformVersion() {
    return Zebra123Platform.instance.getPlatformVersion();
  }
}
