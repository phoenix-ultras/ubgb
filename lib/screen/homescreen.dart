import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:ubgb/screen/gridscreen/Circular.dart';
import 'package:ubgb/screen/gridscreen/act.dart';
import 'package:ubgb/screen/gridscreen/administration.dart';
import 'package:ubgb/screen/gridscreen/bank_details.dart';
//screen
import 'package:ubgb/screen/gridscreen/employee_details.dart';
import 'package:ubgb/screen/gridscreen/roadmap.dart';
import 'package:ubgb/screen/loginscreen.dart';
import 'package:ubgb/screen/navigatorbarscreen/about.dart';
import 'package:ubgb/screen/navigatorbarscreen/gallery.dart';
import 'package:ubgb/screen/navigatorbarscreen/help.dart';
import 'package:ubgb/screen/navigatorbarscreen/inbox.dart';
import 'package:ubgb/services/permissionProvider.dart';

class Homescreen extends ConsumerStatefulWidget {
  const Homescreen({super.key});

  @override
  ConsumerState<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends ConsumerState<Homescreen> {
  //Icons to be displayed in Gridview
  final List<IconData> _icons = [
    Icons.people,
    Icons.account_balance,
    Icons.admin_panel_settings_outlined,
    Icons.map_sharp,
    Icons.blur_circular,
    Icons.history_edu_sharp,
  ];
  //Text to be displayed in gridview
  final List<String> _text = [
    'EMPLOYEE DETAILS',
    'BANK DETAILS',
    'ADMINISTRATION',
    'ROADMAP',
    'CIRCULAR',
    'ACT',
  ];

  var _barIndex = 0;
  @override
  Widget build(BuildContext context) {
    //using provider to check if user is admin or not
    final _isAdmin = ref.watch(isAdminProvider);

    //screen height and width
    var swidth = MediaQuery.of(context).size.width;
    var sheight = MediaQuery.of(context).size.height;
    return Scaffold(
      //Bottom navigation bar

      backgroundColor: Colors.blueGrey.shade600,
      body: SafeArea(
          child: SingleChildScrollView(
        child: Container(
          color: Colors.white,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 50, left: 20),
                    height: sheight * 0.25,
                    child: const Text(
                      'UBGB  EWC\nWe serve with Faith',
                      style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          color: Colors.teal),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(right: 20, bottom: 70),
                    height: 80,
                    child: InkWell(
                      onTap: () async {
                        //logout

                        await FirebaseAuth.instance.signOut();
                        Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                                builder: (context) => LoginScreen()),
                            (Route<dynamic> route) => false);
                        Fluttertoast.showToast(msg: "Sign Out successfully");
                      },
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(50),
                        child: Image.asset('assets/images/bhim.jpeg'),
                      ),
                    ),
                  )
                ],
              ),
              Container(
                height: sheight * 0.65,
                width: swidth,
                decoration: const BoxDecoration(
                  color: Colors.indigo,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(50),
                    topRight: Radius.circular(50),
                  ),
                ),
                child: GridView.builder(
                    padding: EdgeInsets.all(10),
                    shrinkWrap: true,
                    itemCount: 6,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 1.1,
                    ),
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          switch (index) {
                            case 0:
                              if (_isAdmin.asData?.value == true) {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => EmployeeDetails()));
                                break;
                              } else {
                                Fluttertoast.showToast(
                                    msg: "You are not authorised",
                                    backgroundColor: Colors.red);
                                break;
                              }

                            case 1:
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => BankDetails()));
                              break;
                            case 2:
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => Administration()));
                              break;
                            case 3:
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => Roadmap()));
                              break;
                            case 4:
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => Circular()));
                              break;
                            case 5:
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => Act()));
                              break;
                            default:
                          }
                        },
                        child: Container(
                          margin: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 20),
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
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              //icon
                              Icon(
                                _icons[index],
                                size: 50,
                                color: Colors.white,
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Text(
                                _text[index],
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
              ),
            ],
          ),
        ),
      )),
      bottomNavigationBar: Container(
        color: Colors.black,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
          child: GNav(
            iconSize: 20,
            tabBackgroundColor: Colors.white,
            backgroundColor: Colors.black,
            onTabChange: (value) {
              setState(() {
                _barIndex = value;
              });
            },
            selectedIndex: _barIndex,
            padding: const EdgeInsets.all(16),
            tabs: [
              GButton(
                gap: 5,
                iconSize: 25,
                iconColor: Colors.white,
                icon: Icons.photo_album_outlined,
                text: 'Gallery',
                onPressed: () {
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (context) => Gallery()));
                },
              ),
              GButton(
                iconSize: 25,
                iconColor: Colors.white,
                icon: Icons.info_outline_rounded,
                text: 'About US',
                onPressed: () {
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => const About()));
                },
              ),
              _isAdmin.asData?.value == false
                  ? GButton(
                      iconSize: 25,
                      iconColor: Colors.white,
                      icon: Icons.help_outlined,
                      text: 'Help Desk',
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => HelpDesk()));
                      },
                    )
                  : GButton(
                      iconSize: 25,
                      iconColor: Colors.white,
                      icon: Icons.message,
                      text: 'Inbox',
                      onPressed: () {
                        Navigator.of(context).push(
                            MaterialPageRoute(builder: (context) => Inbox()));
                      },
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
