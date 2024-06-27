import 'package:flutter/material.dart';
import 'package:projetoflutterapi/screen/home_screen.dart';
import 'package:projetoflutterapi/screen/register_screen.dart';
import 'package:projetoflutterapi/services/firebase/auth/firebase_auth_service.dart';
import 'package:projetoflutterapi/utils/results.dart';

class LoginPage extends StatelessWidget {
  final FirebaseAuthService _auth = FirebaseAuthService();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: StreamBuilder<Results>(
          stream: _auth.resultsLogin,
          builder: (context, snapshot) {
            ErrorResult result = ErrorResult(code: "");

            if (snapshot.data is ErrorResult) {
              result = snapshot.data as ErrorResult;
            }

            if (snapshot.data is LoadingResult) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.data is SuccessResult) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HomeScreen(),
                  ),
                );
              });
            }

            return Column(
              children: [
                TextField(
                  controller: _emailController,
                  decoration: const InputDecoration(labelText: 'Email'),
                ),
                TextField(
                  controller: _passwordController,
                  decoration: InputDecoration(labelText: 'Password'),
                ),
                ElevatedButton(
                  onPressed: () {
                    final String email = _emailController.text;
                    final String password = _passwordController.text;
                    _auth.signIn(email, password);
                  },
                  child: const Text("Logar"),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => RegisterScreen(),
                      ),
                    );
                  },
                  child: const Text("Registre-se"),
                ),
                if (result.code.isNotEmpty)
                  switch(result.code) {
                    "invalid-email" => Text("Autenticacao Invalida"),
                    "wrong-password" => Text("Autenticacao Invalida"),
                    _ => Text("Error")
                  }

              ],
            );
          },
        ),
      ),
    );
  }
}
