import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:ubgb/screen/gridscreen/employee_formScreen.dart';
import 'package:ubgb/screen/gridscreen/viewEmployeeDetails.dart';
import 'package:ubgb/services/database.dart';

class EmployeeDetails extends StatefulWidget {
  const EmployeeDetails({super.key});

  @override
  State<EmployeeDetails> createState() => _EmployeeDetailsState();
}

class _EmployeeDetailsState extends State<EmployeeDetails> {
  Stream? employeeStream;

  getOnTheLoad() async {
    employeeStream = await DatabaseMethods().getEmployeeDetails();
    setState(() {});
  }

  @override
  void initState() {
    getOnTheLoad();
    super.initState();
  }

  // read from the database
  Widget allEmployeeDetails() {
    return StreamBuilder(
        stream: employeeStream,
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
                                  viewEmployeeDetails(ds);
                                },
                                child: const Text('view'),
                              ),

                              //delete button
                              IconButton(
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: ((context) => AlertDialog(
                                            title: Text('Delete Image'),
                                            content: Text(
                                                'Are you sure want to delete'),
                                            actions: [
                                              TextButton(
                                                  onPressed: () async {
                                                    Navigator.of(context).pop();
                                                    await DatabaseMethods()
                                                        .deleteEmployeeDetails(
                                                            ds['Id']);
                                                  },
                                                  child: Text('Yes')),
                                              TextButton(
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                  child: Text('No'))
                                            ],
                                          )),
                                    );
                                  },
                                  icon: Icon(Icons.delete))
                            ],
                          ),
                        ),
                      ],
                    );
                  },
                )
              : Container();
        });
  }

  //view full employee details upon pressing view
  viewEmployeeDetails(DocumentSnapshot ds) {
    //navigate to view employee details screen
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ViewDetails(employeeSnapshot: ds),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //Floating Button
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const EmployeeForm(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),

      //App bar
      appBar: AppBar(
        backgroundColor: Colors.indigo,
        leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: const Icon(Icons.arrow_back_ios)),
        centerTitle: true,
        title: const Text(
          'Employee Details',
          style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
              letterSpacing: 2),
        ),
      ),
      backgroundColor: Colors.indigo,
      body: Container(
        margin: EdgeInsets.only(bottom: 80),
        child: allEmployeeDetails(),
      ),
    );
  }
}
