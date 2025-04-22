
import 'package:bmta_rfid_app/app_router.dart';
import 'package:bmta_rfid_app/models/main/menu_items_card.dart';
import 'package:bmta_rfid_app/themes/colors.dart';
import 'package:bmta_rfid_app/widgets/main/mainListItem.dart';
import 'package:bmta_rfid_app/widgets/main/menuItemCardWidget.dart';
import 'package:flutter/material.dart';

class MainPageScreen extends StatefulWidget {
  const MainPageScreen({super.key});

  @override
  State<MainPageScreen> createState() => _MainPageScreenState();
}

class _MainPageScreenState extends State<MainPageScreen> {
  final titles = ["List 1", "List 2", "List 3,List 1", "List 2", "List 3,List 1", "List 2", "List 3"];
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
    MenuItemCard(
      id: 4,
      name: "ค้นหาครุภัณท์",
      image: "lib/assets/images/ic_menu_box_search_image.png",
      colors: textMainMenuGeenPastel,
    ),
    MenuItemCard(
      id: 5,
      name: "กำหนด TAG ID",
      image: "lib/assets/images/ic_menu_tagid_image.png",
      colors: textMainMenuPink,
    ),
    MenuItemCard(
      id: 6,
      name: "ตรวจสอบทรัพย์สิน",
      image: "lib/assets/images/ic_doc_hand_imag.png",
      colors: textFromMenuPurple,
    ),
    MenuItemCard(
      id: 4,
      name: "ค้นหาครุภัณท์",
      image: "lib/assets/images/ic_menu_box_search_image.png",
      colors: textMainMenuGeenPastel,
    ),
    MenuItemCard(
      id: 5,
      name: "กำหนด TAG ID",
      image: "lib/assets/images/ic_menu_tagid_image.png",
      colors: textMainMenuPink,
    ),
    MenuItemCard(
      id: 6,
      name: "ตรวจสอบทรัพย์สิน",
      image: "lib/assets/images/ic_doc_hand_imag.png",
      colors: textFromMenuPurple,
    ),
    MenuItemCard(
      id: 4,
      name: "ค้นหาครุภัณท์",
      image: "lib/assets/images/ic_menu_box_search_image.png",
      colors: textMainMenuGeenPastel,
    ),
    MenuItemCard(
      id: 5,
      name: "กำหนด TAG ID",
      image: "lib/assets/images/ic_menu_tagid_image.png",
      colors: textMainMenuPink,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Card(
        color: Colors.white,
        margin: const EdgeInsets.all(10),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              // ListView.builder with scroll functionality
              const Flexible(
                flex: 1,
                child: SingleChildScrollView(
                  child: SizedBox(
                    width: double.infinity,
                    child: Column(
                      children: [
                        Text('การแจ้งเตือน', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),

                        // List of warnings with ListView
                      ],
                    ),
                  ),
                ),
              ),

              // Bottom card with total number of items
              const SizedBox(height: 10), // Add spacing after the bottom card

              Flexible(
                  flex: 4,
                child: SingleChildScrollView(
                  child: Card(
                    color: const Color.fromARGB(255, 248, 246, 246),
                    child: Container(
                      child: Column(
                        children: [
                          // Text('การแจ้งเตือน', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),

                          // List of warnings with ListView
                          Card(
                            elevation: 10,
                            color: Color(cardColor),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: [
                                  // Card for the ListView
                                  ListView.builder(
                                    shrinkWrap: true, // Shrinks the ListView to only take as much space as needed
                                    physics: const NeverScrollableScrollPhysics(), // Prevents ListView from scrolling itself
                                    itemCount: titles.length,
                                    itemBuilder: (BuildContext context, int index) {
                                      return Column(
                                        children: [
                                          MainListItem(
                                            id: titles[index],
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
                    ),
                  ),
                ),
              ),

              // Bottom card with total number of items
              const SizedBox(height: 10), // Add spacing after the bottom card

              Flexible(
                flex: 3,
                child: SingleChildScrollView(
                  child: SizedBox(
                    height: 600,
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

class NotificationItem extends StatelessWidget {
  final String tagId;

  const NotificationItem({super.key, required this.tagId});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80,
      decoration: const BoxDecoration(border: Border(bottom: BorderSide(width: 1.5, color: Colors.black))),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: const BoxDecoration(
              image: DecorationImage(image: NetworkImage("https://images.unsplash.com/photo-1547721064-da6cfb341d50")),
            ),
          ),
          const Column(mainAxisSize: MainAxisSize.max, children: [Text("xx"), Expanded(child: Text("description"))]),
          const Text("xxx"),
        ],
      ),
    );
  }
}
