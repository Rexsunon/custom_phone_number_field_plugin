#import "CustomPhoneNumberFieldPlugin.h"
#if __has_include(<custom_phone_number_field/custom_phone_number_field-Swift.h>)
#import <custom_phone_number_field/custom_phone_number_field-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "custom_phone_number_field-Swift.h"
#endif

@implementation CustomPhoneNumberFieldPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftCustomPhoneNumberFieldPlugin registerWithRegistrar:registrar];
}
@end
