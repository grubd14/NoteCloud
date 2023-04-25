import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Login Screen"),
        ),
        body: Column(
          children: [
            TextField(),
            TextField(),
            TextButton(
              onPressed: () async {},
              child: const Text('Register'),
            ),
          ],
        ));
  }
}
