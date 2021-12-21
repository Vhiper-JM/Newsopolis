
// ignore_for_file: curly_braces_in_flow_control_structures, prefer_const_constructors, prefer_const_constructors_in_immutables, annotate_overrides, avoid_web_libraries_in_flutter

import 'dart:developer';
import 'dart:js';
import 'package:js/js.dart';

import 'package:firebase_core_platform_interface/firebase_core_platform_interface.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import "package:firebase_auth/firebase_auth.dart";
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

typedef Callback = void Function(MethodCall call);

void setupFirebaseAuthMocks([Callback? customHandlers]) {
  TestWidgetsFlutterBinding.ensureInitialized();

  MethodChannelFirebase.channel.setMockMethodCallHandler((call) async {
    if (call.method == 'Firebase#initializeCore') {
      return [
        {
          'name': defaultFirebaseAppName,
          'options': {
            'apiKey': '123',
            'appId': '123',
            'messagingSenderId': '123',
            'projectId': '123',
          },
          'pluginConstants': {},
        }
      ];
    }

    if (call.method == 'Firebase#initializeApp') {
      return {
        'name': call.arguments['appName'],
        'options': call.arguments['options'],
        'pluginConstants': {},
      };
    }

    if (customHandlers != null) {
      customHandlers(call);
    }

    return null;
  });
}

Future<T> neverEndingFuture<T>() async {
  while (true) {
    await Future.delayed(const Duration(minutes: 5));
  }
}

 abstract class AuthService {
  Stream<User> get currentUser;

  get isLoggedIn => null;
}

/// Implementacion de produccion de AuthService
class ProductionAuthService implements AuthService {
  FirebaseAuth get _auth => FirebaseAuth.instance;

  Stream<User> get currentUser =>
      _auth.authStateChanges().map((u) => User.fake());

  @override
  noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

/// Un modelo de usuario quepuede ser falso o legitimo (Firebase User
class User {
  User.fake()
      : name = "John Doe",
        avatar = "https://api.adorable.io/avatars/128/johndoe.png";

  User.fromFirebaseUser(User u)
      : name = u.displayName,
        avatar = u.photoUrl;

  final String name;
  final String avatar;

  get displayName => null;

  get photoUrl => null;
}

/// Servicios que pueden ser cambiados entre Mock y produccion
class Services {
  Services.production() : auth = ProductionAuthService();
  Services.fake() : auth = VarianceProductionAuthService();

  final AuthService auth;
}

class BackAuthService {
  Stream<bool> get isLoggedIn =>
      FirebaseAuth.instance.authStateChanges().map((u) => u != null);
}

class PopularHashtagService {
  Stream<List<String>> get popular => FirebaseDatabase.instance
      .reference()
      .child("/hashtags")
      .onValue
      .map((v) => v.snapshot.value.keys);
}

class LikesService {
  Stream<int> likes(String id) => FirebaseDatabase.instance
      .reference()
      .child("/likes/$id")
      .onValue
      .map((v) => v.snapshot.value);
}

class BackServices implements LoginScreenServices {
  final auth = VarianceProductionAuthService();
  final tags = PopularHashtagService();
  final likes = LikesService();
}

/*
 * Los servicios de login son una minima seccion de los servicios
 * prestados
 */

abstract class LoginScreenServices {
  AuthService get auth;
  PopularHashtagService get tags;
}

/*
 * Creacion de fachada para servicio de login
 */
class FakeLoginScreenServices
    implements LoginScreenServices, AuthService, PopularHashtagService {
  @override
  Stream<bool> get isLoggedIn => Stream.fromIterable([true]);

  @override
  Stream<List<String>> get popular => Stream.fromIterable([
        ["flutter", "dart", "foo", "bar"]
      ]);

  @override
  AuthService get auth => this;

  @override
  PopularHashtagService get tags => this;

  Stream<User> get currentUser => throw UnimplementedError();
}

class VarianceProductionAuthService implements AuthService {
  FirebaseAuth get _auth => FirebaseAuth.instance;

  Stream<User> get currentUser =>
      _auth.authStateChanges().map((u) => User.fake());

  @override
  noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

/// Implementacion b de AuthService
abstract class FakeAuthService implements AuthService {
  Stream<User> get currentUser => Stream.fromIterable([User.fake()]);
}
/*
 * Al implementarlo en la pagina de inicio no existe una diferencia notable
 * en la comunicacion con el Mock a diferencia del servidor en tiempo real
 */
class LoginScreen extends StatelessWidget {
  LoginScreen(this.services, {Key? key}) : super(key: key);

  final LoginScreenServices services;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<bool>(
      stream: services.auth.isLoggedIn,
      builder: (context, snap) {
        /// Loading
        if (snap.hasData == false)
          return Center(
            child: CircularProgressIndicator(),
          );

        /// Logged out
        if (snap.data == false)
          return Center(
            child: Text("You gotta login!"),
          );

        /// Logged in
        else
          return Column(
            children: <Widget>[
              Text("Welcome! Here are some popular tags."),
              StreamBuilder<List<String>>(
                stream: services.tags.popular,
                builder: (context, snap) {
                  /// Loading
                  if (snap.hasData == false) return Text("Loading tags...");

                  /// No tags
                  if (snap.data!.isEmpty)
                    return Text("Nothing is popular right now!");

                  /// Got tags
                  else
                    return Row(
                      children: <Widget>[
                        ...snap.data!.map((tag) => Text(tag)),
                      ],
                    );
                },
              )
            ],
          );
      },
    );
  }
}





















// ignore_for_file: invalid_use_of_visible_for_testing_member, unused_import