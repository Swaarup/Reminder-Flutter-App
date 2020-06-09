import 'package:flutter/material.dart';
import 'package:notekeeper/screens/note_detail.dart';
import 'package:notekeeper/screens/note_list.dart';

void main() {
  runApp(NoteApp());
}

class NoteApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
      title: 'Notes',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.deepOrange),
      home: NoteList(),
    );
  }
}
