
import 'micco_platbook_tagging_platform_interface.dart';

class MiccoPlatbookTagging {
  Future<String?> getPlatformVersion() {
    return MiccoPlatbookTaggingPlatform.instance.getPlatformVersion();
  }

  Future<Map<String, String>> predict (Map<String, String> input) {
    return MiccoPlatbookTaggingPlatform.instance.predict(input);
  }

  Future<void> loadLodel () {
    return MiccoPlatbookTaggingPlatform.instance.loadLodel();
  }
}
