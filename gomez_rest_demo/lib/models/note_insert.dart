import 'package:flutter/foundation.dart';

class NoteManipulation {
  String noteTitle;
  String noteContent;

  NoteManipulation(
      {
        //nullsafety changed rules from old versions
        //edited the @ out
        required this.noteTitle,
        required this.noteContent,
      }
      );

  Map<String, dynamic> toJson() {
    return {
      "noteTitle": noteTitle,
      "noteContent": noteContent
    };
  }
}