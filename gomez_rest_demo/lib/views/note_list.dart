import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:gomez_rest_demo/models/api_response.dart';
import 'package:gomez_rest_demo/models/note_for_listing.dart';
import 'package:gomez_rest_demo/services/notes_service.dart';
import 'package:gomez_rest_demo/views/note_delete.dart';

import 'note_modify.dart';

class NoteList extends StatefulWidget {
  @override
  _NoteListState createState() => _NoteListState();
}

class _NoteListState extends State<NoteList> {
  NotesService get service => GetIt.I<NotesService>();

  APIResponse<List<NoteForListing>>? _apiResponse;
  bool _isLoading = false;

  String formatDateTime(DateTime dateTime) {
    return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
  }

  @override
  void initState() {
    _fetchNotes();
    super.initState();
  }

  _fetchNotes() async {
    setState(() {
      _isLoading = true;
    });

    _apiResponse = await service.getNotesList();

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('List of notes')),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (_) => NoteModify()))
                .then((_) {
              _fetchNotes();
            });
          },
          child: Icon(Icons.add),
        ),
        body: Builder(
          builder: (_) {
            if (_isLoading) {
              return Center(child: CircularProgressIndicator());
            }

            if (_apiResponse!.error == true) {
              return Center(child: Text(_apiResponse!.errorMessage.toString()));
            }

            return ListView.separated(
              separatorBuilder: (_, __) =>
                  Divider(height: 1, color: Colors.green),
              itemBuilder: (_, index) {
                return Dismissible(
                  key: ValueKey(_apiResponse!.data![index].noteID),
                  direction: DismissDirection.startToEnd,
                  onDismissed: (direction) {},
                  confirmDismiss: (direction) async {
                    final result = await showDialog(
                        context: context, builder: (_) => NoteDelete());

                    if (result) {
                      final deleteResult = await service.deleteNote(_apiResponse!.data![index].noteID);

                      var message;
                      if (deleteResult != null && deleteResult.data == true) {
                        message = 'The note was deleted successfully';
                      } else {
                        message = deleteResult?.errorMessage ?? 'An error occurred';
                      }

                      showDialog(
                          context: context, builder: (_) => AlertDialog(
                        title: Text('Done'),
                        content: Text(message),
                        actions: <Widget>[
                          FlatButton(child: Text('Ok'), onPressed: () {
                            Navigator.of(context).pop();
                          })
                        ],
                      ));

                      return deleteResult?.data ?? false;
                    }
                    print(result);
                    return result;
                  },
                  background: Container(
                    color: Colors.red,
                    padding: EdgeInsets.only(left: 16),
                    child: Align(
                      child: Icon(Icons.delete, color: Colors.white),
                      alignment: Alignment.centerLeft,
                    ),
                  ),
                  child: ListTile(
                    title: Text(
                      _apiResponse!.data![index].noteTitle,
                      style: TextStyle(color: Theme.of(context).primaryColor),
                    ),
                    subtitle: Text(
                        'Last edited on ${formatDateTime(_apiResponse!.data![index].latestEditDateTime ?? _apiResponse!.data![index].createDateTime!)}'),
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (_) => NoteModify(
                              noteID: _apiResponse!.data![index].noteID))).then((data) {
                        _fetchNotes();
                      });
                    },
                  ),
                );
              },
              itemCount: _apiResponse!.data!.length,
            );
          },
        ));
  }
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<APIResponse<List<NoteForListing>>>('_apiResponse', _apiResponse));
  }
}