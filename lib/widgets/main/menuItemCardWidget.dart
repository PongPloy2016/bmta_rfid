import 'package:bmta_rfid_app/models/main/menu_items_card.dart';
import 'package:flutter/material.dart';

class MenuItemCardWidget extends StatelessWidget {
  final MenuItemCard menuItem;
  final Function() onTap;

  const MenuItemCardWidget({super.key, required this.menuItem ,
  required this.onTap
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Handle tap (you can navigate or perform an action)
      onTap.call();
      },
      child: Container(
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15.0),
          color: menuItem.colors
,
        ),
        child: Stack(
          fit : StackFit.loose,
          alignment: Alignment.bottomRight,
          children: [
            // Container for the SVG icon
            Container(
              alignment: Alignment.topCenter,
              //  height: 60,
              // color: Colors.yellow,
              width: double.infinity, // Make sure the width takes the full space
              child: Image.asset(
                //fit: BoxFit.fill,
                menuItem.image,
                width: 80,
                height: 80,
                scale: 1,
              ),
              //  SvgPicture.asset(
              //   menuItem.image,
              //   height: 40, // Adjust the height as needed
              //   width: 40,  // Adjust the width as needed
              //   fit: BoxFit.contain,
              // ),
            ),
            
            // Add spacing between icon and text
            // Container for the text
            Container(
              alignment: Alignment.bottomCenter,
              margin: const EdgeInsets.only(bottom: 1.0),
              child: Text(
                menuItem.name,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontFamily: 'Kanit',
                  fontSize: 10, 
                  fontWeight: FontWeight.w600, color: Colors.black87),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
