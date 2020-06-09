import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:intl/intl.dart';
import 'package:notekeeper/models/note.dart';
import 'package:notekeeper/screens/note_list.dart';
import 'package:notekeeper/utils/database_helper.dart';
import 'dart:io';

class NoteDetail extends StatefulWidget {
  final String appBarTitle;
  final Note note;

  NoteDetail(this.note, this.appBarTitle);

  @override
  State<StatefulWidget> createState() {
    return NoteDetailState(this.note, this.appBarTitle);
  }
}

class NoteDetailState extends State<NoteDetail> {
  String appBarTitle;
  Note note;

  NoteDetailState(this.note, this.appBarTitle);

  var priority = ['High', 'Low'];

  DatabaseHelper helper = DatabaseHelper();

  var _minPadding = 5.0;
  TextEditingController titleController = TextEditingController();

  TextEditingController detailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    titleController.text = note.title;
    detailController.text = note.description;
    return WillPopScope(
        onWillPop: () {
          moveToLastScreen();
        },
        child: Scaffold(
            appBar: AppBar(
              title: Text(appBarTitle),
            ),
            body: getListView(context)));
  }

  Padding getListView(context) {
    return Padding(
        padding: EdgeInsets.only(
            top: _minPadding * 3, left: _minPadding, bottom: _minPadding * 2),
        child: ListView(
          children: <Widget>[
            DropdownButton<String>(
              items: priority.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              value: getPriorityAsString(note.priority),
              onChanged: (String newValue) {
                setState(() {
                  updatePriorityAsInt(newValue);
                });
              },
            ),
            Padding(
                padding: EdgeInsets.only(top: _minPadding * 3),
                child: TextFormField(
                  controller: titleController,
                  onChanged: (value) {
                    updateTitle();
                  },
                  validator: (String value) {
                    if (value == null) {
                      return "Please add title";
                    } else
                      return null;
                  },
                  decoration: InputDecoration(
                      labelStyle: TextStyle(fontSize: 18.0),
                      labelText: 'Title',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0))),
                )),
            Padding(
                padding: EdgeInsets.only(top: _minPadding * 3),
                child: TextFormField(
                  controller: detailController,
                  onChanged: (value) {
                    debugPrint('The current title value is $value');
                    updateDescription();
                  },
                  decoration: InputDecoration(
                      labelText: 'Description',
                      labelStyle: TextStyle(fontSize: 18.0),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0))),
                )),
            Padding(
                padding: EdgeInsets.only(top: _minPadding * 3),
                child: Row(
                  children: <Widget>[
                    Expanded(
                        child: RaisedButton(
                      color: Theme.of(context).primaryColorDark,
                      textColor: Theme.of(context).primaryColorLight,
                      onPressed: () {
                        setState(() {
                          debugPrint('Save Clicked');
                          _save();
                        });
                      },
                      child: Text(
                        'Save',
                        textScaleFactor: 1.5,
                      ),
                    )),
                    Container(width: _minPadding),
                    Expanded(
                        child: RaisedButton(
                      color: Colors.blueGrey,
                      textColor: Colors.white,
                      onPressed: () {
                        setState(() {
                          debugPrint('Delete Clicked');
                          _delete();
                        });
                      },
                      child: Text(
                        'Delete',
                        textScaleFactor: 1.5,
                      ),
                    ))
                  ],
                ))
          ],
        ));
  }

  void updatePriorityAsInt(String value) {
    switch (value) {
      case 'High':
        note.priority = 1;
        break;
      case 'Low':
        note.priority = 2;
        break;
    }
  }

  String getPriorityAsString(int value) {
    String prioritys;
    switch (value) {
      case 1:
        prioritys = priority[0];
        break;
      case 2:
        prioritys = priority[1];
        break;
    }

    return prioritys;
  }

  void updateTitle() {
    note.title = titleController.text;
  }

  void updateDescription() {
    note.description = detailController.text;
    debugPrint('The note description value is $note.description');
  }

  void _save() async {
    moveToLastScreen();
    note.date = DateFormat.yMMMd().format(DateTime.now());
    int result;
    if (note.id != null) {
      result = await helper.updateNote(note);
    } else {
      result = await helper.insertNote(note);
    }

    if (result != 0) {
      _showAlertDialog('Status', 'Note Saved Succesfully');
    } else {
      _showAlertDialog('Status', 'Error Saving Note');
    }
  }

  void _delete() async {
    moveToLastScreen();
    int result;
    if (note.id == null) {
      _showAlertDialog('Status', 'Nothing to delete');
    } else {
      result = await helper.deleteNote(note.id);
    }

    if (result != 0) {
      _showAlertDialog('Status', 'Note Deleted Succesfully');
    } else {
      _showAlertDialog('Status', 'Error Deleting Note');
    }
  }

  void _showAlertDialog(String title, String msg) {
    AlertDialog alertDialog = AlertDialog(
      title: Text(title),
      content: Text(msg),
    );
    showDialog(context: context, builder: (_) => alertDialog);
  }

  void moveToLastScreen() {
    Navigator.pop(context, true);
  }
}
