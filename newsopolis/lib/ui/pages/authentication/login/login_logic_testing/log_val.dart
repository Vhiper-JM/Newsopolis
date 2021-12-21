// ignore_for_file: use_key_in_widget_constructors, deprecated_member_use, prefer_const_constructors, sized_box_for_whitespace, avoid_print

import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:newsopolis/ui/pages/authentication/login/login_logic_testing/login_screen.dart';


class LoginFormValidation extends StatefulWidget {
  @override
  _LoginFormValidationState createState() => _LoginFormValidationState();
}

class _LoginFormValidationState extends State<LoginFormValidation> {
  GlobalKey<FormState> formkey = GlobalKey<FormState>();

  String? validatePassword(String value) {
    if (value.isEmpty) {
      return "* Required";
    } else if (value.length < 6) {
      return "La contraseña debe tener minimo 6 caracteres";
    } else if (value.length > 15) {
      return "La contraseña no debe ser mayor a 20 caracteres";
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Login Page"),
      ),
      body: SingleChildScrollView(
        child: Form(
          autovalidate: true, //check for validation while typing
          key: formkey,
          child: Column(
            children: <Widget>[
              Padding(
                key: Key('FormFieldCorreo'),
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: TextFormField(
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Correo Electronico',
                        hintText: 'Ingresa una direccion de correo valida'),
                    validator: MultiValidator([
                      RequiredValidator(errorText: "* Requerido"),
                      EmailValidator(errorText: "Ingresa un correo electronico valido"),
                    ])),
              ),
              Padding(
                key: Key('FormFieldContrasena'),
                padding: const EdgeInsets.only(
                    left: 15.0, right: 15.0, top: 15, bottom: 0),
                child: TextFormField(
                    obscureText: true,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Contraseña',
                        hintText: 'Ingresa una contraseña segura'),
                    validator: MultiValidator([
                      RequiredValidator(errorText: "* Requerido"),
                      MinLengthValidator(6,
                          errorText: "La contraseña debe tener 6 caracteres como minimo"),
                      MaxLengthValidator(20,
                          errorText:
                          "La contraseña no deberia tener mas de 20 caracteres")
                    ])
                  //validatePassword,        //Function to check validation
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  
                },
                child: Text(
                  'Olvide mi contraseña',
                  style: TextStyle(color: Colors.white, fontSize: 15),
                ),
              ),
              Container(
                height: 50,
                width: 250,
                decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(20)),
                child: FlatButton(
                  onPressed: () {
                    if (formkey.currentState!.validate()) {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (_) => HomePage()));
                      print("Usuario Validado \u2713");
                    } else {
                      print("Usuario NO Validado \u0058 ");
                    }
                  },
                  child: Text(
                    'Login',
                    style: TextStyle(color: Colors.white, fontSize: 25),
                  ),
                ),
              ),
              SizedBox(
                height: 100,
              ),
              Text('¿Nuevo Usuario? Crea una cuenta')
            ],
          ),
        ),
      ),
    );
  }
}