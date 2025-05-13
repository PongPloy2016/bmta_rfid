import 'package:bmta_rfid_app/app_router.dart';
import 'package:bmta_rfid_app/widgets/textFrom/custom_text_form_field.dart';
import 'package:bmta_rfid_app/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

class MappingTagRfidScreen extends StatefulWidget {
  final MemoItem data;

  const MappingTagRfidScreen({super.key, required this.data});

  @override
  _MappingTagRfidScreenState createState() => _MappingTagRfidScreenState();
}

class _MappingTagRfidScreenState extends State<MappingTagRfidScreen> {
  final TextEditingController trackingIdController = TextEditingController();
  final TextEditingController subjectController = TextEditingController();
  final TextEditingController tagIdController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Initialize controllers with data from MemoItem
    trackingIdController.text = widget.data.memoCode;
    subjectController.text = widget.data.subject;
  }

  void onButtonOKClicked() async {
    String trackingIds = trackingIdController.text;
    String tagIds = tagIdController.text;

    if (tagIds.isEmpty) {
      _showDialog("ผิดผลาด", "กรุณากรอกรหัส TAG RFID");
      return;
    }

    var json = {'tagId': tagIds, 'trackingId': trackingIds};

    var ret = await _sendDataToAPI(json);
    if (ret['success']) {
      _showDialog("ถูกต้อง", "ทำการจับคู่เรียบร้อย");
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const MappingTag()));
    } else {
      _showDialog("ผิดผลาด", ret['message']);
    }
  }

  Future<Map<String, dynamic>> _sendDataToAPI(Map<String, dynamic> json) async {
    try {
      Dio dio = Dio();
      var response = await dio.post('https://your-api-url.com/api/rfid/tag', data: json);
      return response.data;
    } catch (e) {
      return {'success': false, 'message': 'Error: $e'};
    }
  }

  void _showDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("กำหนด TAG ID ครุภัณท์")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomTextFormField(
                controller: trackingIdController,
                hintText: 'เลขที่เอกสาร',
                obscureText: false,
                inputDecoration: inputDecoration(
                  context,
                  nameImage: "lib/assets/icons/ic_svg_user.svg",
                  hintText: 'เลขที่เอกสาร',
                ),
              ),
              const SizedBox(height: 10),
              CustomTextFormField(
                controller: subjectController,
                hintText: 'เลขที่เอกสาร',
                obscureText: false,
                inputDecoration: inputDecoration(
                  context,
                  nameImage: "lib/assets/icons/ic_svg_user.svg",
                  hintText: 'เลขที่เอกสาร',
                ),
              ),
              const SizedBox(height: 10),
              CustomTextFormField(
                controller: tagIdController,
                hintText: 'เลขที่เอกสาร',
                obscureText: false,
                inputDecoration: inputDecoration(
                  context,
                  nameImage: "lib/assets/icons/ic_svg_user.svg",
                  hintText: 'เลขที่เอกสาร',
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: MediaQuery.of(context).size.height * 0.07,
                child: ElevatedButton(
                  onPressed: () {
                    //if (_formKey.currentState?.validate() ?? false) {
                    // Do the search action
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('กำลังค้นหา...')));
                    Navigator.pushNamed(context, AppRouter.propertySetListListing);
                    // }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4CAF50),
                    padding: const EdgeInsets.symmetric(vertical: 12.0),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
                  ),
                  child: const Center(
                    child: Text(
                      'บันทึก',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MemoItem {
  final String memoCode;
  final String subject;

  MemoItem({required this.memoCode, required this.subject});
}

class MappingTag extends StatelessWidget {
  const MappingTag({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: const Text("Mapping Tag")), body: const Center(child: Text("Mapping Tag Screen")));
  }
}
