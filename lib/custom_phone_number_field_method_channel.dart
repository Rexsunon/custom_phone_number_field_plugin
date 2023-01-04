import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'custom_phone_number_field_platform_interface.dart';

/// An implementation of [CustomPhoneNumberFieldPlatform] that uses method channels.
class MethodChannelCustomPhoneNumberField extends CustomPhoneNumberFieldPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('custom_phone_number_field');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
