import 'package:bmta/srceens/equipmentDetail/equipmentDetailScreen.dart';
import 'package:bmta/srceens/equipmentList/equipmentListScreen.dart';
import 'package:bmta/srceens/mainPage/main_screen.dart';
import 'package:bmta/srceens/serachSupplies/serach_supplise_sreen.dart';
import 'package:bmta/themes/colors.dart';
import 'package:bmta/themes/fontsize.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import 'package:flutter_localizations/flutter_localizations.dart';
class NavigationBarScreen extends StatefulWidget {
  const NavigationBarScreen({super.key});

  @override
  State<NavigationBarScreen> createState() => _NavigationBarScreenState();
}

class _NavigationBarScreenState extends State<NavigationBarScreen>
    with WidgetsBindingObserver, TickerProviderStateMixin {
  late TabController _tabController;
  final int lengthTap = 5;

  TabController getTabController() {
    return TabController(length: lengthTap, vsync: this);
  }

  @override
  void initState() {
    super.initState();
    _tabController = getTabController();
  }

  @override
  Widget build(BuildContext context) {
    // final t = AppLocalizations.of(context);

    return DefaultTabController(
      length: lengthTap,
      child: Scaffold(
        body: TabBarView(
          physics: const NeverScrollableScrollPhysics(),
          controller: _tabController,
          children: const [
            MainPageScreen(),
            // SerachSuppliseSreen(),
            EquipmentListScreen(),
            EquipmentDetailScreen(),
          
          ],
        ),
      
        bottomNavigationBar: BottomNavigationBar(
          
          selectedItemColor: const Color(textColor),
          unselectedItemColor: const Color(0xcc374151),
          selectedLabelStyle: TextStyle(fontSize: fontSize8_Overline.sp),
          unselectedLabelStyle: TextStyle(fontSize: fontSize8_Overline.sp),
          showSelectedLabels: true,
          showUnselectedLabels: true,
          selectedFontSize: fontSize7_Caption.sp,
          unselectedFontSize: fontSize7_Caption.sp,
          currentIndex: _tabController.index,
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
          onTap: (index) {
            setState(() {
              _tabController.index = index;
            });
          },
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              activeIcon: SvgPicture.asset(
                  'lib/assets/icons/home_active_icon.svg',
                  width: 24.w,
                  height: 24.h),
              icon: SvgPicture.asset('lib/assets/icons/home_icon.svg',
                  width: 24.w, height: 24.h),
              label: 'หน้าหลัก',
            ),
            BottomNavigationBarItem(
              activeIcon: SvgPicture.asset(
                  'lib/assets/icons/bus_active_icon.svg',
                  width: 24.w,
                  height: 24.h),
              icon: SvgPicture.asset('lib/assets/icons/bus_icon.svg',
                  width: 24.w, height: 24.h),
              label: 'รายการเดินรถ',
            ),
            BottomNavigationBarItem(
              activeIcon: SvgPicture.asset(
                  'lib/assets/icons/fare_payment_menu_active_icon.svg',
                  width: 24.w,
                  height: 24.h),
              icon: SvgPicture.asset(
                  'lib/assets/icons/fare_payment_menu_icon.svg',
                  width: 24.w,
                  height: 24.h),
              label: 'ประวัติธุรกรรม',
            ),
            BottomNavigationBarItem(
              activeIcon: SvgPicture.asset(
                  'lib/assets/icons/accident_active_icon.svg',
                  width: 24.w,
                  height: 24.h),
              icon: SvgPicture.asset('lib/assets/icons/accident_icon.svg',
                  width: 24.w, height: 24.h),
              label: 'อุบัติเหตุ',
            ),
            BottomNavigationBarItem(
              activeIcon: SvgPicture.asset(
                  'lib/assets/icons/profile_menu_active_icon.svg',
                  width: 24.w,
                  height: 24.h),
              icon: SvgPicture.asset('lib/assets/icons/profile_menu_icon.svg',
                  width: 24.w, height: 24.h),
              label: 'ฉัน',
            ),
          ],
        ),
      ),
    );
  }
}
