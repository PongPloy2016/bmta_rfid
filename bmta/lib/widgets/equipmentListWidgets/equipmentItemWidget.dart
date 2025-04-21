// สร้าง Widget สำหรับแสดงข้อมูลแต่ละรายการ
import 'package:bmta/models/equipmentItemModel/equipmentItem.dart';
import 'package:bmta/srceens/equipmentList/equipmentListScreen.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class EquipmentItemWidget extends StatelessWidget {
  final EquipmentItem item;
  final Function onClickTap;


  EquipmentItemWidget({required this.item ,
    required this.onClickTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onClickTap(),
      child: Card(
        color: Colors.white,
        margin: EdgeInsets.all(10),
        elevation: 2,
        child: Container(
        // margin: EdgeInsets.all(10),  // การตั้งค่าระยะห่างจากขอบ
         padding: EdgeInsets.all(10), // การตั้งค่าระยะห่างภายใน
        decoration: BoxDecoration(
      color: Colors.transparent,  // กำหนดสีพื้นหลังของ Container
      borderRadius: BorderRadius.circular(15), 
       border: Border.all(color: const Color.fromARGB(255, 85, 49, 49), width: 1), // เพิ่มเส้นขอบ// กำหนดมุมโค้งให้กับ Container
      // boxShadow: [
      //   BoxShadow(  // ใส่เงาให้กับ Container
      //     color: Colors.black.withOpacity(0.1),
      //     spreadRadius: 2,
      //     blurRadius: 5,
      //     offset: Offset(0, 2),
      //   ),
      // ],
        ),
        child: Row(
      children: [
        // Leading Icon
        Container(
                alignment: Alignment.topCenter,
                //  height: 60,
                // color: Colors.yellow,
               // width: double.infinity, // Make sure the width takes the full space
                child: 
              
                Image.network(
              item.nameImage,
              width: 80,
              height: 80,
              scale: 1,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) {
                  return child; // Image loaded successfully
                } else {
                  return Center(child: CircularProgressIndicator());
                }
              },
              errorBuilder: (context, error, stackTrace) {
                // If the image URL fails, fallback to the asset
                return Image.asset(
                  item.nameImage,
                  width: 80,
                  height: 80,
                  scale: 1,
                );
              },
            ),
    
                //  SvgPicture.asset(
                //   menuItem.image,
                //   height: 40, // Adjust the height as needed
                //   width: 40,  // Adjust the width as needed
                //   fit: BoxFit.contain,
                // ),
              ),
      
        // ข้อความที่แสดงใน title
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title (ชื่ออุปกรณ์)
                Text(item.name, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                
                // Subtitle (ข้อมูลอื่นๆ เช่น หมวดหมู่, คำอธิบาย, ตำแหน่ง)
                Text('หมวดพัสดุ :${item.category}', style: TextStyle(fontSize: 14, color: Colors.grey)),
                Text('รายการพัสดุ " ${item.description}', style: TextStyle(fontSize: 14, color: Colors.black)),
                Text('สำนักงาน/ส่วนงาน : ${item.location}', style: TextStyle(fontSize: 14, color: Colors.black)),
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