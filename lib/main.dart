import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import "package:firebase_auth/firebase_auth.dart";
import 'firebase_options.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    themeMode: ThemeMode.dark,
    highContrastDarkTheme: ThemeData.dark(),
    theme: ThemeData(
      colorScheme: const ColorScheme.dark(),
      useMaterial3: true,
    ),
    home: const Homepage(),
  ));
}

class Homepage extends StatelessWidget {
  const Homepage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Home Page"),
        ),
        body: FutureBuilder(
          future: Firebase.initializeApp(
            options: DefaultFirebaseOptions.currentPlatform,
          ),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.done:
                final user = FirebaseAuth.instance.currentUser;
                if (user!.emailVerified) {
                  print("You are verfied");
                } else {
                  print('Verify your Email Address');
                }
                return const Text('Done');
              default:
                return const Text("Loading.......");
            }
          },
        ));
  }
}

class EmailVerifyScreen extends StatefulWidget {
  const EmailVerifyScreen({super.key});

  @override
  State<EmailVerifyScreen> createState() => _EmailVerifyScreenState();
}

class _EmailVerifyScreenState extends State<EmailVerifyScreen> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold();
  }
}
