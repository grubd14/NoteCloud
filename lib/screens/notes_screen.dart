import 'package:flutter/material.dart';
import 'package:note_cloud/auth/auth_service.dart';
import 'package:note_cloud/database/notes_service.dart';
import 'dart:developer' as devtools show log;

import '../constants/constants_screens.dart';

enum MenuAction { logout }

class NotesScreen extends StatefulWidget {
  const NotesScreen({super.key});

  @override
  State<NotesScreen> createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  late final NoteService _noteService;

  String get userEmail => AuthService.firebase().currentUser!.email!;

//notes service on the init state
//opens the database

  @override
  void initState() {
    _noteService = NoteService();
    _noteService.open();
    super.initState();
  }

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
                  await AuthService.firebase().logOut();
                  Navigator.of(context)
                      .pushNamedAndRemoveUntil(loginRoute, (_) => false);
                }
                // Navigator.of(context).push(MaterialPageRoute(
                //     builder: (context) => const LoginScreen()));
              },
              icon: const Icon(Icons.logout_rounded))
        ],
      ),
      body: FutureBuilder(
        future: _noteService.getOrCreateUser(email: userEmail),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              return StreamBuilder(
                stream: _noteService.allNotes,
                builder: (context, snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                      return const Text('Waiting for all notes to load ');
                    case ConnectionState.active:
                      if (snapshot.hasData) {
                        final allNotes = snapshot.data as List<DatabaseNote>;
                        return ListView.builder(
                          itemCount: allNotes.length,
                          itemBuilder: (context, index) {
                            final note = allNotes[index];
                            return ListTile(
                              title: Text(
                                note.text,
                                maxLines: 1,
                                softWrap: true,
                                overflow: TextOverflow.ellipsis,
                              ),
                            );
                          },
                        );
                      } else {
                        return const CircularProgressIndicator();
                      }
                    default:
                      return const CircularProgressIndicator();
                  }
                },
              );
            default:
              return const CircularProgressIndicator();
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add_circle_outline_rounded),
        onPressed: () async {
          Navigator.of(context).pushNamed(
            newNoteRoute,
          );
        },
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
