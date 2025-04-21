import 'dart:convert';
import 'dart:async'; // ใช้ Completer และ Future
import 'dart:collection'; // ใช้ Queue
import 'dart:io';

import 'package:bmta/Interface/rfid_repo_interface.dart';
import 'package:bmta/app_config.dart';
import 'package:bmta/constants/authen_storage_constant.dart';
import 'package:bmta/main.dart';
import 'package:bmta/models/auth/reqlogin.dart';
import 'package:bmta/srceens/login/login_screen.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:async/async.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:package_info_plus/package_info_plus.dart'; // Import package_info_plus
import 'package:url_launcher/url_launcher.dart'; // Import url_launcher for opening links

class AuthInterceptor extends Interceptor {
  final Dio _dio;
  final FlutterSecureStorage _storage;
  late AuthRepoInterface repository;

  // 🔥 Global Queue สำหรับจัดคิว error handling
  static final Queue<Completer<void>> _errorQueue = Queue();

  AuthInterceptor(this._dio, this._storage);

  static Timer? _timer;
  static int _startTimerLatestAction = 0;
  static const int _timerLogout = 600; // Use const for immutable values
  static bool _isShowingDialog = false;

  void performLatestAction() {
    _timer?.cancel();
    _startTimerLatestAction = _timerLogout;

    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(oneSec, (Timer timer) async {
      final employeeId = await _storage.read(key: AuthStorage.employeeId);
      if (employeeId == null) {
        timer.cancel();
        print('Employee ID is null, ignoring idle auto logout.');
        return;
      }
      if (_startTimerLatestAction == 0) {
        timer.cancel();
        print('Last action timer ended. Idle auto logging out...');

        navigatorKey.currentState?.pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const LoginScreen()),
          (route) => false,
        );
      } else {
        _startTimerLatestAction--;
        if ((_startTimerLatestAction % 10) == 0 || _startTimerLatestAction <= 10) {
          print('Idle auto logout in : $_startTimerLatestAction seconds');
        }
      }
    });

    print('Last action timer started at. $_startTimerLatestAction seconds');
  }

  Future<bool> _isConnected() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    return connectivityResult != ConnectivityResult.none;
  }

  @override
  Future<void> onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    if (!await _isConnected()) {
      print('❌ No internet connection!');
      // showErrorDialog(
      //   navigatorKey.currentContext!,
      //   'ไม่พบการเชื่อมต่ออินเทอร์เน็ต',
      //   onSubmitted: () => null,
      // );
    }
    final accessToken = await _storage.read(key: AuthStorage.token);
    performLatestAction();
    if (accessToken != null) {
      options.headers['Authorization'] = 'Bearer $accessToken';
    }

    // Add app version and platform headers
    final packageInfo = await PackageInfo.fromPlatform();
    options.headers['X-APP-VERSION'] = packageInfo.version;
    options.headers['X-APP-PLATFORM'] =
        kIsWeb
            ? 'web'
            : defaultTargetPlatform == TargetPlatform.android
            ? 'android'
            : defaultTargetPlatform == TargetPlatform.iOS
            ? 'ios'
            : 'unknown'; // Use defaultTargetPlatform to determine the platform

    print('🔄 Request headers: ${options.headers}');
    handler.next(options); // Removed unnecessary return statement
  }

  Future<void> logout() async {
    try {
      print('Token is null, logging out...');

      navigatorKey.currentState?.pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const LoginScreen()),
        (route) => false,
      );
    } catch (e) {
      print('Error during logout: $e');
    }
  }

  Future<void> closeApp() async {
    if (TargetPlatform.android == defaultTargetPlatform) {
      SystemNavigator.pop();
    } else if (TargetPlatform.iOS == defaultTargetPlatform) {
      exit(0);
    }
  }

  @override
