import 'package:bmta_rfid_app/app_router.dart';
import 'package:bmta_rfid_app/models/main/menu_items_card.dart';
import 'package:bmta_rfid_app/themes/colors.dart';
import 'package:bmta_rfid_app/widgets/appbar/custom_app_bar.dart';
import 'package:bmta_rfid_app/widgets/main/mainListItem.dart';
import 'package:bmta_rfid_app/widgets/main/menuItemCardWidget.dart';
import 'package:bmta_rfid_app/widgets/notifications/notifications_item.dart';
import 'package:flutter/material.dart';

class MainPageScreen extends StatefulWidget {
  const MainPageScreen({super.key});

  @override
  State<MainPageScreen> createState() => _MainPageScreenState();
}

class _MainPageScreenState extends State<MainPageScreen> {
  final icons = [Icons.ac_unit, Icons.access_alarm, Icons.access_time];

  final List<MenuItemCard> menuItems = [
    MenuItemCard(
      id: 1,
      name: "ค้นหาครุภัณท์",
      image: "lib/assets/images/ic_menu_box_search_image.png",
      colors: textMainMenuGeenPastel,
    ),
    MenuItemCard(
      id: 2,
      name: "กำหนด TAG ID",
      image: "lib/assets/images/ic_menu_tagid_image.png",
      colors: textMainMenuPink,
    ),
    MenuItemCard(
      id: 3,
      name: "ตรวจสอบทรัพย์สิน",
      image: "lib/assets/images/ic_doc_hand_imag.png",
      colors: textFromMenuPurple,
    ),

  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(),
      body: Card(
        color: Colors.white,
        margin: const EdgeInsets.all(10),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              const SizedBox(height: 10), // Add spacing after the bottom card
              // ListView.builder with scroll functionality

            NotificationsItem(onClickNotification: (){
                Navigator.pushNamed(context, AppRouter.notifications);

            }, onClickLogout: (){
              
            }),
           
            

              // Bottom card with total number of items
              const SizedBox(height: 10), // Add spacing after the bottom card

              Flexible(
                flex: 3,
                child: SingleChildScrollView(
                  child: SizedBox(
                    //   height: 600,
                    width: double.infinity,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          crossAxisSpacing: 5.0,
                          mainAxisSpacing: 5.0,
                        ),
                        itemCount: menuItems.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              // Navigate to DetailScreen and pass the tapped item name
                              // Navigator.push(context, MaterialPageRoute(builder: (context) => SerachSuppliseSreen()));
                            },
                            child: MenuItemCardWidget(
                              menuItem: menuItems[index],
                              onTap: () {
                                // Handle tap (you can navigate or perform an action)
                                // Navigate to SerachSuppliseSrren using the named route
                                // Navigator.pushNamed(context, '/serachSupplies');
                                var menuItemsModel = menuItems[index];

                                if (menuItemsModel.id == 1) {
                                  var data =
                                      "{\"id\":\"hgss3-4\",\"name\":\"Gliscor\",\"imageUrl\":\"https://images.pokemontcg.io/hgss3/4.png\",\"imageUrlHiRes\":\"https://images.pokemontcg.io/hgss3/4_hires.png\",\"types\":[\"Fighting\"]}";

                                  // var jsonData = jsonDecode(data); // Correctly decode the JSON string
                                  // var item = Pokemon.fromJson(jsonData); // Assuming Pokemon.fromJson can handle this map

                                  // print("item.name: ${item.name}");

                                  // var pokemonRepo = Pokemon(
                                  //   id: item.id,
                                  //   name: item.name,
                                  //   imageUrl: item.imageUrl,
                                  //   imageUrlHiRes: item.imageUrlHiRes,
                                  //   types: List<String>.from(item.types), // Ensure types are a list of Strings
                                  // );

                                  // Navigator.of(context).pushNamed('/detail', arguments: pokemonRepo);

                                  Navigator.pushNamed(context, AppRouter.serachSupplies);

                                  // Navigator.push(
                                  //   context,
                                  //   MaterialPageRoute(builder: (context) => const SerachSuppliseSreen()),
                                  // );
                                } else if (menuItemsModel.id == 2) {
                                  // Navigator.of(
                                  //   context,
                                  // ).pushNamed('/equipmentList', arguments: {'pokemon': menuItems[index]});
                                  //  Navigator.pushNamed(context, AppRouter.mappingTagRfid);
                                  Navigator.pushNamed(context, AppRouter.searchRfid);
                                } else if (menuItemsModel.id == 3) {
                                  Navigator.pushNamed(context, AppRouter.serachFindProperty);
                                }

                                // Navigator.push(context, MaterialPageRoute(builder: (context) => SerachSuppliseSreen()));
                              },
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10), // Add spacing after the bottom card
            ],
          ),
        ),
      ),
    );
  }
}

