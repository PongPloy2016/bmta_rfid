import 'package:bmta_rfid_app/app_router.dart';
import 'package:bmta_rfid_app/widgets/appbar/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:bmta_rfid_app/models/propertyItemModel/property_Item_model.dart';
import 'package:bmta_rfid_app/widgets/propertysetItemWidgets/property_set_Item_widgets.dart';

class PropertySetListListingScreen extends StatelessWidget {
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

  PropertySetListListingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: 
      CustomAppBar(
                title:"รายการทรัพย์สิน" ?? '',
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
                return PropertySetItemWidgets(
                  item: item,
                  onlickTap: () {
                    print("onclick");
                     Navigator.pushNamed(context, AppRouter.propertyListRegistrationDetails);
                  },
                );
              },
            ),
          ),
          // Bottom card with total number of items
                    const SizedBox(height: 10), // Add spacing after the bottom card

       Card(
  color: Colors.green,
  margin: const EdgeInsets.all(10),
  elevation: 2,
  shape: const RoundedRectangleBorder(
    borderRadius: BorderRadius.only(
      topLeft: Radius.circular(20),
      topRight: Radius.circular(20),
    ),
  ),
  child: Padding(
    padding: const EdgeInsets.all(8.0),
    child: Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          const Text(
            "รายการทรัพย์สินที่พบ",
            style: TextStyle(
              color: Colors.white,
              fontSize: 26,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          Text(
            "จำนวน ${items.length} รายการ",
            style: const TextStyle(
              color: Colors.white,
              fontSize: 26,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    ),
  ),
),

          const SizedBox(height: 10), // Add spacing after the bottom card
        ],
      ),
    );
  }
}
