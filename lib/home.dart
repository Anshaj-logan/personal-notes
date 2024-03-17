import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:personal_notes/add_note.dart';
import 'package:personal_notes/login.dart';
import 'package:personal_notes/view_note.dart';

class Home extends StatefulWidget {
  const Home({Key? key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  FirebaseAuth auth = FirebaseAuth.instance;
  late CollectionReference ref;
  List<Color> myColors = [
    Colors.yellow[200]!,
    Colors.red[200]!,
    Colors.green[200]!,
    Colors.deepPurple[200]!,
  ];

  late User? _user;
  late String _userEmail;

  @override
  void initState() {
    super.initState();
    _user = auth.currentUser;
    _userEmail = _user?.email ?? 'Loading...';
    ref = FirebaseFirestore.instance
        .collection('Users')
        .doc(_user?.uid)
        .collection('notes');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => AddNotes()))
              .then((value) {
            print("Calling Set State");
            setState(() {});
          });
        },
        child: Icon(
          Icons.add,
        ),
      ),
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            logout();
          },
          icon: Icon(Icons.logout),
        ),
        title: Text(
          "Mail - ${_userEmail}", 
          style: TextStyle(
            fontSize: 24,
            fontFamily: 'lato',
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: ref.snapshots(),
        builder: ((context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Text(
                "Add Your notes here ......",
                style: TextStyle(
                  fontSize: 24,
                  color: Colors.grey
                  // fontWeight: FontWeight.bold,
                ),
              ),
            );
          }

          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              Random random = new Random();
              Color bg = myColors[random.nextInt(4)];
              Map<dynamic, dynamic> data =
                  snapshot.data!.docs[index].data() as Map<dynamic, dynamic>;
              DateTime mydateTime = data['created'].toDate();
              String formattedTime =
                  DateFormat.yMMMd().add_jm().format(mydateTime);

              return InkWell(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => ViewNote(
                      data: data,
                      ref: snapshot.data!.docs[index].reference,
                      time: formattedTime,
                    ),
                  )).then((value) {
                    setState(() {});
                  });
                },
                child: Card(
                  color: bg,
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "${data['title']}",
                            style: TextStyle(
                              fontSize: 24,
                              fontFamily: 'lato',
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Container(
                          alignment: Alignment.centerRight,
                          child: Text(
                            formattedTime,
                            style: TextStyle(
                              fontSize: 20,
                              fontFamily: 'lato',
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        }),
      ),
    );
  }

  Future<void> logout() async {
    await auth.signOut();
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => LogIn()));
  }
}
