import 'package:bmta_rfid_app/themes/colors.dart';
import 'package:bmta_rfid_app/widgets/main/mainListItem.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  final subtitles = [
    "กำหนด TAG ID ค้นหาครุภัณท์ IOPUT9",
    "กำหนด TAG ID ค้นหาครุภัณท์ IOPUT9",
    "กำหนด TAG ID ค้นหาครุภัณท์ IOPUT9",
    "กำหนด TAG ID ค้นหาครุภัณท์ IOPUT9",
    "กำหนด TAG ID ค้นหาครุภัณท์ IOPUT9",
    "กำหนด TAG ID ค้นหาครุภัณท์ IOPUT9",
    "กำหนด TAG ID ค้นหาครุภัณท์ IOPUT9",
    "กำหนด TAG ID ค้นหาครุภัณท์ IOPUT9",
    "กำหนด TAG ID ค้นหาครุภัณท์ IOPUT9",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("การแจ้งเตือน"),
        //  backgroundColor: const Color(textColor),
      ),
      body: Column(
          children: [
            // Text('การแจ้งเตือน', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),

            // List of warnings with ListView
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: 
              Card(
                elevation: 10,
                color: Color(cardColor),
                child: Column(
                  children: [
                    // Card for the ListView
                    ListView.builder(
                      shrinkWrap: true, // Shrinks the ListView to only take as much space as needed
                      physics: const NeverScrollableScrollPhysics(), // Prevents ListView from scrolling itself
                      itemCount: subtitles.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Column(
                          children: [
                            MainListItem(
                              id: subtitles[index],
                              title: subtitles[index],
                              subtitle: '', // Modify this if you need more data
                            ),
                            const Divider(),
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    
  }
}
