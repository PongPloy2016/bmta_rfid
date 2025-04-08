import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class MainListItem extends StatelessWidget {
  final dynamic id;
  final String title;
  final String subtitle;

  const MainListItem({Key? key, required this.id, required this.title, required this.subtitle}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsetsDirectional.only(start: 12.0, end: 12.0),
            child:Image.asset(
              //fit: BoxFit.fill,
              "lib/assets/images/bmta_logo_icon_three.png",
              width: 30,
              height: 30,
             // scale: 1,
            ),
          ), // _myIcon is a 48px-wide widget.

         // SizedBox(width: 10),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(title,
                 style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.normal,
                  
                 ))],
            ),
          ),
          Padding(
            padding: const EdgeInsetsDirectional.only(start: 12.0, end: 12.0),
            child: SvgPicture.asset("lib/assets/icons/ic_icon_more.svg" ?? "", height: 20, width: 20),
          ),
        ],
      ),
    );
  }
}
