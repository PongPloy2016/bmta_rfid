import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class LogoCreatePinWidget extends StatelessWidget {
  const LogoCreatePinWidget({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Image.asset(
        fit: BoxFit.fill ,
      'lib/assets/images/bmta_logo_icon_three.png',
      width: screenWidth * 0.3,
      height: screenWidth * 0.3,
      scale: 2);
  
    // Image.asset(
    //   fit: BoxFit.fill ,
    //   'lib/assets/images/bmta_logo_icon.png',
    //   width: screenWidth * 0.5,
    //   height: screenWidth * 0.5,
    //   scale: 2.5
    // );
  }
}
