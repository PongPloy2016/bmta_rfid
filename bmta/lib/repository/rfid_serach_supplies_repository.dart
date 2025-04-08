import 'dart:convert';

import 'package:bmta/constants/authen_storage_constant.dart';
import 'package:bmta/models/auth/reqlogin.dart';
import 'package:bmta/models/auth/res_login_model.dart';
import 'package:bmta/models/equipmentItemModel/mockup_memo_model.dart';
import 'package:bmta/models/equipmentItemModel/reqMemoList.dart';
import 'package:bmta/models/memoDataClassification/memo_data_classification_model.dart';
import 'package:bmta/models/pokemon.dart';
import 'package:bmta/Interface/rfid_repo_interface.dart';
import 'package:bmta/utils/auth_utils.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:shared_preferences/shared_preferences.dart';
class RFIDSerachSuppliesRepository implements MemoDataClassificationRepoInterface {

  static final _storage = const FlutterSecureStorage();
  static final dio = Dio();


   RFIDSerachSuppliesRepository() {
    dio.interceptors.add(AuthInterceptor(dio, _storage));
  }



 // Call this function to load data from API using Dio
   // Method to get MemoDataClassification and return Future<MemoDataClassificationModel>
  Future<MemoDataClassificationModel> getMemoDataClassification(BuildContext context) async {
    try {
      // Make the GET request using Dio
      Response response = await dio.get(
        "https://bms-dev.atlasicloud.com/api/rfid/AlertMemoMaster/GetMemoDataClassification",
      );

      if (response.statusCode == 200) {
        // Parse the response into the model
        MemoDataClassificationModel memoResponse = MemoDataClassificationModel.fromJson(response.data);

        if (memoResponse.isSuccess) {
          // If the response is successful, return the model
          return memoResponse;
        } else {
          // If the API indicates failure, show error dialog and return null
          _showErrorDialog('ไม่สามารถโหลดข้อมูลประเภทหนังสือ',context);
           return Future.error('Failed to load memos: ${response.statusCode}');
        }
      } else {
        // If the response status code is not 200, show an error dialog and return null
        _showErrorDialog('ผิดพลาด: ${response.statusCode}',context);
         return Future.error('Failed to load memos: ${response.statusCode}');
      }
    } catch (e) {
      // Catch any exceptions (e.g., network issues) and show an error dialog
      _showErrorDialog('เกิดข้อผิดพลาดในการโหลดข้อมูล',context);
       return Future.error('Failed to load memos: ${e.toString()}');
    }
  }

   // Show error dialog
  void _showErrorDialog(String message ,BuildContext  context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('ผิดพลาด'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }
}