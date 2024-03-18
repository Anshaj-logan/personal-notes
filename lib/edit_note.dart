import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:personal_notes/home.dart';

class EditNote extends StatefulWidget {
  final Map data;
  final DocumentReference ref;

  EditNote({required this.data, required this.ref});

  @override
  _EditNoteState createState() => _EditNoteState();
}

class _EditNoteState extends State<EditNote> {
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.data['title']);
    _descriptionController =
        TextEditingController(text: widget.data['description']);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Note'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: 'Title',
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(
                labelText: 'Description',
              ),
              maxLines: null, // Allows multiple lines
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                updateNote();
              },
              child: Text('Save'),
            ),
          ],
        ),
      ),
    );
  }

  void updateNote() {
    widget.ref.update({
      'title': _titleController.text,
      'description': _descriptionController.text,
    }).then((_) {
       Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Home(),
      ),
    );
    }).catchError((error) {
      print("Failed to update note: $error");
      // Handle error
    });
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }
}
