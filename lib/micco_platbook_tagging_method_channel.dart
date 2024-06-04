import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'micco_platbook_tagging_platform_interface.dart';

import 'dart:developer' as developer;

class LabelAndConfidence {
  final String label;
  final double confidence;
  const LabelAndConfidence({ required this.label, required this.confidence });
}

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
  Future<Map<String, List<LabelAndConfidence>>> predict(Map<String, String> input) async {
    final result = <String, List<LabelAndConfidence>>{};
    for (final key in input.keys) {
      final jsonStr = await methodChannel.invokeMethod<String>('predict', { "key": input[key] });
      if (jsonStr == null) continue;
      final ret = <LabelAndConfidence>[];
      try {
        final parsed = jsonDecode(jsonStr);
        if (parsed is Map) {
          final entries = parsed.entries.toList();
          for (final entry in entries) {
            final key = entry.key;
            final confidence = entry.value;
            if (key is String && confidence is double) {
              ret.add(LabelAndConfidence(label: key, confidence: confidence));
            }
          }
        }
      } catch (e) {
        developer.log('Error parsing JSON: $jsonStr');
      }
      if (ret.isNotEmpty) {
        ret.sort((a, b) => b.confidence.compareTo(a.confidence));
        result[key] = ret;
      }
    }
    return result;
  }

  @override
  Future<void> loadLodel() async {
    await methodChannel.invokeMethod('loadLodel');
  }
}
