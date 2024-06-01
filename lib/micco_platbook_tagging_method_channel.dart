import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'micco_platbook_tagging_platform_interface.dart';

/// An implementation of [MiccoPlatbookTaggingPlatform] that uses method channels.
class MethodChannelMiccoPlatbookTagging extends MiccoPlatbookTaggingPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('micco_platbook_tagging');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }

  @override
  Future<Map<String, String>> predict(Map<String, String> input) async {
    final result = <String, String>{};
    for (final key in input.keys) {
      final label = await methodChannel.invokeMethod<String>('predict', { "key": input[key] });
      if (label != null) {
        result[key] = label;
      }
    }
    return result;
  }

  @override
  Future<void> loadLodel() async {
    await methodChannel.invokeMethod('loadLodel');
  }
}
