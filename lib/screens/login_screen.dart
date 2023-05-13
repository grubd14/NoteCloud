import 'package:flutter/material.dart';
import 'package:note_cloud/auth/auth_exceptions.dart';
import 'package:note_cloud/auth/auth_service.dart';
import 'package:note_cloud/screens/error_dialog.dart';

import '../constants/constants_screens.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late final TextEditingController _email;
  late final TextEditingController _password;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login Screen'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              keyboardType: TextInputType.emailAddress,
              controller: _email,
              decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.all(12),
                  hintText: 'Enter your Email'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              controller: _password,
              obscureText: true,
              decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.all(12),
                  hintText: 'Enter your password'),
            ),
          ),
          TextButton(
            style: const ButtonStyle(
                iconSize: MaterialStatePropertyAll(40),
                elevation: MaterialStatePropertyAll(34)),
            onPressed: () async {
              final email = _email.text;
              final password = _password.text;

              // Navigator.of(context).push(
              //     MaterialPageRoute(builder: (context) => const NotesScreen()));

              try {
                await AuthService.firebase().logIn(
                  email: email,
                  password: password,
                );

                final user = AuthService.firebase().currentUser;
                if (user?.isEmailVerfied ?? false) {
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    notesRoute,
                    (route) => false,
                  );
                } else {
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    verifyEmailRoute,
                    (route) => false,
                  );
                }
                // ignore: use_build_context_synchronously
              } on UserNotFoundAuthException {
                await showErrorDialog(
                  context,
                  'User was not found',
                );
              } on WrongPasswordAuthException {
                await showErrorDialog(
                  context,
                  'You entered the wrong password',
                );
              } on GenericAuthException {
                await showErrorDialog(
                  context,
                  'Authentication error',
                );
              }
            },
            child: const Text('Login'),
          ),
          TextButton(
              onPressed: () {
                Navigator.pushNamedAndRemoveUntil(
                    context, registerRoute, (route) => false);
              },
              child: const Text('Not Registered yet? Register Here'))
        ],
      ),
    );
  }
}
