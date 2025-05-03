import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:image_picker/image_picker.dart';
import 'package:random_string/random_string.dart';
import 'package:ubgb/services/database.dart';

class EmployeeForm extends StatefulWidget {
  const EmployeeForm({
    super.key,
  });

  @override
  State<EmployeeForm> createState() => _EmployeeFormState();
}

class _EmployeeFormState extends State<EmployeeForm> {
  final _formKey = GlobalKey<FormState>();
  File? _selectedImage;

  late String _enteredName;
  late String _enteredEmployeeId;
  late String _branchName;
  late String _enteredjoining;
  String? _enteredPhone;
  late String _enteredPAddress;
  String? _enteredCAddress;
  String? imageUrl;

  //save employee details
  void _saveDetails() async {
    String Id = randomAlphaNumeric(10);
    final isValid = _formKey.currentState!.validate();

    if (!isValid) {
      return;
    }

    _formKey.currentState!.save();
    //image upload to databasemethods

    //loading spinner
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return SpinKitWaveSpinner(color: Colors.white);
        });
    try {
      if (_selectedImage != null) {
        imageUrl =
            await DatabaseMethods().uploadImage(_selectedImage!, _enteredName);
      } else {
        Fluttertoast.showToast(msg: "Please upload image");
      }
    } catch (e) {
      Fluttertoast.showToast(msg: "Error occured while uploading");
    }

    //map to store details
    Map<String, dynamic> employeeInfo = {
      "Name": _enteredName,
      "Id": Id,
      "Employee Id": _enteredEmployeeId,
      "Branch Name": _branchName,
      "Joining Date": _enteredjoining,
      "Phone No": _enteredPhone,
      "Permanent": _enteredPAddress,
      "Correspondence": _enteredCAddress,
      "ImageUrl": imageUrl
    };

    // saving details to database
    await DatabaseMethods().addEmployeeDetails(employeeInfo, Id);

    Navigator.of(context).pop();
    // toast to display message upon saved successfully
    await Fluttertoast.showToast(msg: "Successfully Added");

    //clearing the input field
    _formKey.currentState!.reset();
  }

  // method of image picker from gallery
  void _takeImage() async {
    final imagePicker = ImagePicker();

    final pickedImage =
        await imagePicker.pickImage(source: ImageSource.gallery);

    if (pickedImage == null) {
      return;
    }

    setState(() {
      _selectedImage = File(pickedImage.path);
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
            'Employee Details Form',
            style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
                letterSpacing: 2),
          ),
        ),
        backgroundColor: Colors.indigo,
        body: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                //Image container
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
                  // field where images will be uploaded
                  child: InkWell(
                    //function call for image
                    onTap: _takeImage,

                    //if image is not null then selected image will be displayed in the container
                    child: _selectedImage != null
                        ? Image.file(
                            _selectedImage!,
                            fit: BoxFit.cover,
                          )
                        : const Icon(
                            Icons.upload_outlined,
                            color: Colors.black,
                            size: 50,
                          ),
                  ),
                ),
                //Name container
                Container(
                  margin: const EdgeInsets.only(top: 50, left: 20, right: 20),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                  width: double.infinity,
                  height: 65,
                  decoration: BoxDecoration(
                      color: Colors.grey.shade600.withOpacity(.4),
                      borderRadius: BorderRadius.circular(15)),
                  child: TextFormField(
                    onSaved: (newValue) {
                      _enteredName = newValue!;
                    },

                    // Name validator
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        //show message upon correct validation

                        return 'Must fill your name';
                      }

                      return null;
                    },
                    decoration: const InputDecoration(
                      hintText: 'Full Name',
                    ),
                  ),
                ),

                //Employee Id
                Container(
                  margin: const EdgeInsets.only(top: 12, left: 20, right: 20),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                  width: double.infinity,
                  height: 65,
                  decoration: BoxDecoration(
                      color: Colors.grey.shade600.withOpacity(.4),
                      borderRadius: BorderRadius.circular(15)),
                  child: TextFormField(
                    onSaved: (newValue) {
                      _enteredEmployeeId = newValue!;
                    },
                    //  validator
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        //show message upon correct validation
                        return 'Must fill your id';
                      }
                      return null;
                    },
                    decoration: const InputDecoration(hintText: 'Employee Id'),
                  ),
                ),

                //Branch Name
                Container(
                  margin: const EdgeInsets.only(top: 12, left: 20, right: 20),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                  width: double.infinity,
                  height: 65,
                  decoration: BoxDecoration(
                      color: Colors.grey.shade600.withOpacity(.4),
                      borderRadius: BorderRadius.circular(15)),
                  child: TextFormField(
                    onSaved: (newValue) {
                      _branchName = newValue!;
                    },

                    //branch Name validator
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        //show message upon correct validation
                        return 'Must fill your branch name';
                      }
                      return null;
                    },
                    decoration: const InputDecoration(hintText: 'Branch Name'),
                  ),
                ),

                //joining date
                Container(
                  margin: const EdgeInsets.only(top: 12, left: 20, right: 20),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                  width: double.infinity,
                  height: 65,
                  decoration: BoxDecoration(
                      color: Colors.grey.shade600.withOpacity(.4),
                      borderRadius: BorderRadius.circular(15)),
                  child: TextFormField(
                    keyboardType: TextInputType.datetime,
                    onSaved: (newValue) {
                      _enteredjoining = newValue!;
                    },

                    //joining date validator
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        //show message upon correct validation
                        return 'Must fill your joining date';
                      }
                      return null;
                    },
                    decoration: const InputDecoration(hintText: 'Joining Date'),
                  ),
                ),

                //Phone No
                Container(
                  margin: const EdgeInsets.only(top: 12, left: 20, right: 20),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                  width: double.infinity,
                  height: 65,
                  decoration: BoxDecoration(
                      color: Colors.grey.shade600.withOpacity(.4),
                      borderRadius: BorderRadius.circular(15)),
                  child: TextFormField(
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
                        return 'Must fill your 10 digit number';
                      }
                      return null;
                    },
                    decoration: const InputDecoration(hintText: 'Phone No'),
                  ),
                ),

                //Permanent Address
                Container(
                  margin: const EdgeInsets.only(top: 12, left: 20, right: 20),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                  width: double.infinity,
                  height: 65,
                  decoration: BoxDecoration(
                      color: Colors.grey.shade600.withOpacity(.4),
                      borderRadius: BorderRadius.circular(15)),
                  child: TextFormField(
                    onSaved: (newValue) {
                      _enteredPAddress = newValue!;
                    },

                    //Address validator
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        //show message upon correct validation
                        return 'Must fill your permanent address';
                      }
                      return null;
                    },
                    decoration:
                        const InputDecoration(hintText: 'Permanent Address'),
                  ),
                ),

                //Correspondance Address
                Container(
                  margin: const EdgeInsets.only(top: 12, left: 20, right: 20),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                  width: double.infinity,
                  height: 65,
                  decoration: BoxDecoration(
                      color: Colors.grey.shade600.withOpacity(.4),
                      borderRadius: BorderRadius.circular(15)),
                  child: TextFormField(
                    onSaved: (newValue) {
                      _enteredCAddress = newValue!;
                    },

                    // validator
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        //show message upon correct validation
                        return 'Must fill your correspondance address';
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                        hintText: 'Correspondence Address'),
                  ),
                ),

                //Button
                Container(
                  margin: const EdgeInsets.only(top: 50, left: 20, right: 20),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                  child: ElevatedButton(
                    //save details function call
                    onPressed: _saveDetails,
                    child: const Text('Save'),
                  ),
                )
              ],
            ),
          ),
        ));
  }
}
