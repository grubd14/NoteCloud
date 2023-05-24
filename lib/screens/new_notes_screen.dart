import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:markdown/markdown.dart' as markdown;
import 'package:note_cloud/auth/auth_service.dart';
import 'package:note_cloud/database/notes_service.dart';

class NewNoteScreen extends StatefulWidget {
  const NewNoteScreen({super.key});

  @override
  State<NewNoteScreen> createState() => _NewNoteScreenState();
}

class _NewNoteScreenState extends State<NewNoteScreen> {
  DatabaseNote? _note;
  late final NoteService _noteService;

  late final TextEditingController _textController;
  String _parsedText = "";

  @override
  void initState() {
    _noteService = NoteService();
    _textController = TextEditingController();
    super.initState();
  }

  void _textControllerListener() async {
    final note = _note;
    if (note == null) {
      return;
    }
    final text = _textController.text;
    await _noteService.updateNotes(
      note: note,
      text: text,
    );
  }

  void _setupTextControllerListener() {
    _textController.removeListener(_textControllerListener);
    _textController.addListener(_textControllerListener);
    _textController.addListener(_parseMarkdown);
  }

  Future<DatabaseNote> createNewNote() async {
    final existingNote = _note;
    if (existingNote != null) {
      return existingNote;
    }
    final currentUser = AuthService.firebase().currentUser!;
    final email = currentUser.email!;
    final owner = await _noteService.getUser(email: email);
    return await _noteService.createNote(owner: owner);
  }

  void _deleteNoteIfTextIsEmpty() {
    final note = _note;
    if (_textController.text.isEmpty && note != null) {
      _noteService.deleteNote(id: note.id);
    }
  }

  void _saveNoteIfTextNotEmpty() {
    final note = _note;
    final text = _textController.text;
    if (note != null && text.isNotEmpty) {
      _noteService.updateNotes(
        note: note,
        text: text,
      );
    }
  }

  void _parseMarkdown() {
    String markdownText = _textController.text;
    String parsedText = markdown.markdownToHtml(markdownText);
    setState(() {
      _parsedText = parsedText;
    });
  }

  @override
  void dispose() {
    _deleteNoteIfTextIsEmpty();
    _saveNoteIfTextNotEmpty();
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Note'),
      ),
      body: Column(
        children: [
          FutureBuilder(
            future: createNewNote(),
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.done:
                  _note = snapshot.data as DatabaseNote;
                  _setupTextControllerListener();
                  return Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: TextField(
                      controller: _textController,
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      decoration: const InputDecoration(
                          hintText: 'Start typing here...'),
                    ),
                  );
                default:
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
              }
            },
          ),
          HtmlWidget(_parsedText)
        ],
      ),
    );
  }
}
