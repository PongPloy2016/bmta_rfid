import 'package:bmta/models/propertyItemModel/property_Item_model.dart';
import 'package:flutter/material.dart';

class PropertyItemWidgets extends StatelessWidget {
  final PropertyItemModel item;
  final VoidCallback onlickTap;

  const PropertyItemWidgets({required this.item, required this.onlickTap, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      margin: EdgeInsets.all(10),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.transparent, // Set the background to be transparent so it doesn't override
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: const Color.fromARGB(255, 85, 49, 49), width: 1),
        ),
        child: Row(
          children: [
            // Left section - Title and description area
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item.title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  SizedBox(height: 8),
                  Text(item.category, style: TextStyle(color: Colors.grey)),
                  SizedBox(height: 8),
                  Text(item.description, style: TextStyle(color: Colors.grey)),
                  SizedBox(height: 8),
                  Text(item.location, style: TextStyle(color: Colors.grey)),
                ],
              ),
            ),
            // Right section - Count area
            Expanded(
  flex: 1,
  child: Container(
    alignment: Alignment.center,
    padding: EdgeInsets.all(20),
    width: double.infinity,
    decoration: BoxDecoration(
      color: Colors.tealAccent,  // Add the background color inside BoxDecoration
      borderRadius: BorderRadius.circular(15),
      border: Border.all(
        color: const Color.fromARGB(255, 85, 49, 49),
        width: 1,
      ),
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("จำนวน", style: TextStyle(color: Colors.blue)),
        Text(
          "${item.count}",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.red, // Change the color to red for the count
          ),
        ),
        Text("หน่วย", style: TextStyle(color: Colors.blue)),
      ],
    ),
  ),
)
          ],
        ),
      ),
    );
  }
}
