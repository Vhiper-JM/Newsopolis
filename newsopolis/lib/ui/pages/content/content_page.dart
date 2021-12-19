import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:newsopolis/domain/use_cases/controllers/authentication.dart';
import 'package:newsopolis/domain/use_cases/controllers/themes_controler.dart';
import 'package:newsopolis/domain/use_cases/controllers/ui.dart';
import 'package:newsopolis/ui/pages/content/chats/chat_screen.dart';
import 'package:newsopolis/ui/pages/content/location/location_screen.dart';
import 'package:newsopolis/ui/pages/content/public_offers/public_offers_screen.dart';
import 'package:newsopolis/ui/pages/content/states/states_screen.dart';
import 'package:newsopolis/ui/pages/content/users_offers/users_offers_screen.dart';
import 'package:newsopolis/ui/widgets/appbar.dart';

class ContentPage extends StatelessWidget {
  const ContentPage({Key? key}) : super(key: key);

// View content
  Widget _getScreen(int index) {
    switch (index) {
      case 1:
        return  LocationScreen();
      case 2:
        return const UsersOffersScreen();
      case 3:
        return const ChatPage();
      case 4:
      return const StatesScreen();
      default:
        return const PublicOffersScreen();
        
    }
  }

  // We create a Scaffold that is used for all the content pages
  // We only define one AppBar, and one scaffold.
  @override
  Widget build(BuildContext context) {
    // Dependency injection: State management controller
    final UIController controller = Get.find<UIController>();
    final AuthController authController = Get.find<AuthController>();
    final ThemesController tController = Get.find<ThemesController>();
    return Scaffold(
      appBar: CustomAppBar(
        context: context,
      
        controller: controller,
        tController: tController,
        picUrl:'https://i.pinimg.com/564x/79/87/0d/79870d3a9a9edbde023494e5977dde7f.jpg',

        tile: const Text("NEWSOPOLIS"),
        onSignOff: () {
          authController.manager.signOut();
        },
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 16.0),
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 100),
            child: Obx(() => _getScreen(controller.reactiveScreenIndex.value)),
          ),
        ),
      ),
      // Content screen navbar
      bottomNavigationBar: Obx(() => BottomNavigationBar(
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.public_outlined,
                  key: Key("offersSection"),
                ),
                label: 'Verificado',
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.place_outlined,
                  key: Key("locationSection"),
                ),
                label: 'Ubicación',
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.home_outlined,
                  key: Key("socialSection"),
                ),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.chat_bubble_outline,
                ),
                label: 'Chats',
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.lightbulb_outline_rounded,
                  key: Key("statesSection"),
                ),
                label: 'Estados',
              ),
              
              
              
              
              
              
            ],
            currentIndex: controller.screenIndex,
            onTap: (index) {
              controller.screenIndex = index;
            },
          )),
    );
  }
}
