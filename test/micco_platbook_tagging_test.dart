import 'package:flutter_test/flutter_test.dart';
import 'package:micco_platbook_tagging/micco_platbook_tagging.dart';
import 'package:micco_platbook_tagging/micco_platbook_tagging_platform_interface.dart';
import 'package:micco_platbook_tagging/micco_platbook_tagging_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockMiccoPlatbookTaggingPlatform
    with MockPlatformInterfaceMixin
    implements MiccoPlatbookTaggingPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
  
  @override
  Future<void> loadLodel() {
    throw UnimplementedError();
  }
  
  @override
  Future<Map<String, List<LabelAndConfidence>>> predict(Map<String, String> input) {
    throw UnimplementedError();
  }
}

void main() {
  final MiccoPlatbookTaggingPlatform initialPlatform = MiccoPlatbookTaggingPlatform.instance;

  test('$MethodChannelMiccoPlatbookTagging is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelMiccoPlatbookTagging>());
  });

  test('getPlatformVersion', () async {
    MiccoPlatbookTagging miccoPlatbookTaggingPlugin = MiccoPlatbookTagging();
    MockMiccoPlatbookTaggingPlatform fakePlatform = MockMiccoPlatbookTaggingPlatform();
    MiccoPlatbookTaggingPlatform.instance = fakePlatform;

    expect(await miccoPlatbookTaggingPlugin.getPlatformVersion(), '42');
  });
}
