import 'package:flutter/material.dart';
import '../models/note.dart';
import '../services/database_helper.dart';
import 'note_edit_screen.dart';

class NotesListScreen extends StatefulWidget {
  @override
  _NotesListScreenState createState() => _NotesListScreenState();
}

class _NotesListScreenState extends State<NotesListScreen> {
  List<Note> notes = [];

  @override
  void initState() {
    super.initState();
    _loadNotes();
  }

  void _loadNotes() async {
    notes = await DatabaseHelper.instance.getNotes();
    setState(() {});
  }

  void _deleteNote(int id) async {
    await DatabaseHelper.instance.deleteNote(id);
    _loadNotes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Заметки')),
      body: ListView.builder(
        itemCount: notes.length,
        itemBuilder: (context, index) {
          final note = notes[index];
          return ListTile(
            title: Text(note.title),
            subtitle: Text(note.content),
            trailing: IconButton(
              icon: Icon(Icons.delete),
              onPressed: () => _deleteNote(note.id!),
            ),
            onTap: () async {
              await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => NoteEditScreen(note: note))
              );
              _loadNotes();
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () async {
          await Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => NoteEditScreen())
          );
          _loadNotes();
        },
      ),
    );
  }
}
