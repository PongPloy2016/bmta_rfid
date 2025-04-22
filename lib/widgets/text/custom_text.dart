
import 'package:bmta_rfid_app/themes/fontsize.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// fontSizeDefaultDetail20

class CustomText extends Text {
  CustomText(
    super.data, {
    super.key,
    TextStyle? style,
    super.strutStyle,
    super.textAlign,
    super.textDirection,
    super.locale,
    super.softWrap,
    super.overflow,
    super.textScaleFactor,
    super.textScaler,
    super.maxLines,
    super.semanticsLabel,
    super.textWidthBasis,
    super.textHeightBehavior,
    super.selectionColor,
  }) : super(
          style:
              TextStyle(fontSize: fontSize6_Detail.sp ,color: selectionColor).merge(style),
        );
}
