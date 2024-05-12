import 'package:flutter_test/flutter_test.dart';
import 'package:adpopcornssp/adpopcornssp.dart';
import 'package:adpopcornssp/adpopcornssp_platform_interface.dart';
import 'package:adpopcornssp/adpopcornssp_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockAdpopcornsspPlatform
    with MockPlatformInterfaceMixin
    implements AdpopcornsspPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final AdpopcornsspPlatform initialPlatform = AdpopcornsspPlatform.instance;

  test('$MethodChannelAdpopcornssp is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelAdpopcornssp>());
  });

  test('getPlatformVersion', () async {
    Adpopcornssp adpopcornsspPlugin = Adpopcornssp();
    MockAdpopcornsspPlatform fakePlatform = MockAdpopcornsspPlatform();
    AdpopcornsspPlatform.instance = fakePlatform;

    expect(await adpopcornsspPlugin.getPlatformVersion(), '42');
  });
}
