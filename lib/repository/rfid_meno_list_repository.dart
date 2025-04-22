
import 'package:bmta_rfid_app/models/equipmentItemModel/mockup_memo_model.dart';
import 'package:bmta_rfid_app/models/equipmentItemModel/reqMemoList.dart';
import 'package:bmta_rfid_app/Interface/rfid_repo_interface.dart';
import 'package:bmta_rfid_app/utils/auth_utils.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class RFIDMenoListRepository implements MemoListRepoInterface {

  static final _storage = const FlutterSecureStorage();
  static final dio = Dio();


   RFIDMenoListRepository() {
    dio.interceptors.add(AuthInterceptor(dio, _storage));
  }




  @override
  Future<MockupMemoModel> getMenoList(ReqMemoList reqMemoList) async {
    // TODO: implement getMenoList
    String url =
        'https://bms-dev.atlasicloud.com/api/rfid/memo';

    // Set headers if necessary (like content type)
    var options = Options(
      headers: {
        'Content-Type': 'application/json',
      },
    );

    final queryParameters = {
        'order' : reqMemoList.order,
        'orderBy' : reqMemoList.orderBy,
        'page': reqMemoList.page,
        'limit': reqMemoList.limit,
         
      };

    try {
      // Make the GET request
      final response = await dio.get(url, options: options,queryParameters : queryParameters);

      // Check if the request was successful
      if (response.statusCode == 200) {
        // Parse the response body into the MockupMemoModel
        var memoResponse = MockupMemoModel.fromJson(response.data);

        // Handle the parsed data (for example, print the response data)
        print('Total Memos: ${memoResponse.data.total}');
        print('First Memo Code: ${memoResponse.data.data[0].memoCode}');

        return memoResponse;
      } else {
        // Handle error response
        return Future.error('Failed to load memos: ${response.statusCode}');
      }
    } catch (e) {
      // Handle any exceptions that occur during the request
      return Future.error('Failed to load memos: ${e.toString()}');
    }
  }

}


