import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'micco_platbook_tagging_method_channel.dart';

abstract class MiccoPlatbookTaggingPlatform extends PlatformInterface {
  /// Constructs a MiccoPlatbookTaggingPlatform.
  MiccoPlatbookTaggingPlatform() : super(token: _token);

  static final Object _token = Object();

  static MiccoPlatbookTaggingPlatform _instance = MethodChannelMiccoPlatbookTagging();

  /// The default instance of [MiccoPlatbookTaggingPlatform] to use.
  ///
  /// Defaults to [MethodChannelMiccoPlatbookTagging].
  static MiccoPlatbookTaggingPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [MiccoPlatbookTaggingPlatform] when
  /// they register themselves.
  static set instance(MiccoPlatbookTaggingPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion();

  Future<Map<String, String>> predict(Map<String, String> input);

  Future<void> loadLodel ();
}
