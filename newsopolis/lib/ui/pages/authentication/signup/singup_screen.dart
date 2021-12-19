import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:newsopolis/domain/use_cases/controllers/authentication.dart';
import 'package:newsopolis/domain/use_cases/controllers/connectivity.dart';

class SignUpScreen extends StatefulWidget {
  final VoidCallback onViewSwitch;

  const SignUpScreen({Key? key, required this.onViewSwitch}) : super(key: key);

  @override
  _State createState() => _State();
}

class _State extends State<SignUpScreen> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final controller = Get.find<AuthController>();
  final connectivityController = Get.find<ConnectivityController>();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(0.0),
            child: Image.network(
              'https://i.pinimg.com/564x/ee/18/c6/ee18c65208c10658e0fb360f0e3cb996.jpg',
              width: double.infinity,
              height: 200,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "NEWSOPOLIS",
              style: Theme.of(context).textTheme.headline1,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              key: const Key("signUpName"),
              controller: nameController,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                   borderRadius: BorderRadius.circular(25)
                ),
                labelText: 'Usuario',
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              key: const Key("signUpEmail"),
              controller: emailController,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                   borderRadius: BorderRadius.circular(25)
                ),
                labelText: 'Correo electrónico',
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              key: const Key("signUpPassword"),
              controller: passwordController,
              obscureText: true,
              obscuringCharacter: "*",
              decoration: InputDecoration(
                border: OutlineInputBorder(
                   borderRadius: BorderRadius.circular(25)
                ),
                labelText: 'Contraseña',
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(14.0),
                  child: ElevatedButton(
                    onPressed: () async {
                      if (connectivityController.connected) {
                        await controller.manager.signUp(
                            name: nameController.text,
                            email: emailController.text,
                            password: passwordController.text);
                      } else {
                        Get.showSnackbar(
                          GetBar(
                            message: "No estas conectado a la red.",
                            duration: const Duration(seconds: 2),
                          ),
                        );
                      }
                    },
                    child: const Text("Registrar"),
                    style: ElevatedButton.styleFrom(
                    primary: const Color(0xFF770000),
                    textStyle: const TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontStyle: FontStyle.normal
                    ),
                  ),
                  ),
                ),
              ),
            ],
          ),
          TextButton(
            onPressed: widget.onViewSwitch,
            child: const Text("Entrar"),
            style: TextButton.styleFrom(
              primary: const Color(0xFF690606),
              textStyle: const TextStyle(
                fontSize: 18
              )
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}
