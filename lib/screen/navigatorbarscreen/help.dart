import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:random_string/random_string.dart';
import 'package:ubgb/services/database.dart';

class HelpDesk extends StatefulWidget {
  const HelpDesk({super.key});

  @override
  State<HelpDesk> createState() => _HelpDeskState();
}

class _HelpDeskState extends State<HelpDesk> {
  //controller
  TextEditingController nameController = TextEditingController();
  TextEditingController messageController = TextEditingController();
  @override
  void dispose() {
    // TODO: implement dispose
    nameController.dispose();
    messageController.dispose();
    super.dispose();
  }

  //
  var _enteredName;
  var _enteredMessage;

  //submit
  void submit() async {
    _enteredName = nameController.text;
    _enteredMessage = messageController.text;
    //validation
    if (_enteredName == null && _enteredMessage == null) {
      return;
    }
    //loading spinner
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return SpinKitWaveSpinner(color: Colors.white);
      },
    );
    String id = _enteredName + randomAlphaNumeric(5);

    Map<String, String> helpMessage = {
      'Name': _enteredName,
      'Message': _enteredMessage,
      'Id': id
    };
    //calling database method and sending name and message to firestore database
    await DatabaseMethods().addMessage(helpMessage, id);
    Navigator.of(context).pop();
    Fluttertoast.showToast(
        msg: "आपकी शिकायत सफलतापूर्वक भेज दी गई है",
        backgroundColor: Colors.grey);

    nameController.clear();
    messageController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.indigo,
      appBar: AppBar(
        backgroundColor: Colors.indigo,
        leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: const Icon(Icons.arrow_back_ios)),
        centerTitle: true,
        title: const Text(
          'Help Desk',
          style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
              letterSpacing: 2),
        ),
      ),
      body: SafeArea(
          child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            width: double.infinity,
            height: 55,
            decoration: BoxDecoration(
                color: Colors.white.withOpacity(.4),
                borderRadius: BorderRadius.circular(15)),
            margin: EdgeInsets.only(top: 10, right: 10, left: 10),
            //name textfield
            child: TextField(
              controller: nameController,
              style: TextStyle(fontSize: 20),
              decoration: InputDecoration(hintText: 'Enter your full name'),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
            width: double.infinity,
            decoration: BoxDecoration(
                color: Colors.white.withOpacity(.4),
                borderRadius: BorderRadius.circular(15)),
            margin: EdgeInsets.only(top: 10, right: 10, left: 10),
            child: Row(
              children: [
                Expanded(
                  //message textfield
                  child: TextField(
                    controller: messageController,
                    style: TextStyle(fontSize: 20),
                    decoration: InputDecoration(
                      hintText: 'Enter your message',
                      focusedBorder: OutlineInputBorder(),

                      // enabledBorder: OutlineInputBorder(
                      //     borderSide: BorderSide(color: Colors.black),
                      // borderRadius: BorderRadius.all(Radius.zero))
                    ),
                    keyboardType: TextInputType.multiline,
                    minLines: 1,
                    maxLines: 5,
                  ),
                ),
                IconButton(onPressed: submit, icon: Icon(Icons.send))
              ],
            ),
          ),
        ],
      )),
    );
  }
}
