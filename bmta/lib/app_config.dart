import 'package:bmta/Interface/rfid_repo_interface.dart';
import 'package:flutter/material.dart';

class AppConfig extends InheritedWidget {
  final PokemonRepoInterface rfidRepo;
  final AuthRepoInterface authRepo;
  final MemoListRepoInterface listhRepo;

  const AppConfig(
      {Key? key,
      required Widget child,
      required this.rfidRepo ,
      required this.authRepo,
      required this.listhRepo,}
      ) : super(key: key, child: child);

  static AppConfig? of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<AppConfig>();

  @override
  bool updateShouldNotify(_) => false; // updates to data don't update the UI
}
