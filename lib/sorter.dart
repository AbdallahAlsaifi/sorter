
import 'sorter_platform_interface.dart';

class Sorter {
  Future<String?> getPlatformVersion() {
    return SorterPlatform.instance.getPlatformVersion();
  }
}
