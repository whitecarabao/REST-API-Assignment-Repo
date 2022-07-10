class Note {
//variables followed from video and content
  String noteID;
  String noteTitle;
  String noteContent;
  DateTime? createDateTime;
  DateTime? latestEditDateTime; //question marks added to make nullable

  //wait, this is just a data model haha
  //recall Sir Dan's lesson on Data Controllers

  //Dart doesn't like null data, the "required" keyword has been added
  Note({required this.noteID, required this.noteTitle, required this.noteContent, required this.createDateTime, required this.latestEditDateTime});

  factory Note.fromJson(Map<String, dynamic> item) {
    return Note(
      noteID: item['noteID'],
      noteTitle: item['noteTitle'],
      noteContent: item['noteContent'],
      createDateTime: DateTime.parse(item['createDateTime']),
      latestEditDateTime: item['latestEditDateTime'] != null
          ? DateTime.parse(item['latestEditDateTime'])
          : null,
    );
  }
}