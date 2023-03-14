import 'package:flutter_test/flutter_test.dart';
// import 'package:custom_phone_number_field/custom_phone_number_field.dart';
import 'package:custom_phone_number_field/custom_phone_number_field_platform_interface.dart';
import 'package:custom_phone_number_field/custom_phone_number_field_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockCustomPhoneNumberFieldPlatform
    with MockPlatformInterfaceMixin
    implements CustomPhoneNumberFieldPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final CustomPhoneNumberFieldPlatform initialPlatform = CustomPhoneNumberFieldPlatform.instance;

  test('$MethodChannelCustomPhoneNumberField is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelCustomPhoneNumberField>());
  });

  test('getPlatformVersion', () async {
    // CustomPhoneNumberField customPhoneNumberFieldPlugin = CustomPhoneNumberField();
    // MockCustomPhoneNumberFieldPlatform fakePlatform = MockCustomPhoneNumberFieldPlatform();
    // CustomPhoneNumberFieldPlatform.instance = fakePlatform;
    //
    // expect(await customPhoneNumberFieldPlugin.getPlatformVersion(), '42');
  });
}
