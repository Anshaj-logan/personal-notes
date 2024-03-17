import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';


class ViewNote extends StatefulWidget {
  final Map data;
  final String time;
  final DocumentReference ref;
 ViewNote({required this.data,required this.time,required this.ref});

  @override
  State<ViewNote> createState() => _ViewNoteState();
}

class _ViewNoteState extends State<ViewNote> {
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
                        delete();
                      }),
                      child: Icon(Icons.delete_forever,color: Colors.red[300],))  
                ],
              ),
              SizedBox(
                height: 12,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start, 
               
                children: [
              Text(
               "${widget.data['title']}", 
                style: TextStyle(
                  fontSize: 32,
                  fontFamily: 'lato',
                  fontWeight: FontWeight.bold,
                ),
            
              ),
              Padding(
                padding: const EdgeInsets.only(top: 12,bottom: 8), 
                child: Text(
                 "${widget.time}", 
                 
                  style: TextStyle(
                    fontSize: 24,
                    fontFamily: 'lato',
                
                  ),
                
                ),
              ),
               Container(
                    height: MediaQuery.of(context).size.height * 0.75,
                  
                    child: Text(
                      "${widget.data['description']}", 
                      style: TextStyle(
                        fontSize: 20,
                        fontFamily: 'lato',
                      ))
                
                  ),
                ],
              )
            ],
          ),
        )),
      ),
    );
  }

  void delete() async {
   await widget.ref.delete();

    Navigator.pop(context);
  }
}