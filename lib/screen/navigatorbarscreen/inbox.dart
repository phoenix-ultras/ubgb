import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ubgb/services/database.dart';

class Inbox extends StatefulWidget {
  const Inbox({super.key});

  @override
  State<Inbox> createState() => _InboxState();
}

class _InboxState extends State<Inbox> {
  Stream? messageStream;

  //calling from database
  getOnTheLoad() async {
    messageStream = await DatabaseMethods().getMessage();
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    getOnTheLoad();
    super.initState();
  }

  // read from the database
  Widget allMessage() {
    return StreamBuilder(
        stream: messageStream,
        builder: (context, AsyncSnapshot snapshot) {
          return snapshot.hasData
              ? ListView.builder(
                  itemCount: snapshot.data.docs.length,
                  itemBuilder: (context, index) {
                    DocumentSnapshot ds = snapshot.data.docs[index];
                    return Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 13, vertical: 10),
                          margin: const EdgeInsets.only(
                              top: 15, left: 10, right: 10),
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: const [
                              BoxShadow(
                                  color: Colors.black,
                                  blurRadius: 6,
                                  spreadRadius: 1),
                            ],
                          ),
                          child: Row(
                            children: [
                              Text(
                                ds['Name'],
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const Spacer(),
                              //view button
                              TextButton(
                                onPressed: () {
                                  showDialog(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                              content: Text(
                                            ds['Message'],
                                            style: TextStyle(
                                                color: Colors.red,
                                                fontSize: 22,
                                                fontWeight: FontWeight.bold),
                                          )));
                                },
                                child: const Text('view'),
                              ),
                            ],
                          ),
                        )
                      ],
                    );
                  },
                )
              : Container();
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.indigo,
        leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: const Icon(Icons.arrow_back_ios)),
        centerTitle: true,
        title: const Text(
          'Complaint Message',
          style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
              letterSpacing: 2),
        ),
      ),
      backgroundColor: Colors.indigo,
      body: allMessage(),
    );
  }
}
