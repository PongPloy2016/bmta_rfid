import 'dart:convert';

import 'package:bmta/models/pokemon.dart';
import 'package:bmta/Interface/rfid_repo_interface.dart';
import 'package:http/http.dart' as http;

import 'package:shared_preferences/shared_preferences.dart';

class RFIDRepository implements PokemonRepoInterface {
  static const obtainedKey = 'OBTAINED_KEY';
  static const favoritesKey = 'FAVORITES_KEY';

  @override
  void addToObtainedList(Pokemon pokemon) async {
    var shared = await SharedPreferences.getInstance();
    var pokemonList = shared.getStringList(obtainedKey);

    if (pokemonList == null || pokemonList.isEmpty) {
      shared.setStringList(obtainedKey, [pokemon.toJson()]);
    } else {
      pokemonList.add(pokemon.toJson());
      shared.setStringList(obtainedKey, pokemonList);
    }
  }

  @override
  void addToFavoritesList(Pokemon pokemon) async {
    var shared = await SharedPreferences.getInstance();
    var pokemonList = shared.getStringList(favoritesKey);

    if (pokemonList == null || pokemonList.isEmpty) {
      shared.setStringList(favoritesKey, [pokemon.toJson()]);
    } else {
      pokemonList.add(pokemon.toJson());
      shared.setStringList(favoritesKey, pokemonList);
    }
  }

  @override
  Future<List<Pokemon>> getObtainedPokemon() async {
    var shared = await SharedPreferences.getInstance();
    var pokemonList = shared.getStringList(obtainedKey);

    if (pokemonList == null) {
      return [];
    }

    return pokemonList.map<Pokemon>((json) => Pokemon.fromJson(json)).toList();
  }

  @override
  Future<List<Pokemon>> getFavoritesPokemon() async {
    var shared = await SharedPreferences.getInstance();
    var pokemonList = shared.getStringList(favoritesKey);

    if (pokemonList == null) {
      return [];
    }

    return pokemonList.map<Pokemon>((json) => Pokemon.fromJson(json)).toList();
  }

  @override
  Future<List<Pokemon>> getAllPokemon() async {
    var url = Uri.parse('https://api.pokemontcg.io/v1/cards/');
    final response = await http.get(url);
    List<Pokemon> pokemonList = [];

    if (response.statusCode <= 300) {
      Map<String, dynamic> responseJson = json.decode(response.body);
      responseJson['cards'].forEach((pokemon) {
        pokemonList.add(Pokemon.fromMapJson(pokemon));
      });

      return pokemonList;
    }

    return []; // return empty list if request failed
  }
}
