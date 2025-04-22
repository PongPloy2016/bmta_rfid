import 'package:bmta_rfid_app/models/equipmentItemModel/equipmentItem.dart';
import 'package:bmta_rfid_app/widgets/appbar/custom_app_bar.dart';
import 'package:bmta_rfid_app/widgets/equipmentListWidgets/equipmentItemWidget.dart';
import 'package:flutter/material.dart';

class EquipmentDetailScreen extends StatefulWidget {
  const EquipmentDetailScreen({super.key});

  // เปลี่ยนเป็น StatefulWidget
  @override
  _EquipmentDetailScreenState createState() => _EquipmentDetailScreenState(); // สร้าง State
}

class _EquipmentDetailScreenState extends State<EquipmentDetailScreen> {
 // ตัวอย่างข้อมูลของอุปกรณ์
  final EquipmentItem item = EquipmentItem(
    name: 'Laptop รุ่น Lenovo',
    category: 'หมวดฟอร์นิเจอร์ : ครุภัณฑ์สำนักงาน',
    description: 'รายละเอียดฟอร์นิเจอร์ : Laptop',
    location: 'สำนักงาน B',
    nameImage: "lib/assets/images/ic_menu_box_search_image.png", // Path ของภาพ
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
        CustomAppBar(
                title:"รายละเอียดครุภัณฑ์" ?? '',
                onSuccess: () {
                  Navigator.pop(context);
                },
              ),
      
      body: Card(
        color: Colors.white,
        margin: const EdgeInsets.all(10),
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),

        ),
        child: Container(
          width: double.infinity,
          height: 400,
          padding: const EdgeInsets.all(10), // การตั้งค่าระยะห่างภายใน
          decoration: BoxDecoration(
            color: Colors.transparent,  // กำหนดสีพื้นหลังของ Container
            borderRadius: BorderRadius.circular(15), // กำหนดมุมโค้งให้กับ Container
            border: Border.all(color: const Color.fromARGB(255, 85, 49, 49), width: 1), // เพิ่มเส้นขอบ
          ),
          child: Row(
            children: [
              // Leading Image
              Container(
                alignment: Alignment.topCenter,
                child: Image.asset(
                  item.nameImage ?? "lib/assets/images/ic_menu_box_search_image.png", // Path ของภาพ
                  width: 80,
                  height: 80,
                  scale: 1,
                ),
              ),
    
              // ข้อความที่แสดงใน title
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title (ชื่ออุปกรณ์)
                      Text(item.name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      
                      // Subtitle (ข้อมูลอื่นๆ เช่น หมวดหมู่, คำอธิบาย, ตำแหน่ง)
                      Text(item.category, style: const TextStyle(fontSize: 14, color: Colors.grey)),
                      Text(item.description, style: const TextStyle(fontSize: 14, color: Colors.black)),
                      Text('สำนักงาน: ${item.location}', style: const TextStyle(fontSize: 14, color: Colors.black)),
                    ],
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