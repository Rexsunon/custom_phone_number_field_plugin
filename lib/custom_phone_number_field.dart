
import 'custom_phone_number_field_platform_interface.dart';

class CustomPhoneNumberField {
  Future<String?> getPlatformVersion() {
    return CustomPhoneNumberFieldPlatform.instance.getPlatformVersion();
  }
}
