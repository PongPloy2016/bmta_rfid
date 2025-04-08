import 'package:bmta/app_config.dart';
import 'package:bmta/models/pokemon.dart';
import 'package:bmta/Interface/rfid_repo_interface.dart';
import 'package:flutter/material.dart';

class DetailPage extends StatefulWidget {
  const DetailPage({Key? key}) : super(key: key);

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  Map routeData = {};
  late Pokemon pokemon;
  bool showExpandedCard = false;
  late PokemonRepoInterface repository;

  @override
  Widget build(BuildContext context) {
    routeData = ModalRoute.of(context)?.settings.arguments as Map;
    pokemon = routeData['pokemon'];
    repository = AppConfig.of(context)!.rfidRepo;

    return Scaffold(
      appBar: AppBar(
        title: Text(pokemon.name),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () => addToFavoritesList(pokemon),
              icon: const Icon(Icons.favorite)),
          IconButton(
              onPressed: () => addToObtainedList(pokemon),
              icon: const Icon(Icons.person_add))
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () => modifyCardExhibitionState(),
              child: Visibility(
                visible: !showExpandedCard,
                child: Hero(
                  tag: pokemon.id,
                  child: Image.network(pokemon.imageUrl),
                ),
              ),
            ),
            GestureDetector(
              onTap: () => modifyCardExhibitionState(),
              child: Visibility(
                visible: showExpandedCard,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Image.network(pokemon.imageUrlHiRes),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  modifyCardExhibitionState() {
    setState(() {
      showExpandedCard = !showExpandedCard;
    });
  }

  addToFavoritesList(Pokemon pokemon) {
    repository.addToFavoritesList(pokemon);
    ScaffoldMessenger.of(context).showSnackBar(
        (const SnackBar(content: Text('Added to Favorites List'),
    )));
  }

  addToObtainedList(Pokemon pokemon) {
    repository.addToObtainedList(pokemon);
    ScaffoldMessenger.of(context).showSnackBar(
        (const SnackBar(content: Text('Added to Obtained List'),
    )));
  }
}
