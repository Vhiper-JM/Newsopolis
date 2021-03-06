// ignore_for_file: use_key_in_widget_constructors, unused_import, non_constant_identifier_names
import 'dart:developer';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:newsopolis/data/repositories/google_auth.dart';
import 'package:newsopolis/data/repositories/password_auth.dart';
import 'package:newsopolis/domain/repositorires/auth.dart';
import 'package:newsopolis/domain/use_cases/auth_management.dart';
import 'package:newsopolis/domain/use_cases/controllers/authentication.dart';
import 'package:newsopolis/domain/use_cases/controllers/chat_controller.dart';
import 'package:newsopolis/domain/use_cases/controllers/connectivity.dart';
import 'package:newsopolis/domain/use_cases/controllers/location_controller.dart';
import 'package:newsopolis/domain/use_cases/controllers/permissions_controller.dart';
import 'package:newsopolis/domain/use_cases/controllers/themes_controler.dart';
import 'package:newsopolis/domain/use_cases/controllers/ui.dart';
import 'package:newsopolis/domain/use_cases/permissions_management.dart';
import 'package:newsopolis/domain/use_cases/themes_management.dart';
import 'package:newsopolis/ui/pages/authentication/auth_page.dart';
import 'package:newsopolis/ui/pages/content/content_page.dart';
import 'package:newsopolis/ui/theme/theme.dart';
import 'package:newsopolis/lib.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:firebase_storage_mocks/firebase_storage_mocks.dart';
import 'package:google_sign_in_mocks/google_sign_in_mocks.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';

class Asnapshot {
  final bool connection_state;
  final bool has_error;

  const Asnapshot(this.connection_state, this.has_error);
}

void main() => runApp(const App());

class App extends StatefulWidget {
  const App({Key? key}) : super(key: key);

  @override
  _AppState createState() => _AppState();
}


class _AppState extends State<App> {
  // The future is part of the state of our widget. We should not call `initializeApp`
  // directly inside [build].
  final Future<String> _initialization = Future<String>.delayed(
    const Duration(seconds: 2),
    () => 'Data Loaded',
  );


  // This widget is the root of your application.
  @override
  noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
  @override
  Widget build(BuildContext context) {
    _stateManagementInit();
    return FutureBuilder(
      // The FutureBuilder will create a widget based on the latest snapshot of interaction with a [Future]
      // Initialize FlutterFire:
      future: _initialization,
      builder: (context, snapshot) {
        // Check for errors
        if (snapshot.hasError) {
          return const MaterialApp(
            home: Center(
              child: Text("Hubo un error con firebase"),
            ),
          );
        }

        // Once complete, show your application
        if (snapshot.connectionState == ConnectionState.done) {
          _firebaseStateInit();
          return GetMaterialApp(
            title: 'Newsopolis',
            // Quitamos el banner DEBUG
            debugShowCheckedModeBanner: false,
            // Establecemos el tema claro
            theme: MyTheme.ligthTheme,
            // Establecemos el tema oscuro
            darkTheme: MyTheme.darkTheme,
            // Por defecto tomara la seleccion del sistema
            themeMode: ThemeMode.system,
            home: const AuthenticationPage(),
            // We add the two possible routes
            routes: {
              '/auth': (context) => const AuthenticationPage(),
              '/content': (context) => const ContentPage(),
            },
          );
        }

        // Otherwise, show something whilst waiting for initialization to complete
        return const MaterialApp(
          home: Center(child: CircularProgressIndicator()),
        );
      },
    );
  }

  void _stateManagementInit() {
    // Dependency Injection
    ThemesController themesController = Get.put(ThemesController());
    themesController.themeManager = ThemeManager();

    // Reactive
    ever(themesController.reactiveBrightness, (bool isDarkMode) {
      themesController.manager.changeTheme(isDarkMode: isDarkMode);
    });

    // Permisos

    PermissionsController permissionsController =
        Get.put(PermissionsController());
    permissionsController.permissionManager = PermissionManager();

    // Localizaci??n

    Get.put(LocationController());

    // Dependency Injection
    Get.put(UIController());
    // Auth Controller
    AuthController authController = Get.put(AuthController());

    // State management: listening for changes on using the reactive var
    ever(authController.reactiveAuth, (bool authenticated) {
      // Using Get.off so we can't go back when auth changes
      // This navigation triggers automatically when auth state changes on the app state
      if (authenticated) {
        Get.offNamed('/content');
      } else {
        Get.offNamed('/auth');
      }
    });
    // Connectivity Controller
    ConnectivityController connectivityController =
        Get.put(ConnectivityController());
    // Connectivity stream
    Connectivity().onConnectivityChanged.listen((connectivityStatus) {
      log("connection changed");
      connectivityController.connectivity = connectivityStatus;
    });
  }

  _firebaseStateInit() {
    AuthController authController = Get.find<AuthController>();
    // Setting manager
    authController.authManagement = AuthManagement(
      auth: PasswordAuth(),
      googleAuth: GoogleAuth(),
    );
    // Watching auth state changes
    AuthInterface.authStream.listen(
      (user) => authController.currentUser = user,
    );
    Get.put(ChatController());
  }
}

/* class PreparativoApp extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    _stateManagementInit();
    return FutureBuilder(           // The FutureBuilder will create a widget based on the latest snapshot of interaction with a [Future] 
      // Initialize FlutterFire:
      future: _initialization,
      builder: (context, snapshot) {
        // Check for errors
        if (snapshot.hasError) {
          return const MaterialApp(
            home: Center(
              child: Text("Hubo un error con firebase"),
            ),
          );
        }

        // Once complete, show your application
        if (snapshot.connectionState == ConnectionState.done) {
          _firebaseStateInit();
          return GetMaterialApp(
            title: 'Newsopolis',
            // Quitamos el banner DEBUG
            debugShowCheckedModeBanner: false,
            // Establecemos el tema claro
            theme: MyTheme.ligthTheme,
            // Establecemos el tema oscuro
            darkTheme: MyTheme.darkTheme,
            // Por defecto tomara la seleccion del sistema
            themeMode: ThemeMode.system,
            home: const AuthenticationPage(),
            // We add the two possible routes
            routes: {
              '/auth': (context) => const AuthenticationPage(),
              '/content': (context) => const ContentPage(),
            },
          );
        }

        // Otherwise, show something whilst waiting for initialization to complete
        return const MaterialApp(
          home: Center(child: CircularProgressIndicator()),
        );
      },
    );
  }
}
 */

