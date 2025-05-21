import 'package:bmta_rfid_app/app_config.dart';
import 'package:bmta_rfid_app/app_router.dart';
import 'package:bmta_rfid_app/constants/authen_storage_constant.dart';
import 'package:bmta_rfid_app/repository/rfid_auth_repository.dart';
import 'package:bmta_rfid_app/repository/rfid_meno_list_repository.dart';

import 'package:bmta_rfid_app/themes/custom_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:month_year_picker/month_year_picker.dart';
import 'package:permission_handler/permission_handler.dart';
// Import the generated file

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(ProviderScope(
    child: AppConfig(
        authRepo: RFIDAuthRepository(),
        listhRepo: RFIDMenoListRepository(),
        child: const MyApp()),
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
    requestPermission(); // ขอสิทธิ์ Bluetooth
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isTablet = constraints.maxWidth >= 600;

        return ScreenUtilInit(
          designSize: isTablet ? const Size(480, 854) : const Size(480, 854),
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
                  return const Center(
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

                final data =
                    snapshot.data ?? {'isLoggedIn': false, 'userId': null};
                final initialRoute = data['isLoggedIn'] == true
                    ? AppRouter.navigationBar
                    : AppRouter.login;

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
                      data: MediaQuery.of(context).copyWith(
                          textScaler: TextScaler.linear(textScaleFactor)),
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

  Future<void> requestPermission() async {
    final bluetooth = await Permission.bluetooth.request();
    if (bluetooth.isGranted) {
      debugPrint("Bluetooth permission granted");
    } else if (bluetooth.isDenied) {
      debugPrint("Bluetooth permission denied");
    } else if (bluetooth.isPermanentlyDenied) {
      debugPrint("Bluetooth permission permanently denied");
    }

    final bluetoothAdvertise = await Permission.bluetoothAdvertise.request();
    if (bluetoothAdvertise.isGranted) {
      debugPrint("Bluetooth Advertise permission granted");
    } else if (bluetoothAdvertise.isDenied) {
      debugPrint("Bluetooth Advertise permission denied");
    } else if (bluetoothAdvertise.isPermanentlyDenied) {
      debugPrint("Bluetooth Advertise permission permanently denied");
    }

    final bluetoothConnect = await Permission.bluetoothConnect.request();
    if (bluetoothConnect.isGranted) {
      debugPrint("Bluetooth Connect permission granted");
    } else if (bluetoothConnect.isDenied) {
      debugPrint("Bluetooth Connect permission denied");
    } else if (bluetoothConnect.isPermanentlyDenied) {
      debugPrint("Bluetooth Connect permission permanently denied");
    }

    final bluetoothScan = await Permission.bluetoothScan.request();
    if (bluetoothScan.isGranted) {
      debugPrint("Bluetooth Scan permission granted");
    } else if (bluetoothScan.isDenied) {
      debugPrint("Bluetooth Scan permission denied");
    } else if (bluetoothScan.isPermanentlyDenied) {
      debugPrint("Bluetooth Scan permission permanently denied");
    }

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
