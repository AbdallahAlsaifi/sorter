import 'package:flutter_test/flutter_test.dart';
import 'package:sorter/sorter.dart';
import 'package:sorter/sorter_platform_interface.dart';
import 'package:sorter/sorter_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockSorterPlatform
    with MockPlatformInterfaceMixin
    implements SorterPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final SorterPlatform initialPlatform = SorterPlatform.instance;

  test('$MethodChannelSorter is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelSorter>());
  });

  test('getPlatformVersion', () async {
    Sorter sorterPlugin = Sorter();
    MockSorterPlatform fakePlatform = MockSorterPlatform();
    SorterPlatform.instance = fakePlatform;

    expect(await sorterPlugin.getPlatformVersion(), '42');
  });
}
