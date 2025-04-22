import 'package:bmta_rfid_app/themes/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

const double defaultRadius = 8.0; // Define a default radius value

InputDecoration inputDecoration(
  BuildContext context, {
  IconData? prefixIcon,
  Widget? suffixIcon,
  String? labelText,
  double? borderRadius,
  String? hintText,
  String? nameImage,
}) {
  return InputDecoration(
    counterText: "",
    contentPadding: const EdgeInsets.only(left: 12, bottom: 10, top: 10, right: 10),
    labelText: labelText,
    labelStyle: TextStyle(color: Colors.grey, fontSize: 14), // Replace with appropriate style
    alignLabelWithHint: true,
    hintText: hintText,
    hintStyle: TextStyle(color: Colors.grey, fontSize: 12), // Replace with appropriate style
    isDense: true, // Make sure it's compact
    prefixIcon: Padding(
      padding: const EdgeInsetsDirectional.only(start: 12.0 , end: 12.0),
      child: SvgPicture.asset(
        nameImage ?? "",
        width: 10,
        height: 10,
      ),
    ),
    suffixIcon: suffixIcon,
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(borderRadius ?? defaultRadius),
      borderSide: const BorderSide(color: Colors.transparent, width: 0.0),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(borderRadius ?? defaultRadius),
      borderSide: const BorderSide(color: Colors.red, width: 0.0),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(borderRadius ?? defaultRadius),
      borderSide: const BorderSide(color: Colors.red, width: 1.0),
    ),
    errorMaxLines: 2, // Limit the error text lines
    errorStyle: TextStyle(color: Colors.red, fontSize: 12),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(borderRadius ?? defaultRadius),
      borderSide: const BorderSide(color: Colors.transparent, width: 0.0),
    ),
    filled: true,
    fillColor: Color(textFromGray600),
  );
}