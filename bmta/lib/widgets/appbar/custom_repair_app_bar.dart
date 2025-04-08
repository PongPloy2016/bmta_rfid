
import 'package:bmta/themes/fontsize.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomRepairAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomRepairAppBar({
    super.key,
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
      title: Text(
        title,
        style: Theme.of(context).textTheme.titleLarge!.copyWith(
            fontWeight: fontBold,
            fontFamily: fontFamily,
            fontSize: fontSize2_Title.sp,
            height: 1.6.h,
            color: Colors.black),
      ),
      centerTitle: true,
      leading: IconButton(
        icon: const Icon(Icons.keyboard_arrow_left),
        onPressed: () =>
         onSuccess.call(),
      ),
      backgroundColor: backgroundColor,
      actions: actions,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
