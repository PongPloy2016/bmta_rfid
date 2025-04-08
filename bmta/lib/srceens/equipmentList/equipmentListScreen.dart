import 'dart:convert';

import 'package:bmta/Interface/rfid_repo_interface.dart';
import 'package:bmta/app_router.dart';
import 'package:bmta/models/equipmentItemModel/equipmentItem.dart';
import 'package:bmta/models/equipmentItemModel/mockup_memo_model.dart';
import 'package:bmta/models/equipmentItemModel/reqMemoList.dart';
import 'package:bmta/repository/rfid_meno_list_repository.dart';
import 'package:bmta/widgets/appbar/custom_app_bar.dart';
import 'package:bmta/widgets/equipmentListWidgets/equipmentItemWidget.dart';
import 'package:flutter/material.dart';

class EquipmentListScreen extends StatefulWidget {
  const EquipmentListScreen({super.key});

  // เปลี่ยนเป็น StatefulWidget
  @override
  _EquipmentListState createState() => _EquipmentListState(); // สร้าง State
}

class _EquipmentListState extends State<EquipmentListScreen> {
 


  // State ของ EquipmentList
  final List<EquipmentItem> items = [
    EquipmentItem(
      name: 'โต๊ะคอมพิวเตอร์',
      category: 'หมวดฟอร์นิเจอร์ : ครุภัณฑ์สำนักงาน',
      description: 'รายละเอียดฟอร์นิเจอร์ : โต๊ะคอมพิวเตอร์',
      location: 'สำนักงาน B',
      nameImage: 'lib/assets/images/ic_list-table_01.png',
    ),
    EquipmentItem(
      name: 'Laptop รุ่น Lenovo',
      category: 'หมวดฟอร์นิเจอร์ : ครุภัณฑ์สำนักงาน',
      description: 'รายละเอียดฟอร์นิเจอร์ : Laptop',
      location: 'สำนักงาน B',
      nameImage: 'lib/assets/images/ic_list-pc_screen_01.png',
    ),
    EquipmentItem(
      name: 'จอ LED รุ่น AOC',
      category: 'หมวดฟอร์นิเจอร์ : ครุภัณฑ์สำนักงาน',
      description: 'รายละเอียดฟอร์นิเจอร์ : จอ LED',
      location: 'สำนักงานใหญ่',
      nameImage: 'lib/assets/images/ic_list_laptop-01.png',
    ),
    EquipmentItem(
      name: 'อาคารหลัก CI',
      category: 'หมวดฟอร์นิเจอร์ : ครุภัณฑ์สำนักงาน',
      description: 'รายละเอียดฟอร์นิเจอร์ : อาคารหลัก CI',
      location: 'สำนักงาน B',
      nameImage: 'lib/assets/images/ic_list_building-01.png',
    ),
    EquipmentItem(
      name: 'โต๊ะคอมพิวเตอร์',
      category: 'หมวดฟอร์นิเจอร์ : ครุภัณฑ์สำนักงาน',
      description: 'รายละเอียดฟอร์นิเจอร์ : โต๊ะคอมพิวเตอร์',
      location: 'สำนักงาน B',
      nameImage: 'lib/assets/images/ic_list-table_01.png',
    ),
    EquipmentItem(
      name: 'Laptop รุ่น Lenovo',
      category: 'หมวดฟอร์นิเจอร์ : ครุภัณฑ์สำนักงาน',
      description: 'รายละเอียดฟอร์นิเจอร์ : Laptop',
      location: 'สำนักงาน B',
      nameImage: 'lib/assets/images/ic_list-pc_screen_01.png',
    ),
    EquipmentItem(
      name: 'จอ LED รุ่น AOC',
      category: 'หมวดฟอร์นิเจอร์ : ครุภัณฑ์สำนักงาน',
      description: 'รายละเอียดฟอร์นิเจอร์ : จอ LED',
      location: 'สำนักงานใหญ่',
      nameImage: 'lib/assets/images/ic_list_laptop-01.png',
    ),
    EquipmentItem(
      name: 'อาคารหลัก CI',
      category: 'หมวดฟอร์นิเจอร์ : ครุภัณฑ์สำนักงาน',
      description: 'รายละเอียดฟอร์นิเจอร์ : อาคารหลัก CI',
      location: 'สำนักงาน B',
      nameImage: 'lib/assets/images/ic_list_building-01.png',
    ),
  ];
  late RFIDMenoListRepository repository;
  bool _isSubmit = false;
  bool _isLoadingMore = false;  // Loading state for loading more data
  List<EquipmentItem> itemsMock = [];
  int currentPage = 1;  // Track the current page
  final int limit = 15;  // Items per page