Future<void> onError(DioException err, ErrorInterceptorHandler handler) async {
  final context = navigatorKey.currentContext;
  if (context != null) {
    repository = AppConfig.of(context)!.authRepo;
  } else {
    print('❌ No context available for AppConfig');
    return;
  }

  if (!await _isConnected()) {
    print('❌ No internet connection!');
  }

  final completer = Completer<void>();
  _errorQueue.add(completer);
  print('🔄 Error queue length (before wait): ${_errorQueue.length}');

  if (_errorQueue.length > 1) {
    await _errorQueue.elementAt(_errorQueue.length - 2).future;
  }

  // Check if response is not null and has data
  if (err.response?.data != null) {
   // print('error response: ${err.response?.data['Message'] ?? 'No message available'}');
    print('error response No message available');
  } else {
    print('error response: No data available');
  }

  bool retrySuccess = false;
  try {
    final accessToken = await _storage.read(key: AuthStorage.token);

    // Check if tokens are missing
    if (accessToken == null) {
      print("❌ Missing access or refresh token!");
      return handler.next(err); // Handle error if tokens are missing
    }

    // Handle 401 Unauthorized - Refresh token logic
    if (err.response?.statusCode == 401) {
      print("🔄 Refreshing token...");

      try {
        // Attempt to refresh the token
        final refreshToken = await _storage.read(key: AuthStorage.refreshTokenKey);
        if (refreshToken != null) {
          final response = await repository.getLoginUser(Reqlogin(username: "Admin", password: "Admin2024"));
          if (response.isSuccess!) {
            retrySuccess = true; // Token refreshed successfully
            final newAccessToken = response.data?.token; // Assuming this is the new token

            // Save the new token
            await _storage.write(key: AuthStorage.token, value: newAccessToken);

            // Retry the original request with the new token
            final options = err.response?.requestOptions;
            options?.headers['Authorization'] = 'Bearer $newAccessToken';
            final retryResponse = await Dio().request(
              options?.path ?? '',
              options: Options(
                method: options?.method,
                headers: options?.headers,
              ),
            );
            handler.resolve(retryResponse); // Resolve the retry response
            return;
          }
        }
      } catch (e) {
        print("❌ Error refreshing token: $e");
      }
    }

    // Handle other errors like 503, 426, 404
    else if (err.response?.statusCode == 503) {
      print("❌ Service Unavailable (503): ${err.response?.data?['Message'] ?? 'Service unavailable'}");
      if (_isShowingDialog) return;
      _isShowingDialog = true;
      showErrorDialog(
        navigatorKey.currentContext!,
        err.response?.data?['Message'] ?? 'Service unavailable',
        onSubmitted: () async {
          await closeApp();
          _isShowingDialog = false;
        },
      );
      return;
    } else if (err.response?.statusCode == 426) {
      print("❌ Upgrade Required (426): ${err.response?.data ?? 'Upgrade required'}");
      if (_isShowingDialog) return;
      _isShowingDialog = true;
      showErrorDialog(
        navigatorKey.currentContext!,
        err.response?.data?['Message'] ?? 'Upgrade required',
        onSubmitted: () async {
          var url = err.response?.data?['Data']?['StoreUrl']; // Specify the update link
          if (url != null && await canLaunchUrl(Uri.parse(url))) {
            await launchUrl(Uri.parse(url));
            await closeApp();
          } else {
            print('Could not launch $url');
          }
          _isShowingDialog = false;
        },
      );
      return;
    } else if (err.response?.statusCode == 404) {
      print("❌ Service Unavailable (404): ${err.response?.data?['Message'] ?? 'Service unavailable'}");
      if (_isShowingDialog) return;
      _isShowingDialog = true;
      showErrorDialog(
        navigatorKey.currentContext!,
        err.response?.data?['message'] ?? 'Service unavailable',
        onSubmitted: () async {
          navigatorKey.currentState?.pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => const LoginScreen()),
            (route) => false,
          );
          _isShowingDialog = false;
        },
      );
      return;
    } else {
      print("❌ Error ${err.response?.statusCode}: ${err.message}");
      return handler.next(err); // Pass the error to the next handler
    }
  } catch (e) {
    print("❌ Error in onError: $e");
  } finally {
    if (!completer.isCompleted) {
      print('✅ Completing error queue task...');
      completer.complete();
    } else {
      print('⚠ Completer already completed!');
    }

    _errorQueue.remove(completer);
    print('✅ Error queue processed, remaining: ${_errorQueue.length}');
  }

  if (!retrySuccess) {
    handler.next(err);
    print("🔄 handler.next() executed.");
  }
}

  //   @override
  // Future<void> onError(
  //   DioException err, ErrorInterceptorHandler handler) async {

  //      final context = navigatorKey.currentContext;
  //   if (context != null) {
  //     repository = AppConfig.of(context)!.authRepo;
  //   } else {
  //     print('❌ No context available for AppConfig');
  //     return;
  //   }

  //   if (!await _isConnected()) {
  //     print('❌ No internet connection!');
  //     // Optionally show dialog for no internet connection
  //     // showErrorDialog(
  //     //   navigatorKey.currentContext!,
  //     //   'ไม่พบการเชื่อมต่ออินเทอร์เน็ต',
  //     //   onSubmitted: () => null,
  //     // );
  //   }

  //   final completer = Completer<void>();
  //   _errorQueue.add(completer);
  //   print('🔄 Error queue length (before wait): ${_errorQueue.length}');

  //   if (_errorQueue.length > 1) {
  //     await _errorQueue.elementAt(_errorQueue.length - 2).future;
  //   }

  //   // Check if response is not null and has data
  //   if (err.response?.data != null) {
  //     print('error response: ${err.response?.data['Message'] ?? 'No message available'}');
  //   } else {
  //     print('error response: No data available');
  //   }

  //   bool retrySuccess = false;
  //   try {
  //     final accessToken = await _storage.read(key: AuthStorage.token);
  //     final refreshToken = await _storage.read(key: AuthStorage.refreshTokenKey);

  //     if (err.response?.statusCode == 401 && refreshToken != null) {
  //       print("🔄 Refreshing token...");

  //       try {
  //         final response = await repository.getLoginUser(
  //           Reqlogin(username: "Admin", password: "Admin2024"),
  //         );

  //         if (response.isSuccess) {
  //           retrySuccess = true; // Token refreshed successfully
  //           return;
  //         }
  //       } catch (e) {
  //         print("❌ Error refreshing token: $e");
  //       }

  //     } else if (err.response?.statusCode == 503) {
  //       print("❌ Service Unavailable (503): ${err.response?.data?['Message'] ?? 'Service unavailable'}");
  //       if (_isShowingDialog) return;
  //       _isShowingDialog = true;
  //       showErrorDialog(
  //         navigatorKey.currentContext!,
  //         err.response?.data?['Message'] ?? 'Service unavailable',
  //         onSubmitted: () async {
  //           await closeApp();
  //           _isShowingDialog = false;
  //         },
  //       );
  //       return;
  //     } else if (err.response?.statusCode == 426) {
  //       print("❌ Upgrade Required (426): ${err.response?.data ?? 'Upgrade required'}");
  //       if (_isShowingDialog) return;
  //       _isShowingDialog = true;
  //       showErrorDialog(
  //         navigatorKey.currentContext!,
  //         err.response?.data?['Message'] ?? 'Upgrade required',
  //         onSubmitted: () async {
  //           var url = err.response?.data?['Data']?['StoreUrl']; // Specify the update link
  //           if (url != null && await canLaunchUrl(Uri.parse(url))) {
  //             await launchUrl(Uri.parse(url));
  //             await closeApp();
  //           } else {
  //             print('Could not launch $url');
  //           }
  //           _isShowingDialog = false;
  //         },
  //       );
  //       return;
  //     }
  //     else if (err.response?.statusCode == 404) {
  //       print("❌ Service Unavailable (503): ${err.response?.data?['Message'] ?? 'Service unavailable'}");
  //       if (_isShowingDialog) return;
  //       _isShowingDialog = true;
  //       showErrorDialog(
  //         navigatorKey.currentContext!,
  //         err.response?.data?['message'] ?? 'Service unavailable',
  //         onSubmitted: () async {
  //          // await closeApp();
  //           navigatorKey.currentState?.pushAndRemoveUntil(
  //             MaterialPageRoute(builder: (context) => const LoginScreen()),
  //             (route) => false,
  //           );
  //           _isShowingDialog = false;
  //         },
  //       );
  //       return;
  //     }

  //      else {
  //          print("❌ Error ${err.response?.statusCode}: ${err.message}");
  //       return handler.next(err); // Pass the error to the next handler

  //     }
  //   } catch (e) {
  //     print("❌ Error in onError: $e");
  //   } finally {
  //     if (!completer.isCompleted) {
  //       print('✅ Completing error queue task...');
  //       completer.complete();
  //     } else {
  //       print('⚠ Completer already completed!');
  //     }

  //     _errorQueue.remove(completer);
  //     print('✅ Error queue processed, remaining: ${_errorQueue.length}');
  //   }

  //   if (!retrySuccess) {
  //     handler.next(err);
  //     print("🔄 handler.next() executed.");
  //   }
  // }

  Future<Map<String, dynamic>> getEmployeeInfo() async {
    final empId = await _storage.read(key: AuthStorage.empIdKey);
    final userId = await _storage.read(key: AuthStorage.idKey);
    final isLoggedIn = await _storage.read(key: AuthStorage.isLoggedInKey);

    final userInfoData = await _storage.read(key: AuthStorage.userInfo);
    if (userInfoData != null) {
      return jsonDecode(userInfoData) as Map<String, dynamic>;
    }
    return {};
  }

  void showErrorDialog(BuildContext context, String message, {Function()? onSubmitted}) {
    if (navigatorKey.currentContext != null) {
      QuickAlert.show(
        context: navigatorKey.currentContext!,
        type: QuickAlertType.error,
        title: 'แจ้งเตือน',
        text: message,
        confirmBtnText: 'ตกลง',
        onConfirmBtnTap: () => onSubmitted?.call(),
      ).then((value) {
        print('Error dialog closed.');
        onSubmitted?.call();
      });
    }
  }
}
