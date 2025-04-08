import 'dart:ui';

import 'package:bmta/app_config.dart';
import 'package:bmta/app_router.dart';
import 'package:bmta/constants/authen_storage_constant.dart';
import 'package:bmta/repository/rfid_auth_repository.dart';
import 'package:bmta/repository/rfid_meno_list_repository.dart';
import 'package:bmta/repository/rfid_repository.dart';
import 'package:bmta/srceens/bottomnavpage/navigationBarScreen.dart';
import 'package:bmta/srceens/detail_page.dart';
import 'package:bmta/srceens/equipmentList/equipmentListScreen.dart';
import 'package:bmta/srceens/login/login_screen.dart';
import 'package:bmta/srceens/mainPage/main_screen.dart';
import 'package:bmta/srceens/serachSupplies/serach_supplise_sreen.dart';
import 'package:bmta/themes/custom_theme.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:month_year_picker/month_year_picker.dart';
import 'package:zebra_rfid_reader_sdk/zebra123.dart';
import 'generated/l10n.dart'; // Import the generated file

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();


Future<void> main() async {
    WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: '.env');
  runApp( AppConfig(
       rfidRepo: RFIDRepository(),
    authRepo : RFIDAuthRepository(),
        listhRepo: RFIDMenoListRepository(),
        
        child:  MyApp()
    ));
}



enum Views { list, write }

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}


class _MyAppState extends State<MyApp> {
  late Future<Map<String, dynamic>> _loginStatus;

  @override
  void initState() {
    super.initState();
    _loginStatus = hasLoggedIn(); // ตรวจสอบสถานะการล็อกอิน
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isTablet = constraints.maxWidth >= 600;

        return ScreenUtilInit(
          designSize: isTablet ? const Size(600, 800) : const Size(375, 812),
          minTextAdapt: true,
          builder: (context, child) {
            double textScaleFactor = MediaQuery.of(context).textScaleFactor;
            if (textScaleFactor > 1.125) {
              textScaleFactor = 1.125;
            }

            return FutureBuilder<Map<String, dynamic>>(
              future: _loginStatus,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(color: Colors.blue),
                  );
                }

                if (snapshot.hasError) {
                  debugPrint("Error in FutureBuilder: ${snapshot.error}");
                  return SafeArea(
                    child: Center(
                      child: Text('Error: ${snapshot.error}'),
                    ),
                  );
                }

                final data = snapshot.data ?? {'isLoggedIn': false, 'userId': null};
                final initialRoute = data['isLoggedIn'] == true ? AppRouter.navigationBar : AppRouter.login;

                return MaterialApp(
                  navigatorKey: navigatorKey,
                  theme: customTheme,
                  initialRoute: initialRoute,
                  routes: AppRouter.routes,
                  localizationsDelegates: const [
                    GlobalMaterialLocalizations.delegate,
                    GlobalWidgetsLocalizations.delegate,
                    GlobalCupertinoLocalizations.delegate,
                    MonthYearPickerLocalizations.delegate,
                  ],
                  supportedLocales: const [
                    Locale('th', ''),
                    Locale('en', ''),
                  ],
                  builder: (context, child) {
                    return MediaQuery(
                      data: MediaQuery.of(context).copyWith(textScaleFactor: textScaleFactor),
                      child: child!,
                    );
                  },
                );
              },
            );
          },
        );
      },
    );
  }


  /// ฟังก์ชันตรวจสอบสถานะการล็อกอิน
Future<Map<String, dynamic>> hasLoggedIn() async {
  const storage = FlutterSecureStorage();
  try {
    final empId = await storage.read(key: AuthStorage.empIdKey);
    final userId = await storage.read(key: AuthStorage.idKey);
    final isLoggedIn = await storage.read(key: AuthStorage.isLoggedInKey);

    return {
      'isLoggedIn':
      //  empId?.isNotEmpty == true &&
      //     isLoggedIn?.isNotEmpty == true &&
          isLoggedIn == 'true',
     // 'userId': userId,
    };
  } catch (e) {
    debugPrint("Error checking login status: $e");
    return {'isLoggedIn': false, 'userId': null};
  }
}

}
