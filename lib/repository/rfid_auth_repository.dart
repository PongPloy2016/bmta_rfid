import 'dart:convert';

import 'package:bmta_rfid_app/constants/authen_storage_constant.dart';
import 'package:bmta_rfid_app/models/auth/reqlogin.dart';
import 'package:bmta_rfid_app/models/auth/res_login_model.dart';
import 'package:bmta_rfid_app/models/pokemon.dart';
import 'package:bmta_rfid_app/Interface/rfid_repo_interface.dart';
import 'package:bmta_rfid_app/utils/auth_utils.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';


class RFIDAuthRepository implements AuthRepoInterface {
  static final _storage = const FlutterSecureStorage();
  static final dio = Dio();

  RFIDAuthRepository() {
    dio.interceptors.add(AuthInterceptor(dio, _storage));
  }

  @override
  Future<ResLoginModel> getlogin() {
    // This method could fetch an existing login session or token,
    // for now, it's not implemented, so we throw an error.
    throw UnimplementedError();
  }

  @override
  Future<ResLoginModel> getLoginUser(Reqlogin reqLogin) async {
    var apiUrl = "https://bms-dev.atlasicloud.com/api/umm/auth/login";

    // Prepare the request body
    var data = {'username': reqLogin.username, 'password': reqLogin.password};

    // Set headers if necessary (like content type)
    var options = Options(
      headers: {
        'Content-Type': 'application/json',
        'X-API-KEY': dotenv.env['XAPIKey'] ?? '', // Ensure XAPIKey is properly loaded
      },
    );

    try {
      // Send POST request with Dio
      final response = await dio.post(apiUrl, data: data, options: options);

      // Handle the response
      if (response.statusCode == 200) {
        // Successful login, parse response
        var responseData = response.data;
        print('Login Successful: ${responseData['message']}');
        print('Token: ${responseData['data']?['token']}');

        final tokenData = responseData as Map<String, dynamic>;

        // Safe null check before accessing tokenData
        final token = tokenData['data']?['token'] ?? '';
        final refreshToken = tokenData['data']?['refreshToken'] ?? '';
        final user = tokenData['data']?['user'];

        // Assuming you have some storage solution to save tokens
        await _storage.write(key: AuthStorage.token, value: token);
        await _storage.write(key: AuthStorage.refreshTokenKey, value: refreshToken);
        await _storage.write(key: AuthStorage.userInfo, value: jsonEncode(user));
        await _storage.write(key: AuthStorage.isLoggedInKey, value: 'true');

        print('responseData Successful: ${jsonEncode(responseData)}');
        return ResLoginModel.fromJson(responseData); // Return the parsed response
      } else {
        // Handle error, unsuccessful response
        print('Login Failed: ${response.statusCode}');
        return Future.error('Login Failed: ${response.statusCode}');
      }
    } catch (e) {
      // Catch and handle any errors during the API request

      
      print('Error: $e.response');
      return ResLoginModel(
        isSuccess: false,
        message: 'Error: ${e.toString()}',
        data: Data(
          token: '',
          refreshToken: '',
          expiration: '',
          user: User.empty(), // Assuming you have a way to create an empty User object
        ),
      );
    }
  }
}
