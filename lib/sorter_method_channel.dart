import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'sorter_platform_interface.dart';

/// An implementation of [SorterPlatform] that uses method channels.
class MethodChannelSorter extends SorterPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('sorter');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
