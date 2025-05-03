// import 'package:easy_pdf_viewer/easy_pdf_viewer.dart';
// import 'package:flutter/material.dart';

// class Act extends StatefulWidget {
//   const Act({super.key});

//   @override
//   State<Act> createState() => _ActState();
// }

// class _ActState extends State<Act> {
//   List<String> _pdfList = [
//     'assets\Service Regulations 2010.pdf',
//   ];

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       //App bar
//       appBar: AppBar(
//         backgroundColor: Colors.indigo,
//         leading: IconButton(
//             onPressed: () {
//               Navigator.of(context).pop();
//             },
//             icon: const Icon(Icons.arrow_back_ios)),
//         centerTitle: true,
//         title: const Text(
//           'Act',
//           style: TextStyle(
//               color: Colors.white,
//               fontSize: 20,
//               fontWeight: FontWeight.bold,
//               letterSpacing: 2),
//         ),
//       ),
//       backgroundColor: Colors.indigo,
//       body: SafeArea(
//         child: GridView.builder(
//           shrinkWrap: true,
//           gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//             crossAxisCount: 2,
//             childAspectRatio: 1.1,
//           ),
//           itemCount: _pdfList.length,
//           itemBuilder: (ctx, index) => GestureDetector(
//             child: Container(
//               height: 100,
//               width: 100,
//               margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
//               decoration: const BoxDecoration(
//                 boxShadow: [
//                   BoxShadow(
//                       color: Colors.black26, blurRadius: 6, spreadRadius: 1)
//                 ],
//                 borderRadius: BorderRadius.all(
//                   Radius.circular(20),
//                 ),
//               ),
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Image.asset(
//                     'assets/images/pdf.jpeg',
//                     fit: BoxFit.cover,
//                   ),
//                   Text('Service Regulation Act 2010'),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:easy_pdf_viewer/easy_pdf_viewer.dart';
import 'package:flutter/material.dart';

class Act extends StatefulWidget {
  const Act({super.key});

  @override
  State<Act> createState() => _ActState();
}

class _ActState extends State<Act> {
  List<String> _pdfList = [
    'assets/Service Regulations 2010.pdf',
  ];

  void _openPDF(String path) async {
    // Load PDF document from assets
    final document = await PDFDocument.fromAsset(path);

    // Navigate to a new screen to display the PDF
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PDFViewerScreen(document: document),
      ),
    );
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
          icon: const Icon(Icons.arrow_back_ios),
        ),
        centerTitle: true,
        title: const Text(
          'Act',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
            letterSpacing: 2,
          ),
        ),
      ),
      backgroundColor: Colors.indigo,
      body: SafeArea(
        child: GridView.builder(
          padding: EdgeInsets.all(10),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.75,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ),
          itemCount: _pdfList.length,
          itemBuilder: (ctx, index) => GestureDetector(
            onTap: () => _openPDF(_pdfList[index]),
            child: Container(
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 6,
                    spreadRadius: 1,
                  ),
                ],
                borderRadius: BorderRadius.all(Radius.circular(20)),
                color: Colors.white,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/pdf.jpeg',
                    fit: BoxFit.cover,
                    height: 100,
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(top: 15, right: 8.0, left: 8.0),
                    child: Text(
                      'Service Regulation Act 2010',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class PDFViewerScreen extends StatelessWidget {
  final PDFDocument document;

  PDFViewerScreen({required this.document});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.indigo,
      ),
      body: PDFViewer(
        scrollDirection: axisDirectionToAxis(AxisDirection.up),
        zoomSteps: 1,
        document: document,
        showIndicator: true,
        showPicker: true,
      ),
    );
  }
}
