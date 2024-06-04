
import 'micco_platbook_tagging_method_channel.dart';
import 'micco_platbook_tagging_platform_interface.dart';

class MiccoPlatbookTagging {
  Future<String?> getPlatformVersion() {
    return MiccoPlatbookTaggingPlatform.instance.getPlatformVersion();
  }

  Future<Map<String, List<LabelAndConfidence>>> predict (Map<String, String> input) {
    return MiccoPlatbookTaggingPlatform.instance.predict(input);
  }

  Future<void> loadLodel () {
    return MiccoPlatbookTaggingPlatform.instance.loadLodel();
  }
}
