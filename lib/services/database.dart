import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class DatabaseMethods {
  Future addEmployeeDetails(
      Map<String, dynamic> employeeInfo, String id) async {
    return FirebaseFirestore.instance
        .collection('employeeDetails')
        .doc(id)
        .set(employeeInfo);
  }

  //get employee details from firestore
  Future<Stream<QuerySnapshot>> getEmployeeDetails() async {
    return await FirebaseFirestore.instance
        .collection('employeeDetails')
        .snapshots();
  }

  //edit employee details
  Future editEmployeeDetails(
    Map<String, dynamic> updateInfo,
    String id,
  ) async {
    return await FirebaseFirestore.instance
        .collection('employeeDetails')
        .doc(id)
        .update(updateInfo);
  }

  //delete employee details
  Future deleteEmployeeDetails(String id) async {
    return await FirebaseFirestore.instance
        .collection('employeeDetails')
        .doc(id)
        .delete();
  }

  //upload image to firestorage
  Future<dynamic> uploadImage(File _selectedImg, String enteredName) async {
    try {
      final date = DateTime.now().microsecondsSinceEpoch;
      final fileName = '$enteredName$date';
      Reference storageRef = FirebaseStorage.instance.ref().child('images');

      Reference referenceImageToUpload = storageRef.child(fileName);
      await referenceImageToUpload.putFile(File(_selectedImg.path));

      String imageUrl = await referenceImageToUpload.getDownloadURL();

      return imageUrl;
    } catch (e) {
      return e;
    }
  }

  //get image from firestore
  Future displayImage(String id) async {
    final userdata = await FirebaseFirestore.instance
        .collection('employeeDetails')
        .doc(id)
        .get();
    final String imageUrl = await userdata.data()!['ImageUrl'];
    return imageUrl;
  }

  //add complaint message to firestore
  Future addMessage(Map<String, String> helpMessage, String id) async {
    return FirebaseFirestore.instance
        .collection('helpMessage')
        .doc(id)
        .set(helpMessage);
  }

  //get help message from firestore
  Future<Stream<QuerySnapshot<Map<String, dynamic>>>> getMessage() async {
    return await FirebaseFirestore.instance
        .collection('helpMessage')
        .snapshots();
  }

  //upload circular to firestorage
  Future<String?> uploadCircular(File _selectedfile, String name) async {
    try {
      final date = DateTime.now();
      final fileName = '$name $date';
      Reference storageRef = FirebaseStorage.instance.ref().child('circular');

      Reference uploadCircular = storageRef.child(fileName);
      await uploadCircular.putFile(_selectedfile);

      String imageUrl = await uploadCircular.getDownloadURL();

      return imageUrl;
    } catch (e) {
      return null;
    }
  }

  //add circular file path to firebase firestore
  addCircularFilePath(Map<String, String> filePath) async {
    return await FirebaseFirestore.instance
        .collection('circular')
        .add(filePath);
  }

  //get circular file path from firestore
  getCircularFilePath() async {
    final pdfData =
        await FirebaseFirestore.instance.collection('circular').get();
    //Converting pdfData from querySnapshot to list to be used in itemcount of builder
    return await pdfData.docs.map((e) => {'id': e.id, ...e.data()}).toList();
  }

  // Future<List<Map<String, dynamic>>> getCircularFilePath() async {
  //   try {
  //     final pdfData = await FirebaseFirestore.instance.collection('circular').get();
  //     return pdfData.docs.map((e) => {
  //       'id': e.id,  // Store the document id
  //       ...e.data(),
  //     }).toList();
  //   } catch (e) {
  //     throw Exception('Failed to get circular file paths: $e');
  //   }
  // }

  Future<void> deleteCircular(String id) async {
    try {
      final doc =
          await FirebaseFirestore.instance.collection('circular').doc(id).get();
      final data = doc.data();
      if (data != null && data['url'] != null) {
        final storageRef = FirebaseStorage.instance.refFromURL(data['url']);
        await storageRef.delete();
      }
      await FirebaseFirestore.instance.collection('circular').doc(id).delete();
    } catch (e) {
      throw Exception('Failed to delete circular: $e');
    }
  }
}
