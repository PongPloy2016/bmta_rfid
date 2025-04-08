import 'package:bmta/app_config.dart';
import 'package:bmta/models/pokemon.dart';
import 'package:bmta/Interface/rfid_repo_interface.dart';
import 'package:flutter/material.dart';


class AllCardsPage extends StatefulWidget {

  const AllCardsPage({Key? key}) : super(key: key);

  @override
  State<AllCardsPage> createState() => _AllCardsPageState();
}

class _AllCardsPageState extends State<AllCardsPage> {
  List<Pokemon> pokemonList = [];
  late PokemonRepoInterface repository;

  @override
  Widget build(BuildContext context) {
    repository = AppConfig.of(context)!.rfidRepo;
    loadAllPokemon();

    return Scaffold(
      appBar: AppBar(title: const Text(' Cards')),
      body: GridView.count(
        childAspectRatio: 0.72,
        crossAxisCount: 2,
        children: List.generate(pokemonList.length, (index) {
          
          var pokemon = pokemonList[index];
          return GestureDetector(
            onTap: () => openDetailScreen(pokemon),
            child: Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Hero(
                tag: pokemon.id,
                child: Image.network(pokemon.imageUrl),
              ),
            ),
          );
        }),
      ),
    );
  }

  void loadAllPokemon() async {
    var allPokemon = await repository.getAllPokemon();
    setState(() {
      pokemonList = allPokemon;
    });
  }

  openDetailScreen(Pokemon pokemon) {
    var pokemonRepo = Pokemon(
      id: pokemon.id,
      name: pokemon.name,
      imageUrl: pokemon.imageUrl,
      imageUrlHiRes: pokemon.imageUrlHiRes,
    types: [...pokemon.types]
    );
    Navigator.of(context).pushNamed('/detail', arguments: {'pokemon': pokemon});
  }
}
