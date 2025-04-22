import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TycheApi {
  static String? _branch;
  static int _year = 0;
  static int _month = 0;
  static String tmpFileName = "CountStock.txt";

  // Method for initializing API
  static Future<void> init() async {
    // Your initialization code here (if any)
  }

  // Method to delete file (equivalent to DeleteFile in Xamarin)
  static Future<void> deleteFile() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove(tmpFileName);
  }

  // Write the header to a file
  static Future<void> writeHead({String? head}) async {
    final prefs = await SharedPreferences.getInstance();
    head ??= '$_branch|$_year|$_month';
    prefs.setString(tmpFileName, head);
  }

  // Write details to a file
  static Future<void> writeDetail(String detail) async {
    final prefs = await SharedPreferences.getInstance();
    String? existingData = prefs.getString(tmpFileName) ?? '';
    existingData += '\n$detail';
    prefs.setString(tmpFileName, existingData);
  }

  // Checking offline and uploading data
  static Future<Return> checkOffline() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      String? fileContent = prefs.getString(tmpFileName);

      List<String> lines = fileContent!.split('\n');
      String branch = lines[0].split('|')[0];
      int year = int.parse(lines[0].split('|')[1]);
      int month = int.parse(lines[0].split('|')[2]);

      _branch = branch;
      _year = year;
      _month = month;

      // Process lines and generate the asset list
      String assetList = '';
      for (var line in lines.skip(1)) {
        var cols = line.split('|');
        if (cols.length >= 4) {
          assetList += '${cols[3]},';
        }
      }

      if (assetList.isNotEmpty) {
        assetList = assetList.substring(0, assetList.length - 1);
      } else {
        return Return(success: true, message: "ไม่พบข้อมูลที่ส่ง");
      }

      var result = await updateAssetStatus(branch, year, month, assetList);
      if (result.success) {
        showAlert("ทำการอัพเดททั้งหมด ${result.message}");
        await deleteFile();
        await writeHead();
        return Return(success: true, message: "ทำการอัพเดท ${result.message}");
      } else {
        showAlert("พบข้อผิดผลาด ${result.message}");
        return result;
      }
    } catch (e) {
      showAlert("พบข้อผิดผลาด $e");
      return Return(success: false, message: e.toString());
    }
  }

  // Call Web API to update asset status
  static Future<Return> updateAssetStatus(String branchCode, int year, int month, String itemList) async {
    try {
      final response = await http.post(
        Uri.parse('https://yourapi.com/rfid/UpdateAssetStatus'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'branchCode': branchCode,
          'year': year,
          'month': month,
          'itemlist': itemList,
        }),
      );

      if (response.statusCode == 200) {
        var responseData = json.decode(response.body);
        return Return.fromJson(responseData);
      } else {
        return Return(success: false, message: 'Error: ${response.body}');
      }
    } catch (e) {
      return Return(success: false, message: e.toString());
    }
  }

  // Show alert message using FlutterToast
  static void showAlert(String message) {
    Fluttertoast.showToast(msg: message, toastLength: Toast.LENGTH_SHORT);
  }
}

class Return {
  bool success;
  String message;

  Return({required this.success, required this.message});

  factory Return.fromJson(Map<String, dynamic> json) {
    return Return(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
    );
  }
}