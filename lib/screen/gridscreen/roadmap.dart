import 'package:flutter/material.dart';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart' as url_launcher;

class Roadmap extends StatefulWidget {
  const Roadmap({super.key});

  @override
  State<Roadmap> createState() => _RoadmapState();
}

class _RoadmapState extends State<Roadmap> {
  late double? latitude;
  late double? longitude;

  Future<void> getCurrentLocation() async {
    // Future.delayed(
    //     Duration(
    //       seconds: 3,
    //     ),
    //     () => SpinKitWaveSpinner(
    //           color: Colors.white,
    //         ));
    //checking permission
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      Fluttertoast.showToast(msg: "Allow permission to open maps");
      LocationPermission permission = await Geolocator.requestPermission();
    } else {
      Position currentPosition = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.best);

      latitude = currentPosition.latitude;
      longitude = currentPosition.longitude;
    }
    // Navigator.of(context).pop();
  }

  //direct to google maps
  void googleMaps(double lat, double long) async {
    //
    if (latitude == null || longitude == null) {
      Fluttertoast.showToast(msg: "Some error occured");
    }

    //url for map
    Uri url = Uri.parse(
        'https://www.google.com/maps/dir/?api=1&origin=$latitude,$longitude&destination=$lat,$long');

    if (await url_launcher.canLaunchUrl(url)) {
      await url_launcher.launchUrl(url);
    } else {
      Fluttertoast.showToast(
          msg: "Could not open map.please check your internet connectivity");
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    getCurrentLocation();

    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  Widget Mapcontainer(String address, String img, double lat, double long) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Colors.cyan.shade100,
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(.3),
                blurRadius: 15,
                spreadRadius: 5),
          ]),
      margin: EdgeInsets.symmetric(horizontal: 20),
      height: 300,
      width: MediaQuery.of(context).size.width - 40,
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
            height: 150,
            width: MediaQuery.of(context).size.width - 40,
            child: Image.asset(
              img,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            address,
            style: TextStyle(
                color: Colors.teal.shade900,
                fontSize: 20,
                fontWeight: FontWeight.bold),
          ),
          ElevatedButton.icon(
            onPressed: () {
              /*To do-- Again ask for permission of assessing location  */
              googleMaps(lat, long);
            },
            label: Text(
              'Open Map',
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
            ),
            icon: Icon(
              Icons.maps_home_work_rounded,
              color: Colors.black,
            ),
          )
        ],
      ),
    );
  }

  Widget textContainer(String text) {
    return Text(
      text,
      style: TextStyle(
          fontSize: 20, color: Colors.black, fontWeight: FontWeight.bold),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          'Roadmap',
          style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
              letterSpacing: 2),
        ),
      ),
      backgroundColor: Colors.indigo,
      body: SafeArea(
          bottom: true,
          child: SingleChildScrollView(
            padding: EdgeInsets.only(bottom: 10),
            child: Column(
              children: [
                //1
                textContainer('1.UBGB Araria'),
                SizedBox(
                  height: 10,
                ),
                Mapcontainer(
                    'Araria Jindal complex Near\nBus stand,Araria, PIN-854311',
                    'assets/images/map.jpeg',
                    26.1308,
                    87.4641),
                SizedBox(
                  height: 20,
                ),
                //2
                textContainer('2.UBGB Madhubani'),
                SizedBox(
                  height: 10,
                ),
                Mapcontainer('Madhubani Parishad Bazar\nMadhubani, PIN-847211',
                    'assets/images/map.jpeg', 26.3441055, 86.0724757),
                //3
                SizedBox(
                  height: 20,
                ),

                textContainer('3.UBGB Bettiah,West Champaran'),
                SizedBox(
                  height: 10,
                ),
                Mapcontainer(
                    'Bettiah Station Bazar chowk\nSupriya Cinema Road, PIN-845438',
                    'assets/images/map.jpeg',
                    26.803718,
                    84.519826),
                //4
                SizedBox(
                  height: 20,
                ),

                textContainer('4.UBGB Motihari,East Champaran'),
                SizedBox(
                  height: 10,
                ),
                Mapcontainer(
                    'Motihari Narayan Complex\nBalua Tal Motihari, PIN-845401',
                    'assets/images/map.jpeg',
                    26.6535978,
                    84.9059521),
                //5
                SizedBox(
                  height: 20,
                ),

                textContainer('5.UBGB Chapra'),
                SizedBox(
                  height: 10,
                ),
                Mapcontainer('Chapra Dahiyavan,Chapra\nPIN-841301',
                    'assets/images/map.jpeg', 25.7779064, 84.7431699),
                //6
                SizedBox(
                  height: 20,
                ),

                textContainer('6.UBGB Muzaffarpur'),
                SizedBox(
                  height: 10,
                ),
                Mapcontainer(
                    'Muzaffarpur(east),Ramrekha\ncomplex Power house Road\nPIN-842001',
                    'assets/images/map.jpeg',
                    26.1124022,
                    85.3616721),
                //7
                SizedBox(
                  height: 20,
                ),

                textContainer('7.UBGB Laheriasarai,Darbhanga'),
                SizedBox(
                  height: 10,
                ),
                Mapcontainer(
                    'Infront of Royal Enfield showroom\nEKMI road Saidnagar, PIN-846001',
                    'assets/images/map.jpeg',
                    26.1204682,
                    85.8991888),
                //8
                SizedBox(
                  height: 20,
                ),

                textContainer('8.UBGB Purnia'),
                SizedBox(
                  height: 10,
                ),
                Mapcontainer('Purnia, Sri Nagar Hata\nKosi Colony, PIN-854301',
                    'assets/images/map.jpeg', 25.7881327, 87.4721918),
                //9
                SizedBox(
                  height: 20,
                ),

                textContainer('9.UBGB Gopalganj'),
                SizedBox(
                  height: 10,
                ),
                Mapcontainer(
                    'Gopalganj, Banjari Road, Vaibhav\nHotel Complex, PIN-841428',
                    'assets/images/map.jpeg',
                    26.469969,
                    84.4164532),
                //10
                SizedBox(
                  height: 20,
                ),

                textContainer('10.UBGB Saharsa'),
                SizedBox(
                  height: 10,
                ),
                Mapcontainer('At-Deo Market,Purab Bazar\nSaharsa, PIN-852201',
                    'assets/images/map.jpeg', 25.8769866, 86.5242863),
                //11
                SizedBox(
                  height: 20,
                ),

                textContainer('11.UBGB Hajipur'),
                SizedBox(
                  height: 10,
                ),
                Mapcontainer(
                    'Ramashish chowk,Opposite\nTelephone Exchange Hajipur\nPIN-844101',
                    'assets/images/map.jpeg',
                    25.7027764,
                    85.2207809),
                //12
                SizedBox(
                  height: 20,
                ),

                textContainer('12.UBGB Sitamarhi'),
                SizedBox(
                  height: 10,
                ),
                Mapcontainer(
                    'Near Kargil Chowk, Bypass Road\nSitamarhi, PIN-843301',
                    'assets/images/map.jpeg',
                    26.5889157,
                    85.49622),
                //13
                SizedBox(
                  height: 20,
                ),

                textContainer('13.UBGB Madhubani'),
                SizedBox(
                  height: 10,
                ),
                Mapcontainer(
                    'Kranti Bhawan, Langra Chowk\nJhanjharpur, Madhubani\nPIN-847404',
                    'assets/images/map.jpeg',
                    26.2574943,
                    86.2649777),
                //14
                SizedBox(
                  height: 20,
                ),

                textContainer('14.UBGB Siwan'),
                SizedBox(
                  height: 10,
                ),
                Mapcontainer(
                    'Pandey Complex,Ayodhyapuri\nMohaddipur Road Shreenagar\nSiwan,PIN-841226',
                    'assets/images/map.jpeg',
                    26.2301035,
                    84.3163813),
              ],
            ),
          )),
    );
  }
}
