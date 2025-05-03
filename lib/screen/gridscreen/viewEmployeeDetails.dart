import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:ubgb/services/database.dart';

class ViewDetails extends StatefulWidget {
  const ViewDetails({
    super.key,
    required this.employeeSnapshot,
  });

  final DocumentSnapshot employeeSnapshot;

  @override
  State<ViewDetails> createState() => _ViewEmployeeDetailsState();
}

class _ViewEmployeeDetailsState extends State<ViewDetails> {
  Future submit(String id) async {
    final isValid = _formKey.currentState!.validate();
    if (!isValid) {
      return;
    }
    _formKey.currentState!.save();

    //map to store details
    Map<String, dynamic> updateInfo = {
      "Name": _enteredName,
      "Id": id,
      "Employee Id": _enteredEmployeeId,
      "Branch Name": _branchName,
      "Joining Date": _enteredjoining,
      "Phone No": _enteredPhone,
      "Permanent": _enteredPAddress,
      "Correspondence": _enteredCAddress
    };
    await DatabaseMethods()
        .editEmployeeDetails(updateInfo, id)
        .then((value) => Navigator.pop(context));
    //toast message
    await ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text('Updated Successfully')));
  }

  final _formKey = GlobalKey<FormState>();

  late String _enteredName;
  late String _enteredEmployeeId;
  late String _branchName;
  late String _enteredjoining;
  String? _enteredPhone;
  late String _enteredPAddress;
  String? _enteredCAddress;
  String? imageUrl;

  void getImageurl() async {
    final id = widget.employeeSnapshot['Id'];
    final tempUrl = await DatabaseMethods().displayImage(id);

    setState(() {
      imageUrl = tempUrl;
    });
  }

  @override
  void initState() {
    getImageurl();
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //build method
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.indigo,
        leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: const Icon(Icons.arrow_back_ios)),
        centerTitle: true,
        title: Text(
          widget.employeeSnapshot['Name'],
          style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
              letterSpacing: 2),
        ),
      ),
      backgroundColor: Colors.indigo,
      body: SingleChildScrollView(
        child: Column(
          children: [
            //Display all the details of employee
            Container(
                margin: const EdgeInsets.only(
                  top: 50,
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                height: 160,
                width: 160,
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  boxShadow: const [
                    BoxShadow(
                        color: Colors.black, blurRadius: 6, spreadRadius: 1)
                  ],
                ),
                //here in child image will be shown
                child: imageUrl != null
                    ? Image.network(
                        imageUrl!,
                        fit: BoxFit.cover,
                      )
                    : Icon(Icons.person_sharp)),

            //Employee Id
            Container(
              alignment: Alignment.centerLeft,
              margin: const EdgeInsets.only(top: 50, left: 20, right: 20),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              width: double.infinity,
              height: 55,
              decoration: BoxDecoration(
                  color: Colors.grey.shade600.withOpacity(.4),
                  borderRadius: BorderRadius.circular(15)),
              child: Text(
                'Employee Id - ${widget.employeeSnapshot['Employee Id']}',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            //Branch Name
            Container(
              alignment: Alignment.centerLeft,
              margin: const EdgeInsets.only(top: 12, left: 20, right: 20),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              width: double.infinity,
              height: 55,
              decoration: BoxDecoration(
                  color: Colors.grey.shade600.withOpacity(.4),
                  borderRadius: BorderRadius.circular(15)),
              child: Text(
                'Branch Name - ${widget.employeeSnapshot['Branch Name']}',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            //joining date container
            Container(
              alignment: Alignment.centerLeft,
              margin: const EdgeInsets.only(top: 12, left: 20, right: 20),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              width: double.infinity,
              height: 55,
              decoration: BoxDecoration(
                  color: Colors.grey.shade600.withOpacity(.4),
                  borderRadius: BorderRadius.circular(15)),
              child: Text(
                'Joining Date - ${widget.employeeSnapshot['Joining Date']}',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            // phone container
            Container(
              alignment: Alignment.centerLeft,
              margin: const EdgeInsets.only(top: 12, left: 20, right: 20),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              width: double.infinity,
              height: 55,
              decoration: BoxDecoration(
                  color: Colors.grey.shade600.withOpacity(.4),
                  borderRadius: BorderRadius.circular(15)),
              child: Text(
                'Phone -  ${widget.employeeSnapshot['Phone No']}',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            //Permanent Address container
            Container(
              alignment: Alignment.centerLeft,
              margin: const EdgeInsets.only(top: 12, left: 20, right: 20),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              width: double.infinity,
              height: 55,
              decoration: BoxDecoration(
                  color: Colors.grey.shade600.withOpacity(.4),
                  borderRadius: BorderRadius.circular(15)),
              child: Text(
                'Permanent Address -  ${widget.employeeSnapshot['Permanent']}',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            //Corrrespondance container
            Container(
              alignment: Alignment.centerLeft,
              margin: const EdgeInsets.only(top: 12, left: 20, right: 20),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              width: double.infinity,
              height: 55,
              decoration: BoxDecoration(
                  color: Colors.grey.shade600.withOpacity(.4),
                  borderRadius: BorderRadius.circular(15)),
              child: Text(
                'Correspondance Address -  ${widget.employeeSnapshot['Correspondence']}',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    editEmployeeDetails(widget.employeeSnapshot);
                  },
                  icon: Icon(Icons.edit),
                  label: Text('Edit'),
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  //Edit employee details
  editEmployeeDetails(DocumentSnapshot ds) => showDialog(
        context: context,
        builder: (context) => AlertDialog(
            content: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Update Details',
                    style: TextStyle(
                        color: Colors.indigo,
                        fontSize: 20,
                        fontWeight: FontWeight.w800),
                  ),
                  Spacer(),
                  IconButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    icon: Icon(
                      Icons.dangerous,
                      color: Colors.black,
                      size: 35,
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    //Name container
                    Container(
                      margin:
                          const EdgeInsets.only(top: 50, left: 20, right: 20),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                      ),
                      width: double.infinity,
                      height: 58,
                      decoration: BoxDecoration(
                          color: Colors.grey.shade600.withOpacity(.4),
                          borderRadius: BorderRadius.circular(15)),
                      child: TextFormField(
                        initialValue: ds['Name'],
                        onSaved: (newValue) {
                          _enteredName = newValue!;
                        },

                        // Name validator
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Must fill your name';
                          }
                          return null;
                        },
                        decoration:
                            const InputDecoration(hintText: 'Full Name'),
                      ),
                    ),

                    //Employee Id
                    Container(
                      margin:
                          const EdgeInsets.only(top: 12, left: 20, right: 20),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                      ),
                      width: double.infinity,
                      height: 58,
                      decoration: BoxDecoration(
                          color: Colors.grey.shade600.withOpacity(.4),
                          borderRadius: BorderRadius.circular(15)),
                      child: TextFormField(
                        initialValue: ds['Employee Id'],
                        onSaved: (newValue) {
                          _enteredEmployeeId = newValue!;
                        },
                        //  validator
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            //show message upon correct validation
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text('Must fill your Id')));
                          }
                          return null;
                        },
                        decoration:
                            const InputDecoration(hintText: 'Employee Id'),
                      ),
                    ),

                    //Branch Name
                    Container(
                      margin:
                          const EdgeInsets.only(top: 12, left: 20, right: 20),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                      ),
                      width: double.infinity,
                      height: 58,
                      decoration: BoxDecoration(
                          color: Colors.grey.shade600.withOpacity(.4),
                          borderRadius: BorderRadius.circular(15)),
                      child: TextFormField(
                        initialValue: ds['Branch Name'],
                        onSaved: (newValue) {
                          _branchName = newValue!;
                        },

                        // Name validator
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            //show message upon correct validation
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content:
                                        Text('Must fill your Branch Name')));
                          }
                          return null;
                        },
                        decoration:
                            const InputDecoration(hintText: 'Branch Name'),
                      ),
                    ),

                    //joining date
                    Container(
                      margin:
                          const EdgeInsets.only(top: 12, left: 20, right: 20),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                      ),
                      width: double.infinity,
                      height: 58,
                      decoration: BoxDecoration(
                          color: Colors.grey.shade600.withOpacity(.4),
                          borderRadius: BorderRadius.circular(15)),
                      child: TextFormField(
                        initialValue: ds['Joining Date'],
                        keyboardType: TextInputType.datetime,
                        onSaved: (newValue) {
                          _enteredjoining = newValue!;
                        },

                        //joining date validator
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            //show message upon correct validation
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content:
                                        Text('Must fill your Date of Birth')));
                          }
                          return null;
                        },
                        decoration:
                            const InputDecoration(hintText: 'Joining Date'),
                      ),
                    ),

                    //Phone No
                    Container(
                      margin:
                          const EdgeInsets.only(top: 12, left: 20, right: 20),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                      ),
                      width: double.infinity,
                      height: 58,
                      decoration: BoxDecoration(
                          color: Colors.grey.shade600.withOpacity(.4),
                          borderRadius: BorderRadius.circular(15)),
                      child: TextFormField(
                        initialValue: ds['Phone No'],
                        keyboardType: TextInputType.number,
                        onSaved: (newValue) {
                          _enteredPhone = newValue;
                        },

                        //Phone validator
                        validator: (value) {
                          if (value == null ||
                              value.trim().isEmpty ||
                              value.length != 10) {
                            //show message upon correct validation
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text(
                                        'Must fill your 10 digit number')));
                          }
                          return null;
                        },
                        decoration: const InputDecoration(hintText: 'Phone No'),
                      ),
                    ),

                    //Permanent Address
                    Container(
                      margin:
                          const EdgeInsets.only(top: 12, left: 20, right: 20),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                      ),
                      width: double.infinity,
                      height: 58,
                      decoration: BoxDecoration(
                          color: Colors.grey.shade600.withOpacity(.4),
                          borderRadius: BorderRadius.circular(15)),
                      child: TextFormField(
                        initialValue: ds['Permanent'],
                        onSaved: (newValue) {
                          _enteredPAddress = newValue!;
                        },

                        //Address validator
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            //show message upon correct validation
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text('Must fill your Address')));
                          }
                          return null;
                        },
                        decoration: const InputDecoration(
                            hintText: 'Permanent Address'),
                      ),
                    ),

                    //Correspondance Address
                    Container(
                      margin:
                          const EdgeInsets.only(top: 12, left: 20, right: 20),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                      ),
                      width: double.infinity,
                      height: 58,
                      decoration: BoxDecoration(
                          color: Colors.grey.shade600.withOpacity(.4),
                          borderRadius: BorderRadius.circular(15)),
                      child: TextFormField(
                        initialValue: ds['Correspondence'],
                        onSaved: (newValue) {
                          _enteredCAddress = newValue!;
                        },

                        // validator
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            //show message upon correct validation
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text(
                                        'Must fill your Correct Address')));
                          }
                          return null;
                        },
                        decoration: const InputDecoration(
                            hintText: 'Correspondence Address'),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextButton(
                        onPressed: () {
                          var id = ds['Id'];
                          submit(id);
                        },
                        child: Text(
                          'Update',
                          style: TextStyle(
                              fontSize: 25, fontWeight: FontWeight.bold),
                        ))
                  ],
                ),
              ),
            ],
          ),
        )),
      );
}
