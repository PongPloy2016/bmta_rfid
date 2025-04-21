import 'dart:convert';

import 'package:bmta/app_router.dart';
import 'package:bmta/provider/serach_find_property_provider.dart';
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
import 'package:http/http.dart' as ref;

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
  final _controllerBuilding = SingleValueDropDownController();
  final _controllerFloor = SingleValueDropDownController();
  final _controllernArea = SingleValueDropDownController();

  String? selectedValue;
  List<DropDownValueModel> dropDownBuildingList = [];
  List<DropDownValueModel> dropDownFloorList = [];
  List<DropDownValueModel> dropDownAreaList = [];

  @override
  void initState() {
    super.initState();
    repository = RFIDSerachSuppliesRepository(); // Initialize repository
   // initiload(); // Load the initial data
   initMockData();
  }


   // Function to simulate the mock data
  void initMockData() {

       //   ref.read(branchControllerProvider.notifier).login();


    dropDownBuildingList = [
     
      DropDownValueModel( name: 'อาคาร 1', value: '1'),
      DropDownValueModel( name: 'อาคาร 2', value: '2'),
      DropDownValueModel( name: 'อาคาร 3', value: '3'),
      DropDownValueModel( name: 'อาคาร 4', value: '4'),
    ];

    dropDownFloorList = [
      DropDownValueModel( name: 'ชั้น 1', value: '1'),
      DropDownValueModel( name: 'ชั้น 2', value: '2'),
      DropDownValueModel( name: 'ชั้น 3', value: '3'),
      DropDownValueModel( name: 'ชั้น 4', value: '4'),
    ];

    dropDownAreaList = [
      DropDownValueModel( name: 'พื้นที่ 1', value: '1'),
      DropDownValueModel( name: 'พื้นที่ 2', value: '2'),
      DropDownValueModel( name: 'พื้นที่ 3', value: '3'),
      DropDownValueModel( name: 'พื้นที่ 4', value: '4'),
    ];
  //  _controller.dropDownValue = dropDownBuildingList[0]; // Set default value
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: "ค้นหาครุภัณฑ์" ?? '',
        onSuccess: () {
          Navigator.pop(context);
        },
      ),

      body: Stack(
        children: [
          Container(
            color: Colors.transparent,
            alignment: Alignment.topCenter,
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
                        hintText: 'รหัสครุภัณฑ์',
                        obscureText: false,
                        inputDecoration: inputDecoration(
                          nameImage: "lib/assets/icons/ic_svg_profile.svg",
                          context,
                          hintText: "รหัสครุภัณฑ์",
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a code';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 16),

                      // ชื่อครุภัณฑ์
                      CustomTextFormField(
                        controller: _nameController,
                        hintText: 'ชื่อครุภัณฑ์',
                        obscureText: false,
                        inputDecoration: inputDecoration(
                          nameImage: "lib/assets/icons/ic_svg_user.svg",
                          context,
                          hintText: "ชื่อครุภัณฑ์",
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a name';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 16),

                      // อาคาร
                      CustomDropdownFormField(
                        controller: _controllerBuilding,
                        labelText: 'อาคาร',
                        dropDownList: dropDownBuildingList,
                        itemCount: dropDownBuildingList.length,
                        enabled: true,
                        inputDecoration: inputDecoration(
                          nameImage: "lib/assets/icons/ic_svg_user.svg",
                          context,
                          hintText: "อาคาร",
                        ),
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
                        controller: _controllerFloor,
                        labelText: "ชั้น",
                        dropDownList: dropDownFloorList,
                        itemCount: dropDownFloorList.length,
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
                        }, inputDecoration: inputDecoration(
                          nameImage: "lib/assets/icons/ic_svg_user.svg",
                          context,
                          hintText: "ชั้น",
                        ),
                      ),
                      SizedBox(height: 16),

                      // พื้นที่/ห้อง
                      CustomDropdownFormField(
                        controller: _controllernArea,
                        labelText: "พื้นที่/ห้อง",
                        dropDownList: dropDownAreaList,
                        itemCount: dropDownAreaList.length,
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
                        }, inputDecoration: inputDecoration(
                          nameImage: "lib/assets/icons/ic_svg_user.svg",
                          context,
                          hintText: "พื้นที่/ห้อง",
                        ),
                      ),
                      SizedBox(height: 24),

                      // ปุ่มค้นหา
                      SizedBox(
                        width: double.infinity,
                        height: MediaQuery.of(context).size.height * 0.07,
                        child: ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState?.validate() ?? false) {
                            // Do the search action
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('กำลังค้นหา...')));
                            Navigator.pushNamed(context, AppRouter.equipmentList);
                            }
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
          dropDownBuildingList = response.data.data.map<DropDownValueModel>((data) {
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