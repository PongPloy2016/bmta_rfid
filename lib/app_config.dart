import 'package:bmta_rfid_app/Interface/rfid_repo_interface.dart';
import 'package:flutter/material.dart';

class AppConfig extends InheritedWidget {
  final AuthRepoInterface authRepo;
  final MemoListRepoInterface listhRepo;

  const AppConfig(
      {super.key,
      required super.child,
      required this.authRepo,
      required this.listhRepo,}
      );

  static AppConfig? of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<AppConfig>();

  @override
  bool updateShouldNotify(_) => false; // updates to data don't update the UI
}
