import 'package:bmta_rfid_app/themes/colors.dart';
import 'package:flutter/material.dart';

class NotificationsItem extends StatelessWidget {
  final Function() onClickNotification;
    final Function() onClickLogout;
  const NotificationsItem({
    super.key,
    required this.onClickNotification ,
    required this.onClickLogout,});

  @override
  Widget build(BuildContext context) {
    return Container(
      child:   Card(
                elevation: 10,
                color: Color(cardColor), // กำหนดสีพื้นหลังของ Card
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Container(
                    width: double.infinity,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // 🔔 Bell Icon with Badge
                        GestureDetector(
                          onTap: onClickNotification,
                          child: Stack(
                            clipBehavior: Clip.none,
                            children: [
                              Icon(Icons.notifications, size: 28, color: Colors.black87),
                              Positioned(
                                top: -4,
                                right: -4,
                                child: Container(
                                  padding: const EdgeInsets.all(4),
                                  decoration: const BoxDecoration(
                                    color: Colors.red,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Text(
                                    '2',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        // 🚪 Logout Icon
                        GestureDetector(
                          onDoubleTap: onClickLogout,
                          child: Icon(Icons.logout, size: 28, color: Colors.black87)),
                      ],
                    ),
                  ),
                ),
              ),
    );
  }
}