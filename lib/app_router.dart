
import 'package:bmta_rfid_app/mainBarcode.dart';
import 'package:bmta_rfid_app/mainRfid.dart';
import 'package:bmta_rfid_app/srceens/TagRFIDLists/TagRFIDLists.dart';
import 'package:bmta_rfid_app/srceens/bottomnavpage/navigationBarCustomScreen.dart';
import 'package:bmta_rfid_app/srceens/equipmentDetail/equipmentDetailScreen.dart';
import 'package:bmta_rfid_app/srceens/equipmentList/equipmentListScreen.dart';
import 'package:bmta_rfid_app/srceens/login/login_screen.dart';
import 'package:bmta_rfid_app/srceens/bottomnavpage/navigationBarScreen.dart';
import 'package:bmta_rfid_app/srceens/mainPage/main_screen.dart';
import 'package:bmta_rfid_app/srceens/mapingTagRfid/Mapping_tag_Rfid.dart';
import 'package:bmta_rfid_app/srceens/notificationsPage/notifications_screen.dart';
import 'package:bmta_rfid_app/srceens/propertyListRegistrationDetails/property_list_registration_details_screen.dart';
import 'package:bmta_rfid_app/srceens/propertySetList/property_set_listing_screen.dart';
import 'package:bmta_rfid_app/srceens/scanPage/scanPage.dart';
import 'package:bmta_rfid_app/srceens/serachFindProperty/serach_find_property_screen.dart';
import 'package:bmta_rfid_app/srceens/serachRFID/search_Rfid_screen.dart';
import 'package:bmta_rfid_app/srceens/serachSupplies/serach_supplise_sreen.dart';

class AppRouter {

  // Router Map Key

  static const String login = '/';
  static const String mainPageScreen = '/mainPageScreen';
  static const String serachSupplies = 'serachSupplies';
  static const String forgotPassword = 'forgotPassword';
  static const String navigationBar = 'navigationBar';
  static const String navigationBarCustoms = 'navigationBarCustoms';
  static const String equipmentList = 'equipmentList';
  static const String equipmentDetail = 'equipmentDetail';
  static const String serachFindProperty = 'serachFindProperty';
  static const String serachSupplise = 'serachSupplise';
  static const String propertySetListListing = 'propertySetListListing';
  static const String propertyListRegistrationDetails = 'propertyListRegistrationDetails';
  static const String mappingTagRfid = 'mappingTagRfid';
  static const String searchRfid = 'searchRfid';
  static const String mainRFID = 'mainRFID';
  static const String mainBarcode = 'mainBarcode';
  static const String scanPage = 'scanPage';
  static const String tagRFIDLists = 'tagRFIDLists';
  static const String notifications = 'notifications';


  // Router Map
  static get routes => {
    // welcome: (context) => WelcomeScreen(),
    login: (context) => LoginScreen(),
    mainPageScreen: (context) => MainPageScreen(),
    serachSupplies: (context) => SerachSuppliseSreen(),
    // forgotPassword: (context) => ForgotPasswordScreen(),
    navigationBar: (context) => NavigationBarScreen(),
    navigationBarCustoms: (context) => NavigationBarCustomScreen(),
    equipmentList: (context) => EquipmentListScreen(),
    equipmentDetail: (context) => EquipmentDetailScreen(),
    serachFindProperty: (context) => SerachFindPropertyScreen(),
    serachSupplise: (context) => SerachSuppliseSreen(),
    propertySetListListing: (context) => PropertySetListListingScreen(),
    propertyListRegistrationDetails: (context) => PropertyListRegistrationDetailsScreen(),
    searchRfid: (context) => SearchRfidScreen(),
    mappingTagRfid: (context) => MappingTagRfidScreen(data: MemoItem(memoCode: '', subject: '')),
    mainRFID: (context) => MainRfid(),
    mainBarcode : (context) => MainBarcode(),
    scanPage: (context) => ScanPage(),
    tagRFIDLists: (context) => TagRFIDLists(),
    notifications: (context) =>  NotificationsScreen(),


  
  };

}