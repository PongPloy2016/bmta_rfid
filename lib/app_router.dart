
import 'package:bmta_rfid_app/mainRfid.dart';
import 'package:bmta_rfid_app/srceens/bottomnavpage/navigationBarCustomScreen.dart';
import 'package:bmta_rfid_app/srceens/equipmentDetail/equipmentDetailScreen.dart';
import 'package:bmta_rfid_app/srceens/equipmentList/equipmentListScreen.dart';
import 'package:bmta_rfid_app/srceens/login/login_screen.dart';
import 'package:bmta_rfid_app/srceens/bottomnavpage/navigationBarScreen.dart';
import 'package:bmta_rfid_app/srceens/mapingTagRfid/Mapping_tag_Rfid.dart';
import 'package:bmta_rfid_app/srceens/propertyList/property_listing_screen.dart';
import 'package:bmta_rfid_app/srceens/scanPage/scanPage.dart';
import 'package:bmta_rfid_app/srceens/serachFindProperty/serach_find_property_screen.dart';
import 'package:bmta_rfid_app/srceens/serachRFID/search_Rfid_screen.dart';
import 'package:bmta_rfid_app/srceens/serachSupplies/serach_supplise_sreen.dart';

class AppRouter {

  // Router Map Key

  static const String login = '/';
  static const String serachSupplies = 'serachSupplies';
  static const String forgotPassword = 'forgotPassword';
  static const String navigationBar = 'navigationBar';
  static const String navigationBarCustoms = 'navigationBarCustoms';
  static const String equipmentList = 'equipmentList';
  static const String equipmentDetail = 'equipmentDetail';
  static const String serachFindProperty = 'serachFindProperty';
  static const String serachSupplise = 'serachSupplise';
  static const String propertyList = 'propertyList';
  static const String mappingTagRfid = 'mappingTagRfid';
  static const String searchRfid = 'searchRfid';
  static const String mainRFID = 'mainRFID';
  static const String scanPage = 'scanPage';


  // Router Map
  static get routes => {
    // welcome: (context) => WelcomeScreen(),
    login: (context) => LoginScreen(),
    serachSupplies: (context) => SerachSuppliseSreen(),

    // forgotPassword: (context) => ForgotPasswordScreen(),
    navigationBar: (context) => NavigationBarScreen(),
    navigationBarCustoms: (context) => NavigationBarCustomScreen(),
    equipmentList: (context) => EquipmentListScreen(),
    equipmentDetail: (context) => EquipmentDetailScreen(),
    serachFindProperty: (context) => SerachFindPropertyScreen(),
    serachSupplise: (context) => SerachSuppliseSreen(),
    propertyList: (context) => PropertyListingScreen(),
    searchRfid: (context) => SearchRfidScreen(),
    mappingTagRfid: (context) => MappingTagRfidScreen(data: MemoItem(memoCode: '', subject: '')),
    mainRFID: (context) => MainRfid(),
    scanPage: (context) => ScanPage(),

  
  };

}