import 'package:bmta_rfid_app/app_router.dart';
import 'package:bmta_rfid_app/widgets/appbar/custom_app_bar.dart';
import 'package:bmta_rfid_app/widgets/button/buttons.dart';
import 'package:bmta_rfid_app/widgets/propertydetailItemWidgets/property_detail_Item_widgets.dart';
import 'package:flutter/material.dart';
import 'package:bmta_rfid_app/models/propertyItemModel/property_Item_model.dart';
import 'package:bmta_rfid_app/widgets/propertysetItemWidgets/property_set_Item_widgets.dart';

class PropertyListRegistrationDetailsScreen extends StatelessWidget {
  final List<PropertyItemModel> items = [
    PropertyItemModel(
      title: 'โต๊ะคอมพิวเตอร์',
      category: 'หมวดฟอร์นิเจอร์ : ครุภัณฑ์สำนักงาน',
      description: 'รายละเอียดฟอร์นิเจอร์ : โต๊ะคอมพิวเตอร์',
      location: 'สำนักงาน B',
      count: 5,
    ),
    PropertyItemModel(
      title: 'จอ LCD รุ่น AOC',
      category: 'หมวดฟอร์นิเจอร์ : ครุภัณฑ์สำนักงาน',
      description: 'รายละเอียดฟอร์นิเจอร์ : จอ LCD',
      location: 'สำนักงาน B',
      count: 20,
    ),
    PropertyItemModel(
      title: 'คอมพิวเตอร์ตั้งโต๊ะ',
      category: 'หมวดฟอร์นิเจอร์ : ครุภัณฑ์สำนักงาน',
      description: 'รายละเอียดฟอร์นิเจอร์ : คอมพิวเตอร์',
      location: 'สำนักงาน B',
      count: 18,
    ),
    PropertyItemModel(
      title: 'เก้าอี้สำนักงาน',
      category: 'หมวดฟอร์นิเจอร์ : ครุภัณฑ์สำนักงาน',
      description: 'รายละเอียดฟอร์นิเจอร์ : เก้าอี้สำนักงาน',
      location: 'สำนักงาน B',
      count: 129,
    ),
    PropertyItemModel(
      title: 'โต๊ะคอมพิวเตอร์',
      category: 'หมวดฟอร์นิเจอร์ : ครุภัณฑ์สำนักงาน',
      description: 'รายละเอียดฟอร์นิเจอร์ : โต๊ะคอมพิวเตอร์',
      location: 'สำนักงาน B',
      count: 5,
    ),
    PropertyItemModel(
      title: 'จอ LCD รุ่น AOC',
      category: 'หมวดฟอร์นิเจอร์ : ครุภัณฑ์สำนักงาน',
      description: 'รายละเอียดฟอร์นิเจอร์ : จอ LCD',
      location: 'สำนักงาน B',
      count: 20,
    ),
    PropertyItemModel(
      title: 'คอมพิวเตอร์ตั้งโต๊ะ',
      category: 'หมวดฟอร์นิเจอร์ : ครุภัณฑ์สำนักงาน',
      description: 'รายละเอียดฟอร์นิเจอร์ : คอมพิวเตอร์',
      location: 'สำนักงาน B',
      count: 18,
    ),
  ];

  PropertyListRegistrationDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: "รายละเอียดทะเบียนทรัพย์สิน" ?? '',
        onSuccess: () {
          Navigator.pop(context);
        },
      ),
      // AppBar(
      //   title: Center(child: Text('รายการทรัพย์สิน', style: TextStyle(fontSize: 20))),
      //   leading: IconButton(
      //     icon: Icon(Icons.arrow_back),
      //     onPressed: () {
      //       Navigator.pop(context);
      //     },
      //   ),
      // ),
      body: Column(
        children: [
          // ListView.builder with scroll functionality
          Expanded(
            child: ListView.builder(
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];
                return PropertyDetailItemWidgets(
                  item: item,
                  onlickTap: () {},
                );
              },
            ),
          ),
          // Bottom card with total number of items
          const SizedBox(height: 10), // Add spacing after the bottom card
          Padding(
            padding:  const EdgeInsets.only(left: 20, right: 20),
            child: Container(
             margin: const EdgeInsets.only(bottom: 20),
              child: SizedBox(
                width: double.infinity,
                height: 70,
                child: CustomElevatedButton(
                  type: 'success',
                  text: "ส่งรายการ",
                  size: "",
                  onPressed: () {
                    Navigator.pushNamed(context, AppRouter.propertyListRegistrationDetails);
                  },
                ),
              ),
            ),
          ),
          // CustomElevatedButton(
          //  type: 'success',
          //   text: "บันทึก",
          //   size: "",
          //   onPressed: () {
          //     Navigator.pushNamed(context, AppRouter.propertyListRegistrationDetails);
          //   },
          // ),
          const SizedBox(height: 10), // Add spacing after the bottom card

          const SizedBox(height: 10), // Add spacing after the bottom card
        ],
      ),
    );
  }
}
