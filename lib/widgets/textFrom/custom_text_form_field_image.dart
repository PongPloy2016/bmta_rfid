
import 'package:flutter/material.dart';


class CustomTextFormFieldImage extends StatelessWidget {
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
  final String? nameImageView;
  final void Function()? onClickImage;


  const CustomTextFormFieldImage({
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
    this.nameImageView,
    this.onClickImage,
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

    return Row(
      children: [
        Expanded(
          child: Container(
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
          ),
        ),
        GestureDetector(
          onTap: () {
          
              onClickImage?.call();
            
          },
          child: SizedBox(
              width: 50,
              height: 50,
              child: Image.asset(
                  fit: BoxFit.fill,
                  nameImageView ?? "lib/assets/images/ic_icon_manu_rfid_search.png",
                  width: 50,
                  height: 50,
                  scale: 2)
              //     SvgPicture.asset(
              //   "lib/assets/images/ic_icon_manu_rfid_search.svg",
              //   width: 10,
              //   height: 10,
              // ),
              ),
        ),
      ],
    );
  }
}
