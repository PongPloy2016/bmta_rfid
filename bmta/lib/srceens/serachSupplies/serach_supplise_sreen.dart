import 'dart:convert';

import 'package:bmta/app_router.dart';
import 'package:bmta/repository/rfid_serach_supplies_repository.dart';
import 'package:bmta/themes/fontsize.dart';
import 'package:bmta/widgets/appbar/custom_app_bar.dart';
import 'package:bmta/widgets/custom_text_default.dart';
import 'package:bmta/widgets/dropdown/custom_dropdown_form_field.dart';
import 'package:bmta/widgets/textFrom/custom_text_form_field.dart';
import 'package:bmta/widgets/widgets.dart';
import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SerachSuppliseSreen extends StatefulWidget {
  const SerachSuppliseSreen({super.key});

  @override
  State<SerachSuppliseSreen> createState() => _SerachSuppliseSreenState();
}

class _SerachSuppliseSreenState extends State<SerachSuppliseSreen> {
  late RFIDSerachSuppliesRepository repository;
  bool _isSubmit = false;
  bool _isLoadingMore = false;

  final _formKey = GlobalKey<FormState>();
  final _codeController = TextEditingController();
  final _nameController = TextEditingController();
  final _controller = SingleValueDropDownController();
  final _controllerArea = SingleValueDropDownController();

  String? selectedValue;
  List<DropDownValueModel> dropDownList = [];

  @override
  void initState() {
    super.initState();
    repository = RFIDSerachSuppliesRepository(); // Initialize repository
    initiload(); // Load the initial data
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: "รายการทรัพย์สิน" ?? '',
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
                      CustomTextFormField(
                        controller: _codeController,
                        hintText: 'รหัสครูกันท์',
                        obscureText: false,
                        inputDecoration: inputDecoration(
                          nameImage: "lib/assets/icons/ic_login_email.svg",
                          context,
                          hintText: "รหัสครูกันท์",
                        ),
                      ),
                      SizedBox(height: 16),

                      // ชื่อครุภัณฑ์
                      CustomTextFormField(
                        controller: _nameController,
                        hintText: 'ชื่อครุภัณฑ์',
                        obscureText: false,
                        inputDecoration: inputDecoration(
                          nameImage: "lib/assets/icons/ic_login_email.svg",
                          context,
                          hintText: "ชื่อครุภัณฑ์",
                        ),
                      ),
                      SizedBox(height: 16),

                      // อาคาร
                      CustomDropdownFormField(
                        controller: _controller,
                        labelText: 'อาคาร',
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
                        labelText: "ชั้น",
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

                      // พื้นที่/ห้อง
                      CustomDropdownFormField(
                        controller: _controllerArea,
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
                      SizedBox(height: 24),

                      // ปุ่มค้นหา
                      SizedBox(
                        width: double.infinity,
                        height: MediaQuery.of(context).size.height * 0.07,
                        child: ElevatedButton(
                          onPressed: () {
                            //if (_formKey.currentState?.validate() ?? false) {
                            // Do the search action
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('กำลังค้นหา...')));
                            Navigator.pushNamed(context, AppRouter.equipmentList);
                            //}
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
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white),
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

 Future<void> initiload() async {
  try {
    final response = await repository.getMemoDataClassification(context);

    setState(() {
      _isSubmit = false; // Stop loading
    });

     setState(() {
          // Transform API response into dropDownList for the dropdown
          dropDownList = response.data.data.map<DropDownValueModel>((data) {
            return DropDownValueModel(
              value: data.memoDataClassId.toString(),  // Use appropriate data field
              name: data.description,  // Use appropriate data field
            );
          }).toList();
        });

    // if (response.isSuccess) {
    //   print("Response getMemoList: ${jsonEncode(response)}");

    //   if (mounted) {
    //     setState(() {
    //       // Transform API response into dropDownList for the dropdown
    //       dropDownList = response.data.data.map<DropDownValueModel>((data) {
    //         return DropDownValueModel(
    //           value: data.memoDataClassId.toString(),  // Use appropriate data field
    //           name: data.description,  // Use appropriate data field
    //         );
    //       }).toList();
    //     });
    //   }
    // } else {
    //   if (mounted) {
    //     ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(response.message)));
    //   }
    // }
  } catch (e) {
    setState(() {
      _isSubmit = false; // Stop loading in case of an error
    });
  }
}
}