import 'package:bmta/themes/colors.dart';
import 'package:bmta/themes/fontsize.dart';
import 'package:bmta/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


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
  final InputDecoration inputDecoration;

  const CustomTextFormField({
    Key? key,
    this.controller,
    this.labelText,
    this.hintText,
    this.prefixIcon,
    this.keyboardType,
    this.suffixIcon,
    this.obscureText = false,
    this.validator,
    this.onFieldSubmitted,
    required this.inputDecoration,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.fromLTRB(10, 3, 20, 0),
      margin: EdgeInsets.only(left: 5, right: 5),
      height: 50,
      child: Row(
        children: [
          Expanded(
            child: 
            TextFormField(
              controller: controller,
              obscureText: obscureText,
              keyboardType: keyboardType,
              validator: validator,
              onFieldSubmitted: onFieldSubmitted,
              decoration: inputDecoration,
              style: TextStyle(color: Colors.black),
            ),
          ),
        ],
      ),
    );
  }
}