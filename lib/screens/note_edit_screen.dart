import 'package:flutter/material.dart';
import '../models/note.dart';
import '../services/database_helper.dart';

class NoteEditScreen extends StatefulWidget {
  final Note? note;

  NoteEditScreen({this.note});

  @override
  _NoteEditScreenState createState() => _NoteEditScreenState();
}

class _NoteEditScreenState extends State<NoteEditScreen> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.note != null) {
      _titleController.text = widget.note!.title;
      _contentController.text = widget.note!.content;
    }
  }

  void _saveNote() async {
    final title = _titleController.text;
    final content = _contentController.text;
    if (title.isEmpty || content.isEmpty) return;

    final note = Note(
      id: widget.note?.id,
      title: title,
      content: content,
      dateTime: DateTime.now(),
    );

    if (widget.note == null) {
      await DatabaseHelper.instance.insertNote(note);
    } else {
      await DatabaseHelper.instance.updateNote(note);
    }
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.note == null ? 'Создать заметку' : 'Редактировать заметку')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(controller: _titleController, decoration: InputDecoration(labelText: 'Заголовок')),
            TextField(controller: _contentController, decoration: InputDecoration(labelText: 'Содержание')),
            SizedBox(height: 20),
            ElevatedButton(onPressed: _saveNote, child: Text('Сохранить')),
          ],
        ),
      ),
    );
  }
}
