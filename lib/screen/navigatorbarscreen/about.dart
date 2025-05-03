import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class About extends StatefulWidget {
  const About({super.key});

  @override
  State<About> createState() => _AboutState();
}

class _AboutState extends State<About> {
  //list of images
  List<String> images = ['assets/images/phule.jpg', 'assets/images/jyoti.jpg'];
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
          'About Us',
          style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
              letterSpacing: 2),
        ),
      ),
      backgroundColor: Colors.indigo,
      body: SafeArea(
          child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              //carousel slider
              child: CarouselSlider(
                  items: images.map((img) {
                    return Builder(
                      builder: (context) {
                        return Container(
                          child: Image.asset(
                            img,
                            fit: BoxFit.cover,
                          ),
                        );
                      },
                    );
                  }).toList(),
                  options: CarouselOptions(
                    height: 200,
                    autoPlay: true,
                  )),
            ),

            //
            Container(
              margin: const EdgeInsets.only(
                top: 30,
                left: 10,
                right: 10,
              ),
              decoration: BoxDecoration(
                  boxShadow: const [BoxShadow(color: Colors.black)],
                  borderRadius: BorderRadius.circular(30),
                  color: Colors.cyan.shade50),
              child: Column(
                children: [
                  //vision
                  Container(
                    alignment: Alignment.center,
                    child: const Text(
                      'VISION',
                      style: TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                          color: Colors.green),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 15, left: 10, right: 10),
                    alignment: Alignment.topLeft,
                    child: const Text(
                      'Gram Chetna - Going Beyond Banking',
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                    ),
                  ),
                  const SizedBox(
                    height: 22,
                  ),
                  // mission
                  Container(
                    alignment: Alignment.center,
                    child: const Text(
                      'MISSION',
                      style: TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                          color: Colors.green),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 15, left: 10, right: 10),
                    alignment: Alignment.topLeft,
                    child: const Wrap(
                      children: [
                        Text(
                          'Holistic development and wealth creation in villages where each banking outlet of Uttar Bihar Gramin Bank would act as the focal point for extension, counselling, liaisoning, providing forward and backward linkages, and channelling financial muscle required for rural development, while ensuring profitability of each business unit.',
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 22,
                  ),

                  //core value
                  Container(
                    alignment: Alignment.center,
                    child: const Text(
                      'CORE VALUE',
                      style: TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                          color: Colors.green),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(
                        top: 15, left: 10, right: 10, bottom: 30),
                    alignment: Alignment.topLeft,
                    child: const Text(
                      'Trust & Transparency\nEmpowerment & Development\nService Excellence',
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      )),
    );
  }
}
