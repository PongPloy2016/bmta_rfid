
import 'package:bmta_rfid_app/themes/colors.dart';
import 'package:bmta_rfid_app/themes/fontsize.dart';
import 'package:bmta_rfid_app/widgets/text/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomtitleAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomtitleAppBar(
      {super.key,
      required this.title,
      this.backgroundColor,
      this.actions,
      required this.onSuccess});

  final String title;
  final Color? backgroundColor;
  final List<Widget>? actions;
  final void Function() onSuccess;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      backgroundColor: const Color(headerColor),
      title: CustomText(
        title,
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.titleLarge!.copyWith(
              fontWeight: fontBold,
              fontSize: fontSize2_Title.sp,
              color: Color(accidentTextColor),
            ),
      ),
      centerTitle: true,
      automaticallyImplyLeading: false,
      // leading: IconButton(
      //   icon: const Icon(Icons.keyboard_arrow_left),
      //   onPressed: () => {onSuccess.call()},
      // ),

      // leading: null, // ซ่อนปุ่ม Back

      actions: actions,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
