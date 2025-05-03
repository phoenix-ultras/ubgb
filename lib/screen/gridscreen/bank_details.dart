import 'package:flutter/material.dart';

class BankDetails extends StatefulWidget {
  const BankDetails({super.key});

  @override
  State<BankDetails> createState() => _BankDetailsState();
}

class _BankDetailsState extends State<BankDetails> {
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
          'Bank Details',
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
            // crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                margin: EdgeInsets.only(top: 10, left: 17, right: 17),
                color: Colors.white,
                child: Center(
                  child: Column(
                    children: [
                      Text(
                        'उत्तर बिहार ग्रामीण बैंक की सरंचना',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                decoration: BoxDecoration(
                  boxShadow: const [
                    BoxShadow(
                        color: Colors.black, blurRadius: 6, spreadRadius: 1),
                  ],
                ),
                height: 450,
                width: 350,
                child: Image.asset(
                  'assets/images/b1.jpeg',
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                decoration: BoxDecoration(
                  boxShadow: const [
                    BoxShadow(
                        color: Colors.black, blurRadius: 6, spreadRadius: 1),
                  ],
                ),
                height: 450,
                width: 350,
                child: Image.asset(
                  'assets/images/b2.jpeg',
                  fit: BoxFit.cover,
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  boxShadow: const [
                    BoxShadow(
                        color: Colors.black, blurRadius: 6, spreadRadius: 1),
                  ],
                ),
                height: 450,
                width: 350,
                child: Image.asset(
                  'assets/images/b3.jpeg',
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                decoration: BoxDecoration(
                  boxShadow: const [
                    BoxShadow(
                        color: Colors.black, blurRadius: 6, spreadRadius: 1),
                  ],
                ),
                height: 450,
                width: 350,
                child: Image.asset(
                  'assets/images/b4.jpeg',
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(
                height: 10,
              )
            ],
          ),
        ),
      ),
    );
  }
}
