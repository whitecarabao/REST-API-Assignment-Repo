class NoteForListing {
  late String noteID;
  late String noteTitle;
  late DateTime createDateTime;
  late DateTime? latestEditDateTime; //added question mark to make nullable :)

  NoteForListing({required this.noteID, required this.noteTitle, required this.createDateTime, required this.latestEditDateTime});

  factory NoteForListing.fromJson(Map<String, dynamic> item) {
    return NoteForListing(
      noteID: item['noteID'],
      noteTitle: item['noteTitle'],
      createDateTime: DateTime.parse(item['createDateTime']),
      latestEditDateTime: item['latestEditDateTime'] != null
          ? DateTime.parse(item['latestEditDateTime'])
          : null,
    );
  }
}