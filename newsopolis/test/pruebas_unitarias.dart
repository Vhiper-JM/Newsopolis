// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.
// ignore_for_file: avoid_print, prefer_const_constructors, deprecated_member_use, unused_import

import 'package:flutter/material.dart';
import 'package:newsopolis/main.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:newsopolis/ui/pages/authentication/login/login_logic_testing/main_login_logic.dart';

void main() {
  const check = '\u2713';
  testWidgets(
      'El usuario intenta loguearse a la pagina sin llenar los '
      'campos de correo electronico y contraseña. Resultado esperado: no podra '
      'entrar ni a su cuenta ni a la aplicacion.', (WidgetTester tester) async {
    // Preparacion
    await tester.pumpWidget(MyApp());
    await tester.pump();
    final textPage = find.text('Login Page');
    await tester.pump();
    final correo = find.text('Correo Electronico');
    await tester.pump();
    final contrasena = find.text('Contraseña');
    await tester.pump();

    expect(textPage, findsOneWidget);
    print('- Ubicacion Confirmada: login_screen ' + check);

    // Accion
    expect(correo, findsOneWidget);
    print('- Espacio para ingreso de correo electronico detectado ' + check);

    expect(contrasena, findsOneWidget);
    print('- Espacio para ingreso de contraseña detectada ' + check);

    await tester.tap(find.byType(FlatButton));
    await tester.pump();
    final requerido = find.text('* Requerido');

    expect(requerido, findsWidgets);
    print('- Espacios de correo y contraseña en blanco ' + check);
    print('- El ususario no pudo loguearse / ingresar ' + check);

    //Resultados
  });

  testWidgets(
      'El usuario intenta loguearse a la pagina al llenar los campos de correo '
      'electronico y contraseña de manera errada. Resultado esperado: no podra '
      'entrar ni a su cuenta ni a la aplicacion.', (WidgetTester tester) async {
    // Preparacion
    await tester.pumpWidget(MyApp());
    await tester.pump();
    final textPage = find.text('Login Page');
    final correo = find.text('Correo Electronico');
    String correoErrado = 'correo.com';
    String contrasenaErrada = 'passw';
    final contrasena = find.text('Contraseña');

    expect(textPage, findsOneWidget);
    print('- Ubicacion Confirmada: login_screen ' + check);

    // Accion
    expect(correo, findsOneWidget);
    print('- Espacio para ingreso de correo electronico detectado ' + check);
    await tester.tap(find.byKey(Key('FormFieldCorreo')));
    await tester.enterText(find.byKey(Key('FormFieldCorreo')), correoErrado);
    print('- Correo ingresado: ' + correoErrado);

    expect(contrasena, findsOneWidget);
    print('- Espacio para ingreso de contraseña detectada ' + check);
    await tester.tap(find.byKey(Key('FormFieldContrasena')));
    await tester.enterText(
        find.byKey(Key('FormFieldContrasena')), contrasenaErrada);
    print('- Contraseña ingresada: ' + contrasenaErrada);

    await tester.tap(find.byType(FlatButton));
    await tester.pump();
    final correoInvalido = find.text('Ingresa un correo electronico valido');
    final contrasenaValida =
        find.text('La contraseña debe tener 6 caracteres como minimo');

    expect(correoInvalido, findsOneWidget);
    print('- Espacio de correo completado erroneamente ' + check);
    expect(contrasenaValida, findsOneWidget);
    print('- Espacio de contraseña completado erroneamente ' + check);
    print('- El ususario no pudo loguearse / ingresar ' + check);

    //Resultados
  });

  testWidgets(
      'El usuario intenta loguearse a la pagina al llenar correctamente el espacio'
      'de correo electronico, per ingresa la contraseña de manera errada. '
      'Resultado esperado: no podra entrar ni a su cuenta ni a la aplicacion.',
      (WidgetTester tester) async {
    // Preparacion
    await tester.pumpWidget(MyApp());
    await tester.pump();
    final textPage = find.text('Login Page');
    final correo = find.text('Correo Electronico');
    String correoValido = 'prueba@correo.com';
    String contrasenaErrada = 'passw';
    final contrasena = find.text('Contraseña');

    expect(textPage, findsOneWidget);
    print('- Ubicacion Confirmada: login_screen ' + check);

    // Accion
    expect(correo, findsOneWidget);
    print('- Espacio para ingreso de correo electronico detectado ' + check);
    await tester.tap(find.byKey(Key('FormFieldCorreo')));
    await tester.enterText(find.byKey(Key('FormFieldCorreo')), correoValido);
    print('- Correo ingresado: ' + correoValido);

    expect(contrasena, findsOneWidget);
    print('- Espacio para ingreso de contraseña detectada ' + check);
    await tester.tap(find.byKey(Key('FormFieldContrasena')));
    await tester.enterText(
        find.byKey(Key('FormFieldContrasena')), contrasenaErrada);
    print('- Contraseña ingresada: ' + contrasenaErrada);

    await tester.tap(find.byType(FlatButton));
    await tester.pump();
    final correoCorrecto = find.text('Correo Electronico');
    final contrasenaValida =
        find.text('La contraseña debe tener 6 caracteres como minimo');

    expect(correoCorrecto, findsOneWidget);
    print('- Espacio de correo completado satisfactoriamente ' + check);
    expect(contrasenaValida, findsOneWidget);
    print('- Espacio de contraseña completado erroneamente ' + check);
    print('- El ususario no pudo loguearse / ingresar ' + check);

    //Resultados
  });

  testWidgets(
      'El usuario intenta loguearse a la pagina al llenar de manera errada el espacio'
      'de correo electronico, pero ingresa la contraseña de manera correcta. '
      'Resultado esperado: no podra entrar ni a su cuenta ni a la aplicacion.',
      (WidgetTester tester) async {
    // Preparacion
    await tester.pumpWidget(MyApp());
    await tester.pump();
    final textPage = find.text('Login Page');
    final correo = find.text('Correo Electronico');
    String correoErrado = 'correo.com';
    String contrasenaValida = 'password';
    final contrasena = find.text('Contraseña');

    expect(textPage, findsOneWidget);
    print('- Ubicacion Confirmada: login_screen ' + check);

    // Accion
    expect(correo, findsOneWidget);
    print('- Espacio para ingreso de correo electronico detectado ' + check);
    await tester.tap(find.byKey(Key('FormFieldCorreo')));
    await tester.enterText(find.byKey(Key('FormFieldCorreo')), correoErrado);
    print('- Correo ingresado: ' + correoErrado);

    expect(contrasena, findsOneWidget);
    print('- Espacio para ingreso de contraseña detectada ' + check);
    await tester.tap(find.byKey(Key('FormFieldContrasena')));
    await tester.enterText(
        find.byKey(Key('FormFieldContrasena')), contrasenaValida);
    print('- Contraseña ingresada: ' + contrasenaValida);

    await tester.tap(find.byType(FlatButton));
    await tester.pump();
    final correoCorrecto = find.text('Ingresa un correo electronico valido');
    final contrasenaCorrecta =
        find.text('Contraseña');

    expect(correoCorrecto, findsOneWidget);
    print('- Espacio de correo completado erroneamente ' + check);
    expect(contrasenaCorrecta, findsOneWidget);
    print('- Espacio de contraseña completado satisfactoriamente ' + check);
    print('- El ususario no pudo loguearse / ingresar ' + check);

    //Resultados
  });

  testWidgets(
    "El usuario intenta loguarse a la pagina al llenar de manera correcta los "
    "espacios Correo electronico y Contraseña. Resultado esperado: El usuario "
    "ingresara a su cuenta y a la aplicacion satisfactoriamente.",
    (WidgetTester tester) async {
      // Preparacion
    await tester.pumpWidget(MyApp());
    await tester.pump();
    final textPage = find.text('Login Page');
    final correo = find.text('Correo Electronico');
    String correoValido = 'prueba@correo.com';
    String contrasenaValida = 'password';
    final contrasena = find.text('Contraseña');

    expect(textPage, findsOneWidget);
    print('- Ubicacion Confirmada: login_screen ' + check);

    // Accion
    expect(correo, findsOneWidget);
    print('- Espacio para ingreso de correo electronico detectado ' + check);
    await tester.tap(find.byKey(Key('FormFieldCorreo')));
    await tester.enterText(find.byKey(Key('FormFieldCorreo')), correoValido);
    print('- Correo ingresado: ' + correoValido);

    expect(contrasena, findsOneWidget);
    print('- Espacio para ingreso de contraseña detectada ' + check);
    await tester.tap(find.byKey(Key('FormFieldContrasena')));
    await tester.enterText(
        find.byKey(Key('FormFieldContrasena')), contrasenaValida);
    print('- Contraseña ingresada: ' + contrasenaValida);

    await tester.tap(find.byType(FlatButton));
    await tester.pump();
    final correoCorrecto = find.text('Correo Electronico');
    final contrasenaCorrecta =
        find.text('Contraseña');

    expect(correoCorrecto, findsOneWidget);
    print('- Espacio de correo completado satisfactoriamente ' + check);
    expect(contrasenaCorrecta, findsOneWidget);
    print('- Espacio de contraseña completado satisfactoriamente ' + check);
    print('- El ususario pudo loguearse / ingresar ' + check);

    //Resultados
    },
  );
}
