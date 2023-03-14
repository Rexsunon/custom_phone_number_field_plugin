import 'dart:developer';

import 'package:custom_phone_number_field/util/assets.dart';
import 'package:custom_phone_number_field/util/countries_constant.dart';
import 'package:custom_phone_number_field/util/util.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomPhoneNumberField extends StatefulHookWidget {
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
  State<CustomPhoneNumberField> createState() => _CustomPhoneNumberFieldState();
}

class _CustomPhoneNumberFieldState extends State<CustomPhoneNumberField> {
  bool hasFocus = false;

  void _handleFocusChange(FocusNode focusNode) {
    setState(() {
      hasFocus = focusNode.hasFocus;
    });
  }

  @override
  Widget build(BuildContext context) {
    final countryFlag = useState<String>("");

    final localFocusNode = useFocusNode();
    final focusColor = useState<Color>(Colors.grey[400]!);
    final showDropdown = useState(false);
    final countries = useState(CountriesConstant.allCountries);

    // Focus
    final focus = useFocusNode();
    final textFieldFocus = useFocusNode();

    final focusNodeState = useState(widget.focusNode ?? focus);

    useEffect(() {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (widget.controller != null && widget.controller!.text.isNotEmpty) {
          var phoneNumberWithDialCode = separatePhoneAndDialCode(widget.controller!.text);
          if (phoneNumberWithDialCode != null) {
            log("Controller: ${widget.controller!.text}");
            log("DialCode: ${phoneNumberWithDialCode.dialCode}");
            log("PhoneNumber: ${phoneNumberWithDialCode.phoneNumber}");

            var flag = countries.value.firstWhere((country) => country['dial_code'] == phoneNumberWithDialCode.dialCode)['flag'];

            countryFlag.value = flag!;
            // phoneNumber.value = phoneNumberWithDialCode.phoneNumber;
            // controller!.text = phoneNumberWithDialCode.phoneNumber;
          }

        } else {
          // todo detect device country and add country code by default
          countryFlag.value = countries.value.first['flag']!;
          widget.controller!.text = countries.value.first['dial_code']!;
        }
      });

      return () {};
    }, const []);

    return Focus(
      focusNode: focusNodeState.value,
      onFocusChange: (hasFocus) => _handleFocusChange(focusNodeState.value),
      child: GestureDetector(
        onTap: () {
          focusNodeState.value.requestFocus();
          textFieldFocus.requestFocus(); // Give focus to TextField
        },
        child: FormField<String>(
          validator: widget.validator,
          initialValue: '',
          builder: (state) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  height: 55,
                  decoration: BoxDecoration(
                    border: Border.all(color: hasFocus ? Theme.of(context).primaryColor : focusColor.value),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Row(
                    children: [
                      // dropdown
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
                              // mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                // country flag
                                Text(countryFlag.value, style: const TextStyle(fontSize: 25),),
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

                      // Text field
                      Expanded(
                        child: Container(
                          height: 55,
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: Center(
                            child: TextFormField(
                              // style: const TextStyle(fontSize: kBodySmallFontSize),
                              focusNode: textFieldFocus,
                              controller: widget.controller,
                              // cursorHeight: 14,
                              // cursorColor: kPrimaryColor,
                              keyboardType: widget.keyboardType,
                              inputFormatters: widget.inputFormatters,
                              textInputAction: widget.textInputAction,
                              textCapitalization:
                                  widget.textCapitalization ?? TextCapitalization.none,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                enabledBorder: InputBorder.none,
                                errorBorder: InputBorder.none,
                                disabledBorder: InputBorder.none,
                                focusedBorder: InputBorder.none,
                                focusedErrorBorder: InputBorder.none,
                                hintText: widget.textHint ?? "Phone Number",
                                hintStyle: const TextStyle(fontSize: 13),
                                contentPadding: const EdgeInsets.symmetric(
                                  vertical: 5.0,
                                  horizontal: 0.0,
                                ),
                              ),
                              onChanged: (value) {
                                // value = '${countryFlag.value}$value';
                                log('onChanged text value: $value');

                                if (widget.onChanged != null) {
                                  widget.onChanged!(value);
                                }
                              },
                              onFieldSubmitted: (value) {
                                // value = '${countryFlag.value}$value';
                                log('on Submit text value: $value');

                                if (widget.onFieldSubmitted != null) {
                                  widget.onFieldSubmitted!(value);
                                }
                              },
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(height: showDropdown.value ? 8.0 : 0),

                // Get error message from formState and display if any.
                Visibility(
                  visible: state.hasError,
                  child: Text(
                    state.errorText ??  "Error Message",
                    style: const TextStyle(color: Colors.red),
                  ),
                ),

                // dropdown list
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
                        // dropdown search field
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

                        // country listview
                        Expanded(
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: countries.value.length,
                            itemBuilder: (context, index) {
                              return ListTile(
                                leading: Text.rich(
                                    TextSpan(
                                        children: [
                                          TextSpan(
                                            text: "${countries.value[index]['flag']} ",
                                            style: const TextStyle(fontSize: 20),
                                          ),
                                          TextSpan(
                                            text: "${countries.value[index]['name']} (${countries.value[index]['dial_code']})",
                                          ),
                                        ]
                                    )
                                ),
                                onTap: () {
                                  countryFlag.value = countries.value[index]['flag']!;
                                  widget.controller!.text = countries.value[index]['dial_code']!;

                                  showDropdown.value = !showDropdown.value;
                                  countries.value = CountriesConstant.allCountries;
                                },
                                trailing: Visibility(
                                  visible: countries.value[index]['flag']! == countryFlag.value,
                                  child: const Icon(Icons.check_rounded),
                                ),
                              );
                            },
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            );
          }
        ),
      ),
    );
  }
}
