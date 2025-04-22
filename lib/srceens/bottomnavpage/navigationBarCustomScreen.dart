import 'package:bmta_rfid_app/srceens/equipmentDetail/equipmentDetailScreen.dart';
import 'package:bmta_rfid_app/srceens/equipmentList/equipmentListScreen.dart';
import 'package:bmta_rfid_app/srceens/mainPage/main_screen.dart';
import 'package:bmta_rfid_app/srceens/serachFindProperty/serach_find_property_screen.dart';
import 'package:bmta_rfid_app/srceens/serachSupplies/serach_supplise_sreen.dart';
import 'package:bmta_rfid_app/widgets/bottomAppBarCustom/fab_bottom_app_bar.dart';
import 'package:bmta_rfid_app/widgets/bottomAppBarCustom/fab_with_icons.dart';
import 'package:bmta_rfid_app/widgets/bottomAppBarCustom/layout.dart';
import 'package:flutter/material.dart';

class NavigationBarCustomScreen extends StatefulWidget {
  const NavigationBarCustomScreen({super.key});

  @override
  _NavigationBarCustomScreenState createState() => _NavigationBarCustomScreenState();
}

class _NavigationBarCustomScreenState extends State<NavigationBarCustomScreen> with TickerProviderStateMixin {
  String _lastSelected = 'TAB: 0';

  late TabController _tabController;

  // Initialize TabController in initState
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  void _selectedTab(int index) {
    setState(() {
      _lastSelected = 'TAB: $index';
      _tabController.index = index;
    });
  }

  void _selectedFab(int index) {
  
    setState(() {
      _lastSelected = 'FAB: $index';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text("title"),
      // ),
      body: TabBarView(
        controller: _tabController,
        physics: const NeverScrollableScrollPhysics(),
        children:  [
         
          MainPageScreen(),
           SerachSuppliseSreen(),
          EquipmentListScreen(),
          EquipmentDetailScreen(),
           SerachFindPropertyScreen(),
        ],
      ),
      bottomNavigationBar: FABBottomAppBar(
        centerItemText: '',
        color: Colors.grey,
        selectedColor: Colors.red,
        notchedShape: const CircularNotchedRectangle(),
        onTabSelected: _selectedTab,
        items: [
          FABBottomAppBarItem(iconData: Icons.menu, text: 'This'),
          FABBottomAppBarItem(iconData: Icons.layers, text: 'Is'),
          FABBottomAppBarItem(iconData: Icons.dashboard, text: 'Bottom'),
          FABBottomAppBarItem(iconData: Icons.info, text: 'Bar'),
        ],
        height: 60,
        iconSize: 24,
        backgroundColor: Colors.black12,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: _buildFab(context),
    );
  }

  Widget _buildFab(BuildContext context) {
    final icons = [Icons.sms, Icons.mail, Icons.phone];
    return AnchoredOverlay(
      showOverlay: true,
      overlayBuilder: (context, offset) {
        return CenterAbout(
         // position: Offset(offset.dx, offset.dy - icons.length * 35.0),
          child: FabWithIcons(
            icons: icons,
            onIconTapped: _selectedFab,
          ),
        );
      },
      child: FloatingActionButton(
        onPressed: () {
          _selectedFab(2);
          _tabController.index = 2;
          setState(() {
            _lastSelected = 'FAB: 2';
          });
         
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
        //elevation: 2.0,
      ),
    );
  }
}