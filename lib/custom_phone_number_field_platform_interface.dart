import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'custom_phone_number_field_method_channel.dart';

abstract class CustomPhoneNumberFieldPlatform extends PlatformInterface {
  /// Constructs a CustomPhoneNumberFieldPlatform.
  CustomPhoneNumberFieldPlatform() : super(token: _token);

  static final Object _token = Object();

  static CustomPhoneNumberFieldPlatform _instance = MethodChannelCustomPhoneNumberField();

  /// The default instance of [CustomPhoneNumberFieldPlatform] to use.
  ///
  /// Defaults to [MethodChannelCustomPhoneNumberField].
  static CustomPhoneNumberFieldPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [CustomPhoneNumberFieldPlatform] when
  /// they register themselves.
  static set instance(CustomPhoneNumberFieldPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
