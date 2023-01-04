import 'dart:developer';

import 'package:custom_phone_number_field/util/assets.dart';
import 'package:custom_phone_number_field/util/countries_constant.dart';
import 'package:custom_phone_number_field/util/util.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomPhoneNumberField extends HookWidget {
  const CustomPhoneNumberField({
    Key? key,
    required this.hint,
    this.focusNode,
    this.icon,
    this.textHint,
    this.controller,
    this.validator,
    this.onChanged,
    this.onFieldSubmitted,
    this.keyboardType,
    this.inputFormatters,
    this.textCapitalization,
    this.textInputAction,
  }) : super(key: key);

  final String hint;
  final FocusNode? focusNode;
  final Widget? icon;
  final String? textHint;
  final TextEditingController? controller;
  final FormFieldValidator<String>? validator;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onFieldSubmitted;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final TextCapitalization? textCapitalization;
  final TextInputAction? textInputAction;

  @override
  Widget build(BuildContext context) {
    final dialCode = useState<String?>(null);
    final phoneNumber = useState<String?>(null);

    final localFocusNode = useFocusNode();
    final focusColor = useState<Color>(Colors.grey[400]!);
    final showDropdown = useState(false);
    final countries = useState(CountriesConstant.allCountries);

    useEffect(() {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (controller != null && controller!.text.isNotEmpty) {
          var phoneNumberWithDialCode = separatePhoneAndDialCode(controller!.text);
          if (phoneNumberWithDialCode != null) {
            log("Controller: ${controller!.text}");
            log("DialCode: ${phoneNumberWithDialCode.dialCode}");
            log("PhoneNumber: ${phoneNumberWithDialCode.phoneNumber}");

            dialCode.value = phoneNumberWithDialCode.dialCode;
            phoneNumber.value = phoneNumberWithDialCode.phoneNumber;
            controller!.text = phoneNumberWithDialCode.phoneNumber;
          }
        } else {
          // todo detect device country and add country code by default
          dialCode.value = countries.value.first['dial_code'];
        }
      });

      return () {};
    }, const []);

    Color fieldIsFocused() {
      if ((focusNode != null && focusNode!.hasFocus) ||
          localFocusNode.hasFocus) {
        return focusColor.value = Theme.of(context).primaryColor;
      }

      return focusColor.value;
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          height: 55,
          decoration: BoxDecoration(
            border: Border.all(color: fieldIsFocused()),
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Row(
            children: [
              GestureDetector(
                onTap: () => showDropdown.value = !showDropdown.value,
                child: Container(
                  width: 100,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(8.0),
                      bottomLeft: Radius.circular(8.0),
                    ),
                  ),
                  child: Center(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text("${dialCode.value}"),
                        Icon(
                          showDropdown.value
                              ? Icons.arrow_drop_up_rounded
                              : Icons.arrow_drop_down_rounded,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  height: 55,
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Center(
                    child: TextFormField(
                      // style: const TextStyle(fontSize: kBodySmallFontSize),
                      focusNode: focusNode ?? localFocusNode,
                      controller: controller,
                      // cursorHeight: 14,
                      // cursorColor: kPrimaryColor,
                      keyboardType: keyboardType,
                      inputFormatters: inputFormatters,
                      textInputAction: textInputAction,
                      textCapitalization:
                          textCapitalization ?? TextCapitalization.none,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: textHint ?? "Phone Number",
                        hintStyle: const TextStyle(fontSize: 13),
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 5.0,
                          horizontal: 0.0,
                        ),
                      ),
                      onChanged: (value) {
                        value = '${dialCode.value}$value';
                        log('onChanged text value: $value');

                        if (onChanged != null) {
                          onChanged!(value);
                        }
                      },
                      onFieldSubmitted: (value) {
                        value = '${dialCode.value}$value';
                        log('on Submit text value: $value');

                        if (onFieldSubmitted != null) {
                          onFieldSubmitted!(value);
                        }
                      },
                      validator: validator,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
        SizedBox(height: showDropdown.value ? 8.0 : 0),
        Visibility(
          visible: showDropdown.value,
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: 250,
            padding: const EdgeInsets.all(5.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.0),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey[300]!.withOpacity(0.8),
                  blurRadius: 8.0,
                  spreadRadius: 0.0,
                  offset: const Offset(0.0, 2.0),
                ),
              ],
            ),
            child: Column(
              children: [
                TextField(
                  decoration: InputDecoration(
                    prefixIcon: SvgPicture.asset(
                      kSearchIcon,
                      width: 16,
                      height: 16,
                      fit: BoxFit.none,
                    ),
                    hintText: "Search for countries",
                    hintStyle: const TextStyle(fontSize: 13),
                    border: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey[300]!),
                    ),
                  ),
                  onChanged: (value) {
                    if (value.isNotEmpty) {
                      countries.value = countries.value
                          .where((country) => country['name']!
                              .toLowerCase()
                              .contains(value.toLowerCase()))
                          .toList();
                    } else {
                      countries.value = CountriesConstant.allCountries;
                    }
                  },
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: countries.value.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        leading: Text(
                          "${countries.value[index]['name']} (${countries.value[index]['dial_code']})",
                          style: const TextStyle(fontSize: 14),
                        ),
                        onTap: () {
                          dialCode.value = countries.value[index]['dial_code']!;
                          showDropdown.value = !showDropdown.value;
                          countries.value = CountriesConstant.allCountries;
                        },
                        trailing: Visibility(
                          visible: countries.value[index]['dial_code']! == dialCode.value,
                          child: const Icon(Icons.check_rounded),
                        ),
                      );
                    },
                  ),
                )
              ],
            ),
          ),
        )
      ],
    );
  }
}
