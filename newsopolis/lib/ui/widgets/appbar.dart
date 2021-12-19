import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:newsopolis/domain/use_cases/controllers/themes_controler.dart';
import 'package:newsopolis/domain/use_cases/controllers/ui.dart';

class CustomAppBar extends AppBar {
  final BuildContext context;
  final bool home;
  final String picUrl;
  final Widget tile;
  final VoidCallback onSignOff;
  final UIController controller;
  final ThemesController tController;

  // Creating a custom AppBar that extends from Appbar with super();
  CustomAppBar(
      {Key? key,
      required this.context,
      required this.controller,
      required this.picUrl,
      required this.tController,
      required this.tile,
      required this.onSignOff,
      this.home = true})
      : super(
          key: key,
          centerTitle: true,
          
          leading: Center(
            child: CircleAvatar(
              minRadius: 18.0,
              maxRadius: 18.0,
              backgroundImage: NetworkImage(picUrl),
            ),
          ),
          title: tile,
          actions: [
            IconButton(
              key: const Key("themeAction"),
              icon: const Icon(
                Icons.brightness_4_rounded,
              ),
              onPressed: () {
                tController.manager.changeTheme(isDarkMode: !Get.isDarkMode);
              },
            ),
            IconButton(
              key: const Key("logoutAction"),
              icon: const Icon(
                Icons.logout,
              ),
              onPressed: onSignOff,
            )
          ],
        );
}
