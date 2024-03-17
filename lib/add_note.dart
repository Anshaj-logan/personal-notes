import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AddNotes extends StatefulWidget {
  const AddNotes({super.key});

  @override
  State<AddNotes> createState() => _AddNotesState();
}

class _AddNotesState extends State<AddNotes> {
  String? title;
  String? desc;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
            child: Container(
          padding: EdgeInsets.all(12.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(elevation: 0),
                      onPressed: (() {
                        Navigator.pop(context);
                      }),
                      child: Icon(Icons.arrow_back_ios_new_outlined)),
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(elevation: 0),
                      onPressed: (() {
                        add();
                      }),
                      child: Text(
                        "Save",
                        style: TextStyle(
                          fontSize: 18,
                          fontFamily: 'lato',
                        ),
                      ))
                ],
              ),
              SizedBox(
                height: 12,
              ),
              Form(
                  child: Column(
                children: [
                  TextFormField(
                    decoration: InputDecoration.collapsed(hintText: "Title"),
                    style: TextStyle(
                      fontSize: 32,
                      fontFamily: 'lato',
                      fontWeight: FontWeight.bold,
                    ),
                    onChanged: (value) {
                      title = value;
                    },
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height * 0.75,
                    padding: const EdgeInsets.only(top: 12),
                    child: TextFormField(
                      decoration: InputDecoration.collapsed(
                          hintText: "Note description"),
                      style: TextStyle(
                        fontSize: 18,
                        fontFamily: 'lato',
                        fontWeight: FontWeight.bold,
                      ),
                      onChanged: (value) {
                        desc = value;
                      },
                      maxLines: 20,
                    ),
                  ),
                ],
              ))
            ],
          ),
        )),
      ),
    );
  }

  void add() async {
    CollectionReference ref = FirebaseFirestore.instance
        .collection('Users')
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .collection('notes');

    var data = {'title': title, 'description': desc, 'created': DateTime.now()};
    ref.add(data);

    Navigator.pop(context);
  }
}
