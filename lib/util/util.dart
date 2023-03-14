import 'dart:developer';

import 'package:custom_phone_number_field/data/models/phone_number_details.dart';
import 'package:custom_phone_number_field/util/countries_constant.dart';

PhoneNumberDetails? separatePhoneAndDialCode(String phoneWithDialCode) {
  Map<String, String> foundedCountry = {};
  PhoneNumberDetails? phoneNumberDetails;
  for (var country in CountriesConstant.allCountries) {
    String dialCode = country["dial_code"].toString();
    if (phoneWithDialCode.contains(dialCode)) {
      foundedCountry = country;
    }
  }

  if (foundedCountry.isNotEmpty) {
    var dialCode = phoneWithDialCode.substring(
      0,
      foundedCountry["dial_code"]!.length,
    );
    var newPhoneNumber = phoneWithDialCode.substring(
      foundedCountry["dial_code"]!.length,
    );
    log('{$dialCode, $newPhoneNumber}');

    phoneNumberDetails = PhoneNumberDetails(dialCode: dialCode, phoneNumber: newPhoneNumber);
  }

  return phoneNumberDetails;
}
