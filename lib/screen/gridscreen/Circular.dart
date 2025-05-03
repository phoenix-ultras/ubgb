import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:easy_pdf_viewer/easy_pdf_viewer.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:http/http.dart' as http;

import 'package:ubgb/services/database.dart';
import 'package:ubgb/services/permissionProvider.dart';

class Circular extends ConsumerStatefulWidget {
  const Circular({super.key});

  @override
  ConsumerState<Circular> createState() => _CircularState();
}

class _CircularState extends ConsumerState<Circular> {
  //controller for textfiled to enter circular file name
  TextEditingController nameController = TextEditingController();

  //variable declared
  String? _filename;
  List<Map<String, dynamic>> pdfData = [];
  String? downloadUrl;
  var _pickedFile;
  String? path;

  //pick file from mobile documents
  pickFile(filename) async {
    try {
      _pickedFile = await FilePicker.platform.pickFiles(
          type: FileType.custom,
          allowedExtensions: ['pdf', 'docx', 'doc', 'zip']);

      //get file extension
      //this should be erased

      if (_pickedFile == null) {
        return;
      }

      File file = File(_pickedFile.files[0].path!);
      //loading spinner
      showDialog(
          barrierDismissible: false,
          context: context,
          builder: (context) {
            return SpinKitWaveSpinner(color: Colors.white);
          });

      //upload file to firestorage and get url
      downloadUrl = await DatabaseMethods().uploadCircular(file, filename);

      Future.delayed(
        Duration(seconds: 3),
        () {
          Navigator.of(context).pop();
        },
      );
      if (downloadUrl == null) {
        Fluttertoast.showToast(msg: 'Failed to upload file');
      }
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
    }
  }

  //upload
  upload() async {
    try {
      if (_pickedFile == null) {
        return Fluttertoast.showToast(
            msg: 'Please select file', backgroundColor: Colors.red);
      }
      if (downloadUrl == null || downloadUrl!.isEmpty) {
        print('download url is error');
      }

      DateTime now = DateTime.now();
      String formatedDate = DateFormat('dd,MM, yyyy').format(now);
      //map
      Map<String, String> filePath = {
        'filename': _filename!,
        'url': downloadUrl!,
        'date': formatedDate,
      };

      //calling database methods and storing filepath to firestore
      await DatabaseMethods().addCircularFilePath(filePath);

      Navigator.of(context).pop();
      Fluttertoast.showToast(
          msg: "Circular uploaded successfully", backgroundColor: Colors.grey);
      nameController.clear();

      //refresh the data
      getData();
    } catch (e) {
      Fluttertoast.showToast(msg: '$e', backgroundColor: Colors.red);
      Navigator.of(context).pop();
    }
  }