  @override
  void initState() {
    super.initState();
    repository = RFIDMenoListRepository(); // Initialize repository
    initiload();  // Load the initial data
  }

  Future<void> initiload() async {
    setState(() {
      _isSubmit = true; // Start loading
    });

    try {
      final response = await repository.getMenoList(
        ReqMemoList(order: "asc", orderBy: "id", page: currentPage, limit: limit),
      );

      setState(() {
        _isSubmit = false; // Stop loading
      });

      if (response.isSuccess) {
        print("Response getMenoList: ${jsonEncode(response)}");

        if (mounted) {
          setState(() {
            // Update itemsMock with the transformed list
            itemsMock = response.data.data.map((data) {
              return EquipmentItem(
                name: data.memoCode,  // Assuming data.memoCode is used for the name
                category: data.bookRegister,
                description: data.memoDataClassDescription,
                location: data.memoTypeDescription,
                nameImage: data.memoUrgentDescription,  // Replace with actual dynamic image if needed
              );
            }).toList();
          });
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(response.message)),
          );
        }
      }
    } catch (e) {
      setState(() {
        _isSubmit = false; // Stop loading in case of an error
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  Future<void> loadMoreData() async {
    if (_isLoadingMore) return; // Prevent multiple loads at the same time

    setState(() {
      _isLoadingMore = true; // Set loading state
    });

    try {
      // Increment the page number to fetch next set of data
      currentPage++;

      final response = await repository.getMenoList(
        ReqMemoList(order: "asc", orderBy: "id", page: currentPage, limit: limit),
      );

      setState(() {
        _isLoadingMore = false; // Stop loading
      });

      if (response.isSuccess) {
        setState(() {
          // Append the new data to the existing list
          itemsMock.addAll(response.data.data.map((data) {
            return EquipmentItem(
              name: data.memoCode,
              category: data.bookRegister,
              description: data.memoDataClassDescription,
              location: data.memoTypeDescription,
              nameImage: data.memoUrgentDescription,
            );
          }).toList());
        });
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(response.message)),
          );
        }
      }
    } catch (e) {
      setState(() {
        _isLoadingMore = false; // Stop loading in case of an error
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: "รายการครุภัณฑ์",
        onSuccess: () {
          Navigator.pop(context);
        },
      ),
      body: _isSubmit
          ? Center(child: CircularProgressIndicator()) // Show loading indicator
          : NotificationListener<ScrollNotification>(
              onNotification: (ScrollNotification scrollInfo) {
                if (!_isLoadingMore &&
                    scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent) {
                  loadMoreData(); // Load more data when the user scrolls to the bottom
                  return true; // Stop further processing of the notification
                }
                return false;
              },
              child: ListView.builder(
                itemCount: itemsMock.length + (_isLoadingMore ? 1 : 0),  // Add 1 for the loading indicator
                itemBuilder: (context, index) {
                  if (index == itemsMock.length) {
                    return Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Center(child: CircularProgressIndicator()),  // Show loading indicator
                    );
                  }

                  final item = itemsMock[index];
                  return EquipmentItemWidget(
                    item: item,
                    onlickTap: () {
                      // Navigate to equipment detail screen when item is tapped
                      Navigator.pushNamed(
                        context,
                        AppRouter.equipmentDetail,
                        arguments: item,
                      );
                    },
                  );
                },
              ),
            ),
    );
  }
}