import 'package:bmta/app_router.dart';
import 'package:bmta/themes/fontsize.dart';
import 'package:bmta/widgets/appbar/custom_app_bar.dart';
import 'package:bmta/widgets/custom_text_default.dart';
import 'package:bmta/widgets/dropdown/custom_dropdown_form_field.dart';
import 'package:bmta/widgets/textFrom/custom_text_form_field.dart';
import 'package:bmta/widgets/widgets.dart';
import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SerachFindPropertyScreen extends StatefulWidget {
  const SerachFindPropertyScreen({super.key});

  @override
  State<SerachFindPropertyScreen> createState() => _SerachFindPropertyScreenState();
}


class _SerachFindPropertyScreenState extends State<SerachFindPropertyScreen> {
   final _formKey = GlobalKey<FormState>();
  final _codeController = TextEditingController();
  final _nameController = TextEditingController();
  final _controller = SingleValueDropDownController();
      final _controllerArea = SingleValueDropDownController();

  String? selectedValue;
  List<DropDownValueModel> dropDownList = [
    DropDownValueModel(value: '1', name: 'Option 1'),
    DropDownValueModel(value: '2', name: 'Option 2'),
    DropDownValueModel(value: '3', name: 'Option 3'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
       CustomAppBar(
                title:"ค้นหาทรัพย์สิน" ?? '',
                onSuccess: () {
                  Navigator.pop(context);
                },
              ),
      
      
      body: Stack(
        children: [
          Container(
            alignment: Alignment.center,
            width: double.infinity,
            height: double.infinity,
            child: SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.all(16),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(height: 20),

                      // รหัสครุภัณฑ์
                      CustomDropdownFormField(
                        controller: _controller,
                        labelText: "พื้นที่/ห้อง",
                        dropDownList: dropDownList,
                        itemCount: dropDownList.length,
                        enabled: true,
                        onChanged: (value) {
                          setState(() {
                            selectedValue = value?.toString();
                          });
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please select an option';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 16),

                      // ชื่อครุภัณฑ์
                      CustomDropdownFormField(
                        controller: _controller,
                        labelText: "พื้นที่/ห้อง",
                        dropDownList: dropDownList,
                        itemCount: dropDownList.length,
                        enabled: true,
                        onChanged: (value) {
                          setState(() {
                            selectedValue = value?.toString();
                          });
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please select an option';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 16),

                      // อาคาร
                      CustomDropdownFormField(
                        controller: _controller,
                        labelText: 'ชั้น',
                        dropDownList: dropDownList,
                        itemCount: dropDownList.length,
                        enabled: true,
                        onChanged: (value) {
                          setState(() {
                            selectedValue = value?.toString();
                          });
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please select an option';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 16),

                      // ชั้น
                      CustomDropdownFormField(
                        controller: _controller,
                        labelText: "พื้นที่/ห้อง",
                        dropDownList: dropDownList,
                        itemCount: dropDownList.length,
                        enabled: true,
                        onChanged: (value) {
                          setState(() {
                            selectedValue = value?.toString();
                          });
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please select an option';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 16),

                      SizedBox(height: 24),

                      // ปุ่มค้นหา
                      SizedBox(
                        width: double.infinity,
                        height: MediaQuery.of(context).size.height * 0.07,
                        child: ElevatedButton(
                          onPressed: () {
                            //if (_formKey.currentState?.validate() ?? false) {
                              // Do the search action
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('กำลังค้นหา...')),
                              );
                              Navigator.pushNamed(context, AppRouter.propertyList);
                           // }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF4CAF50),
                            padding: const EdgeInsets.symmetric(vertical: 12.0),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
                          ),
                          child: Center(
                            child: Text(
                              'ค้นหา',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}