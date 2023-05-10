import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:developer' as devtools show log;

import '../constants/constants_screens.dart';

enum MenuAction { logout }

class NotesScreen extends StatefulWidget {
  const NotesScreen({super.key});

  @override
  State<NotesScreen> createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Notes'),
        actions: [
          //This was done so I could learn about creating popup menu item

          // PopupMenuButton<MenuAction>(onSelected: (value) async {
          //   switch (value) {
          //     case MenuAction.logout:
          //       final nowShouldLogout = await showLogOutDialog(context);
          //       devtools.log(nowShouldLogout.toString());

          //       break;
          //     default:
          //   }
          //   devtools.log(value.toString());
          // }, itemBuilder: (context) {
          //   return [
          //     const PopupMenuItem<MenuAction>(
          //       value: MenuAction.logout,
          //       child: Text('Logout'),
          //     )
          //   ];
          // }),
          IconButton(
              onPressed: () async {
                final shouldLogout = await showLogOutDialog(context);
                devtools.log(shouldLogout.toString());
                if (shouldLogout) {
                  await FirebaseAuth.instance.signOut();
                  Navigator.of(context)
                      .pushNamedAndRemoveUntil(loginRoute, (_) => false);
                }
                // Navigator.of(context).push(MaterialPageRoute(
                //     builder: (context) => const LoginScreen()));
              },
              icon: const Icon(Icons.logout_rounded))
        ],
      ),
    );
  }
}

Future<bool> showLogOutDialog(BuildContext context) {
  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Sign Out'),
        content: const Text('Are you sure you want to sign out?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(true);
            },
            child: const Text('Yes'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(false);
            },
            child: const Text('No'),
          ),
        ],
      );
    },
  ).then((value) => value ?? false);
}
