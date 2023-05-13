import 'package:flutter/material.dart';
import 'package:note_cloud/auth/auth_service.dart';
import 'package:note_cloud/screens/login_screen.dart';
import 'package:note_cloud/screens/notes_screen.dart';
import 'package:note_cloud/screens/register_screen.dart';
import 'package:note_cloud/screens/verify_email_screen.dart';
import 'constants/constants_screens.dart';

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
    routes: {
      loginRoute: (context) => const LoginScreen(),
      registerRoute: (context) => const RegisterScreen(),
      notesRoute: (context) => const NotesScreen(),
      verifyEmailRoute: (context) => const EmailVerifyScreen()
    },
  ));
}

class Homepage extends StatelessWidget {
  const Homepage({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: AuthService.firebase().initialize(),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            final user = AuthService.firebase().currentUser;
            if (user != null) {
              if (user.isEmailVerfied) {
                return const NotesScreen();
              } else {
                return const EmailVerifyScreen();
              }
            } else {
              return const LoginScreen();
            }

          // final user = FirebaseAuth.instance.currentUser;
          // if (user?.emailVerified ?? false) {
          //   return const Text('Done');
          // } else {
          //   return const EmailVerifyScreen();
          // }
          default:
            return const Text('hello');
        }
      },
    );
  }
}
