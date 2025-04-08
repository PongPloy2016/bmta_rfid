import 'package:bmta/themes/fontsize.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomTextDefault extends StatelessWidget {
  final String? text;
  final TextStyle style;
  final TextAlign? textAlign;
  final TextDirection? textDirection;
  final Locale? locale;
  final bool? softWrap;
  final TextOverflow? overflow;
  final double? textScaleFactor;
  final int? maxLines;
  final String? semanticsLabel;
  final TextWidthBasis? textWidthBasis;
  final TextHeightBehavior? textHeightBehavior;
  final Color? selectionColor;
  final FontWeight? fontWeight;

  const CustomTextDefault(
      {super.key,
      this.text,
     required this.style,
      this.textAlign,
      this.textDirection,
      this.locale,
      this.softWrap,
      this.overflow,
      this.textScaleFactor,
      this.maxLines,
      this.semanticsLabel,
      this.textWidthBasis,
      this.textHeightBehavior,
      this.selectionColor,
      this.fontWeight});

  @override
  Widget build(BuildContext context) {
    // Define a default text style.
   
    return DefaultTextStyle(
      style: style ?? TextStyle(
        fontSize: fontSize6_Detail.sp,
        color: selectionColor,
        fontWeight: fontWeight,
        overflow: overflow,
        
      ),
      child: Text(text ?? "-" 
      ,overflow: overflow,
      style: style,
      maxLines: maxLines,),
    );
  }
}