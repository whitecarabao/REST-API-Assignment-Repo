import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:gomez_rest_demo/models/note.dart';
import 'package:gomez_rest_demo/models/note_insert.dart';
import 'package:gomez_rest_demo/services/notes_service.dart';

class NoteModify extends StatefulWidget {

  final String? noteID;
  NoteModify({ this.noteID});

  @override
  _NoteModifyState createState() => _NoteModifyState();
}

class _NoteModifyState extends State<NoteModify> {
  bool get isEditing => widget.noteID != null;

  NotesService get notesService => GetIt.I<NotesService>();

  String? errorMessage;
  Note? note;

  TextEditingController _titleController = TextEditingController();
  TextEditingController _contentController = TextEditingController();

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();

    if (isEditing) {
      setState(() {
        _isLoading = true;
      });
      notesService.getNote(widget.noteID.toString())
          .then((response) {
        setState(() {
          _isLoading = false;
        });

        if (response.error) {
          errorMessage = response.errorMessage ?? 'An error occurred';
        }
        note = response.data;
        _titleController.text = note!.noteTitle;
        _contentController.text = note!.noteContent;
        //null checks added
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(isEditing ? 'Edit note' : 'Create note')),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: _isLoading ? Center(child: CircularProgressIndicator()) : Column(
          children: <Widget>[
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                  hintText: 'Note title'
              ),
            ),

            Container(height: 8),

            TextField(
              controller: _contentController,
              decoration: InputDecoration(
                  hintText: 'Note content'
              ),
            ),

            Container(height: 16),

            SizedBox(
              width: double.infinity,
              height: 35,
              child: RaisedButton(
                child: Text('Submit', style: TextStyle(color: Colors.white)),
                color: Theme.of(context).primaryColor,
                onPressed: () async {
                  if (isEditing) {
                    setState(() {
                      _isLoading = true;
                    });
                    final note = NoteManipulation(
                        noteTitle: _titleController.text,
                        noteContent: _contentController.text
                    );
                    final result = await notesService.updateNote(widget.noteID.toString(), note);

                    setState(() {
                      _isLoading = false;
                    });

                    final title = 'Done';
                    final text = result.error  ? (result.errorMessage ?? 'An error occurred') : 'Your note was updated';

                    showDialog(
                        context: context,
                        builder: (_) => AlertDialog(
                          title: Text(title),
                          content: Text(text),
                          actions: <Widget>[
                            FlatButton(
                              child: Text('Ok'),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            )
                          ],
                        )
                    )
                        .then((data) {
                      if (result.data == true) //changed to true and false statements, daryll here {
                        Navigator.of(context).pop();

                    });

                  } else {

                    setState(() {
                      _isLoading = true;
                    });
                    final note = NoteManipulation(
                        noteTitle: _titleController.text,
                        noteContent: _contentController.text
                    );
                    final result = await notesService.createNote(note);

                    setState(() {
                      _isLoading = false;
                    });

                    final title = 'Done';
                    final text = result!.error ? (result.errorMessage ?? 'An error occurred') : 'Your note was created';

                    showDialog(
                        context: context,
                        builder: (_) => AlertDialog(
                          title: Text(title),
                          content: Text(text),
                          actions: <Widget>[
                            FlatButton(
                              child: Text('Ok'),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            )
                          ],
                        )
                    )
                        .then((data) {
                      if (result.data == true ) {
                        Navigator.of(context).pop();
                      }
                    });
                  }
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}