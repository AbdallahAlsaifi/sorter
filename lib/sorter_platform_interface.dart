import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'sorter_method_channel.dart';

abstract class SorterPlatform extends PlatformInterface {
  /// Constructs a SorterPlatform.
  SorterPlatform() : super(token: _token);

  static final Object _token = Object();

  static SorterPlatform _instance = MethodChannelSorter();

  /// The default instance of [SorterPlatform] to use.
  ///
  /// Defaults to [MethodChannelSorter].
  static SorterPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [SorterPlatform] when
  /// they register themselves.
  static set instance(SorterPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
