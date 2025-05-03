import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:image_picker/image_picker.dart';
import 'package:photo_view/photo_view.dart';
import 'package:ubgb/services/permissionProvider.dart';

class Gallery extends ConsumerStatefulWidget {
  const Gallery({super.key});

  @override
  ConsumerState<Gallery> createState() => _GalleryState();
}

class _GalleryState extends ConsumerState<Gallery> {
  List<XFile>? _multiImages;
  List<String>? _fetchUrls = [];

  //fetch image url to display
  Future<void> _fetchImageUrl() async {
    final ref = await FirebaseFirestore.instance.collection('gallery').get();
    final urls = ref.docs.map((doc) => doc['imageUrl'] as String).toList();
    setState(() {
      _fetchUrls = urls;
    });
  }

  //Image selection
  Future<void> _imagePick() async {
    //
    final imagePicker = ImagePicker();
    final List<XFile> pickedImage = await imagePicker.pickMultiImage();
    setState(() {
      _multiImages = pickedImage;
    });

    //function call to upload all images
    _uploadAllImages();
  }

  //upload images to firestorage
  Future<String> _uploadImage(XFile imageFile) async {
    try {
      final storageRef =
          FirebaseStorage.instance.ref().child('gallery/${imageFile.name}');
      final refUpload = await storageRef.putFile(File(imageFile.path));

      final downloadUrl = await storageRef.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    }
    return '';
  }

  _uploadAllImages() async {
    try {
      if (_multiImages == null || _multiImages!.isEmpty) {
        return;
      }
      final downloadUrls = [];

      //fetch downloadUrl from uploadImage
      for (var imageFile in _multiImages!) {
        final url = await _uploadImage(imageFile);

        if (url.isNotEmpty) {
          downloadUrls.add(url);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Some error Occurred'),
            backgroundColor: Colors.red,
          ));
        }
      }
      //saving downloadUrls to firebase Firestore
      final ref = FirebaseFirestore.instance.collection('gallery');
      final batch = FirebaseFirestore.instance.batch();
      for (var i = 0; i < downloadUrls.length; i++) {
        final docRef = ref.doc();
        batch.set(docRef, {'imageUrl': downloadUrls[i]});
      }
      batch.commit();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
          backgroundColor: Colors.red,
        ),
      );
    }
    //calling fetch image to display
    _fetchImageUrl();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _fetchImageUrl();
  }

  @override
  Widget build(BuildContext context) {
    //using provider to check if user is admin or not
    final _isAdmin = ref.watch(isAdminProvider);

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        //function call
        onPressed: () {
          _isAdmin.asData!.value == true
              ? _imagePick()
              : Fluttertoast.showToast(
                  msg: 'You are not authorised', backgroundColor: Colors.red);
        },
        child: Icon(Icons.add),
      ),
      appBar: AppBar(
        backgroundColor: Colors.indigo,
        leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: const Icon(Icons.arrow_back_ios)),
        centerTitle: true,
        title: const Text(
          'Gallery',
          style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
              letterSpacing: 2),
        ),
      ),
      backgroundColor: Colors.indigo,
      body: _fetchUrls != null
          ? GridView.builder(
              gridDelegate:
                  SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
              itemCount: _fetchUrls!.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onLongPress: () async {
                    //here make option for deleting images from firebase
                    if (_isAdmin.asData!.value == true) {
                      bool? confirmDelete = await showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text('Delete Image'),
                          content: Text(
                              'Are you sure you want to delete this image?'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(false),
                              child: Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(true),
                              child: Text('Delete'),
                            ),
                          ],
                        ),
                      );

                      if (confirmDelete == true) {
                        // Get image URL
                        String imageUrl = _fetchUrls![index];

                        // Find the corresponding document in Firestore
                        final ref = FirebaseFirestore.instance
                            .collection('gallery')
                            .where('imageUrl', isEqualTo: imageUrl);
                        final snapshot = await ref.get();

                        if (snapshot.docs.isNotEmpty) {
                          // Delete the document
                          await snapshot.docs.first.reference.delete();

                          // Delete the image from Firebase Storage
                          final storageRef =
                              FirebaseStorage.instance.refFromURL(imageUrl);
                          await storageRef.delete();

                          // Update the UI
                          setState(() {
                            _fetchUrls!.removeAt(index);
                          });

                          Fluttertoast.showToast(
                              msg: 'Image deleted successfully');
                        }
                      }
                    } else {
                      Fluttertoast.showToast(
                        msg: 'You are not authorized to delete this image',
                        backgroundColor: Colors.red,
                      );
                    }
                  },
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) => Container(
                          // height: 160,
                          padding: EdgeInsets.all(5),
                          child: PhotoView(
                              imageProvider: NetworkImage(_fetchUrls![index]))),
                    );
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 10),
                    decoration: const BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black26,
                            blurRadius: 6,
                            spreadRadius: 1)
                      ],
                      borderRadius: BorderRadius.all(
                        Radius.circular(20),
                      ),
                    ),
                    child: Image.network(
                      _fetchUrls![index],
                      fit: BoxFit.cover,
                    ),
                  ),
                );
              })
          : Container(),
    );
  }
}
