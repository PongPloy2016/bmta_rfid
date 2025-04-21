import 'package:bmta/app_router.dart';
import 'package:bmta/themes/fontsize.dart';
import 'package:bmta/widgets/appbar/custom_app_bar.dart';
import 'package:bmta/widgets/custom_text_default.dart';
import 'package:bmta/widgets/dropdown/custom_dropdown_form_field.dart';
import 'package:bmta/widgets/textFrom/custom_text_form_field.dart';
import 'package:bmta/widgets/widgets.dart';
import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

// Define your models (DropDown, DataList, etc.)
class DropDown {
  final String id;
  final String desc;

  DropDown({required this.id, required this.desc});

  factory DropDown.fromJson(Map<String, dynamic> json) {
    return DropDown(
      id: json['id'] ?? '',
      desc: json['desc'] ?? '',
    );
  }
}

class DataList {
  final bool success;
  final List<DropDownValueModel> data;

  DataList({required this.success, required this.data});

  factory DataList.fromJson(Map<String, dynamic> json) {
    var list = json['data'] as List;
    List<DropDownValueModel> dropDownList = list.map((i) => DropDownValueModel.fromJson(i)).toList();

    return DataList(
      success: json['success'] ?? false,
      data: dropDownList,
    );
  }
}

class SerachFindPropertyScreen extends ConsumerStatefulWidget {
  const SerachFindPropertyScreen({Key? key}) : super(key: key);
  
  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return SerachFindPropertyScreenState();
  }
 
}

class SerachFindPropertyScreenState extends  ConsumerState<SerachFindPropertyScreen>   {
  final Dio dio = Dio();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  List<DropDownValueModel> dropDownBranchList = [];
  List<DropDownValueModel> dropDownBuildingList = [];
  List<DropDownValueModel> dropDownFloorList = [];
  List<DropDownValueModel> dropDownRoomList = [];

  String? branchSelect;
  String? buildingSelect;
  String? floorSelect;
  String? roomSelect;

  @override
  void initState() {
    super.initState();
   // getBranch(); // Fetch branch data when the page loads
   initMockData(); // Initialize mock data for testing
  }


   void initMockData() {
    dropDownBranchList = [
      DropDownValueModel( name: 'สาขา 1', value: '1'),
      DropDownValueModel( name: 'สาขา 2', value: '2'),
      DropDownValueModel( name: 'สาขา 3', value: '3'),
      DropDownValueModel( name: 'สาขา 4', value: '4'),
    ];

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

     dropDownRoomList = [
      DropDownValueModel( name: 'ห้อง 1', value: '1'),
      DropDownValueModel( name: 'ห้อง 2', value: '2'),
      DropDownValueModel( name: 'ห้อง 3', value: '3'),
      DropDownValueModel( name: 'ห้อง 4', value: '4'),
    ];
  //  _controller.dropDownValue = dropDownBuildingList[0]; // Set default value
  }

  // Error dialog method
  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: "ค้นหาทรัพย์สิน",
        onSuccess: () {
          Navigator.pop(context); // Handle back action
        },
      ),
      body: Stack(
        children: [
          Container(
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
                      // Dropdown for สาขา
                      CustomDropdownFormField(
                        labelText: "สาขา",
                        dropDownList: dropDownBranchList,
                        itemCount: dropDownBranchList.length,
                        enabled: true,
                        onChanged: (value) {
                          setState(() {
                            branchSelect = value?.toString();
                            buildingSelect = null;
                            floorSelect = null;
                            roomSelect = null;
                          });
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please select a branch';
                          }
                          return null;
                        },
                        inputDecoration: inputDecoration(
                          nameImage: "lib/assets/icons/ic_svg_user.svg",
                          context,
                          hintText: "สาขา",
                        ),
                      ),
                      SizedBox(height: 16),
                      // Dropdown for อาคาร
                      CustomDropdownFormField(
                        labelText: "อาคาร",
                        dropDownList: dropDownBuildingList,
                        itemCount: dropDownBuildingList.length,
                        enabled: true,
                        onChanged: (value) {
                          setState(() {
                            buildingSelect = value?.toString();
                            floorSelect = null;
                            roomSelect = null;
                           
                          });
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please select a building';
                          }
                          return null;
                        },
                        inputDecoration: inputDecoration(
                          nameImage: "lib/assets/icons/ic_svg_user.svg",
                          context,
                          hintText: "อาคาร",
                        ),
                      ),
                      SizedBox(height: 16),
                      // Dropdown for ชั้น
                      CustomDropdownFormField(
                        labelText: 'ชั้น',
                        dropDownList: dropDownFloorList,
                        itemCount: dropDownFloorList.length,
                        enabled: true,
                        onChanged: (value) {
                          setState(() {
                            floorSelect = value?.toString();
                            roomSelect = null;
                           
                          });
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please select a floor';
                          }
                          return null;
                        },
                        inputDecoration: inputDecoration(
                          nameImage: "lib/assets/icons/ic_svg_user.svg",
                          context,
                          hintText: "ชั้น",
                        ),
                      ),
                      SizedBox(height: 16),
                      // Dropdown for พื้นที่/ห้อง
                      CustomDropdownFormField(
                        labelText: "พื้นที่/ห้อง",
                        dropDownList: dropDownRoomList,
                        itemCount: dropDownRoomList.length,
                        enabled: true,
                        onChanged: (value) {
                          setState(() {
                            roomSelect = value?.toString();
                          });
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please select a room';
                          }
                          return null;
                        },
                        inputDecoration: inputDecoration(
                          nameImage: "lib/assets/icons/ic_svg_user.svg",
                          context,
                          hintText: "พื้นที่/ห้อง",
                        ),
                      ),
                      SizedBox(height: 16),
                      SizedBox(height: 24),
                      // Search button
                      SizedBox(
                        width: double.infinity,
                        height: MediaQuery.of(context).size.height * 0.07,
                        child: ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState?.validate() ?? false) {
                              // Perform search action
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('กำลังค้นหา...')),
                              );
                              Navigator.pushNamed(context, AppRouter.propertyList);
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