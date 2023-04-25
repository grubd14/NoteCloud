import 'package:flutter/material.dart';
import 'package:note_cloud/screens/login_screen.dart';

void main() => runApp(MaterialApp(
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.dark,
      highContrastDarkTheme: ThemeData.dark(),
      theme: ThemeData(
        useMaterial3: true,
      ),
      home: const LoginScreen(),
    ));
