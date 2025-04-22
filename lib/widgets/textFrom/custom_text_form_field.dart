import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
  final TextEditingController? controller;
  final String? labelText;
  final String? hintText;
  final IconData? prefixIcon;
  final TextInputType? keyboardType;
  final Widget? suffixIcon;
  final bool obscureText;
  final String? Function(String?)? validator;
  final void Function(String)? onFieldSubmitted;
  final InputDecoration? inputDecoration;

  const CustomTextFormField({
    super.key,
    this.controller,
    this.labelText,
    this.hintText,
    this.prefixIcon,
    this.keyboardType,
    this.suffixIcon,
    this.obscureText = false,
    this.validator,
    this.onFieldSubmitted,
    this.inputDecoration,
  });

  @override
  Widget build(BuildContext context) {
    // Creating a default InputDecoration if inputDecoration is not passed.
    InputDecoration finalDecoration = inputDecoration ??
        InputDecoration(
          labelText: labelText,
          hintText: hintText,
          prefixIcon: prefixIcon != null ? Icon(prefixIcon) : null,
          suffixIcon: suffixIcon,
        );

    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.fromLTRB(10, 3, 20, 0),
      margin: const EdgeInsets.only(left: 5, right: 5),
      //height: 50,
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        keyboardType: keyboardType,
        validator: validator,
        onFieldSubmitted: onFieldSubmitted,
        decoration: finalDecoration,
        style: const TextStyle(color: Colors.black),
      ),
    );
  }
}