  // download circular
  download_file(String url) async {
    try {
      //request storage permission
      // if (await Permission.storage.request().isGranted) {
      //download directory
      String? directory = await FilePicker.platform.getDirectoryPath();
      // print(directory);
      // Directory? directory = await getApplicationDocumentsDirectory();

      //get file type or extension
      String fileurl = pdfData[3]['url'];
      final response = await http.head(Uri.parse(fileurl));
      final contentType = response.headers['content-type'];

      String? ext;

      if (contentType == 'application/pdf') {
        ext = '.pdf';
      } else if (contentType ==
          'application/vnd.openxmlformats-officedocument.wordprocessingml.document') {
        ext = '.docx';
      } else if (contentType == 'application/msword') {
        ext = '.doc';
      } else if (contentType == 'application/zip') {
        ext = '.zip';
      }

      //get filepath
      path = "$directory/${pdfData[2]['filename']}$ext";
      // path = '${directory.path}/${pdfData[2]['filename']}';
      print(path);

      Dio dio = Dio();
      double progress = 0.0;
      CancelToken cancelToken = CancelToken();

      //show dialof
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) {
            return AlertDialog(
              backgroundColor: Colors.black,
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator.adaptive(
                    value: progress,
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(
                    "${(progress * 100).toStringAsFixed(0)}%",
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                  TextButton(
                      onPressed: () {
                        cancelToken.cancel();
                        Navigator.of(context).pop();
                      },
                      child: Text('Cancel'))
                ],
              ),
            );
          });
      //start download
      await dio.download(url, path,
          deleteOnError: true,
          cancelToken: cancelToken, onReceiveProgress: (received, total) {
        if (total != -1) {
          double currentProgress = received / total;
          setState(() {
            progress = currentProgress;
          });
        }
      }).then((_) {
        Navigator.of(context).pop();
      });
      // } else if (await Permission.storage.request().isPermanentlyDenied) {
      //   openAppSettings();
      // } else {
      //   Fluttertoast.showToast(msg: 'File permission denied');
      //   openAppSettings();
      // }
      Fluttertoast.showToast(msg: 'File downloaded to $path');
    } catch (e) {
      Fluttertoast.showToast(msg: 'Error: $e', backgroundColor: Colors.red);
    }
  }

  //getfilePath from databsemethods
  getData() async {
    pdfData = await DatabaseMethods().getCircularFilePath();

    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    //getData is called in initState so that this data should be available before widget build
    getData();

    super.initState();
  }

  //dispose
  @override
  void dispose() {
    // TODO: implement dispose
    nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //using provider to check if user is admin or not
    final _isAdmin = ref.watch(isAdminProvider);
    return Scaffold(
      //floating button
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _isAdmin.asData!.value == true
              ? showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      actions: [
                        Column(
                          children: [
                            //textfield to enter name of the file
                            TextField(
                              onChanged: (value) => _filename = value,
                              controller: nameController,
                              style: TextStyle(fontSize: 20),
                              decoration: InputDecoration(
                                  hintText: 'Enter name of the file'),
                            ),
                            //choose file
                            TextButton.icon(
                              onPressed: () {
                                pickFile(_filename);
                              },
                              icon: Icon(Icons.file_copy_outlined),
                              label: Text('Choose file'),
                            ),

                            SizedBox(
                              height: 5,
                            ),
                            //upload button
                            TextButton(
                              onPressed: upload,
                              child: Text(
                                'Upload',
                                style: TextStyle(
                                    color: Colors.black, fontSize: 20),
                              ),
                            )
                          ],
                        )
                      ],
                    );
                  })
              : Fluttertoast.showToast(
                  msg: "You are not authorised", backgroundColor: Colors.red);
        },
        child: const Icon(Icons.note_add_outlined),
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
          'Circular  ',
          style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
              letterSpacing: 2),
        ),
      ),
      backgroundColor: Colors.indigo,
      body: SafeArea(
          child: ListView.builder(
              itemCount: pdfData.length,
              itemBuilder: (context, index) {
                return Container(
                  margin: EdgeInsets.only(top: 10, left: 10, right: 10),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: const [
                      BoxShadow(
                          color: Colors.black, blurRadius: 6, spreadRadius: 1),
                    ],
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: GestureDetector(
                      onTap: () async {
                        // extension
                        String fileurl = pdfData[index]['url'];
                        try {
                          //get file type or extension
                          final response = await http.head(Uri.parse(fileurl));
                          final contentType = response.headers['content-type'];

                          if (contentType != 'application/pdf') {
                            Fluttertoast.showToast(
                                msg: 'File format not supported');
                          } else {
                            //Navigate to pdfViewerscreen to view pdf
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => PdfViewer(
                                      pdfUrl: pdfData[index]['url'],
                                      pdfName: pdfData[index]['filename'],
                                    )));
                          }
                        } catch (e) {
                          Fluttertoast.showToast(
                              msg: '$e', backgroundColor: Colors.red);
                        }
                      },
                      child: Container(
                        margin: EdgeInsets.only(left: 10, right: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  pdfData[index]['filename'],
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color:
                                        const Color.fromARGB(255, 159, 20, 10),
                                  ),
                                ),
                                Text(
                                  'Modified  ' + pdfData[index]['date'],
                                  style: TextStyle(
                                    fontSize: 15,
                                    color:
                                        const Color.fromARGB(255, 159, 20, 10),
                                  ),
                                )
                              ],
                            ),
                            Row(
                              children: [
                                //download circular
                                IconButton(
                                    onPressed: () {
                                      download_file(pdfData[index]['url']);
                                    },
                                    icon: Icon(Icons.download)),
                                IconButton(
                                  //button to delete circular from database
                                  onPressed: () {
                                    _isAdmin.asData!.value == true
                                        ? showDialog(
                                            context: context,
                                            builder: (context) => AlertDialog(
                                              title: Text('Delete Image'),
                                              content: Text(
                                                  'Are you sure you want to delete'),
                                              actions: [
                                                TextButton(
                                                    onPressed: () async {
                                                      try {
                                                        await DatabaseMethods()
                                                            .deleteCircular(
                                                                pdfData[index]
                                                                    ['id']);
                                                        Fluttertoast.showToast(
                                                            msg:
                                                                'Circular deleted successfully');
                                                        Navigator.of(context)
                                                            .pop();
                                                        //refresh database
                                                        getData();
                                                      } catch (e) {
                                                        Fluttertoast.showToast(
                                                            msg:
                                                                'Failed to delete Circular',
                                                            backgroundColor:
                                                                Colors.red);
                                                      }
                                                    },
                                                    child: Text('Yes')),
                                                TextButton(
                                                    onPressed: () {
                                                      Navigator.of(context)
                                                          .pop();
                                                    },
                                                    child: Text('No'))
                                              ],
                                            ),
                                          )
                                        : Fluttertoast.showToast(
                                            msg: 'You are not authorised',
                                            backgroundColor: Colors.red);
                                  },
                                  icon: Icon(
                                    Icons.delete_outline,
                                    color: Colors.red,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              })),
    );
  }
}

//new screen for pdf view

class PdfViewer extends StatefulWidget {
  PdfViewer({super.key, required this.pdfUrl, required this.pdfName});
  final String pdfUrl;
  final String pdfName;

  @override
  State<PdfViewer> createState() => _PdfViewerState();
}

class _PdfViewerState extends State<PdfViewer> {
  PDFDocument? document;
  //
  void initialisePdf() async {
    document = await PDFDocument.fromURL(widget.pdfUrl);
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initialisePdf();
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
          title: Text(
            widget.pdfName,
            style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
                letterSpacing: 2),
          ),
        ),
        backgroundColor: Colors.indigo,
        body: document != null
            ? PDFViewer(
                document: document!,
              )
            : Center(
                child: CircularProgressIndicator(),
              ));
  }
}
