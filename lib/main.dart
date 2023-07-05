// import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:geocoding/geocoding.dart';
// import 'package:geolocator/geolocator.dart';
//
// void main() {
//   runApp(const MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   const MyApp({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: Home(),
//     );
//   }
// }
//
// class Home extends StatefulWidget {
//   const Home({super.key});
//
//   @override
//   State<Home> createState() => _HomeState();
// }
//
// class _HomeState extends State<Home> {
//   String currentAdd = "My Address";
//   Position currentPos = 0.0 as Position;
//
//   Future<Position> _determinePosition() async {
//     bool serviceEnabled;
//     LocationPermission permission;
//
//     serviceEnabled = await Geolocator.isLocationServiceEnabled();
//     if (!serviceEnabled) {
//       Fluttertoast.showToast(msg: 'Please enable Your Location Service');
//     }
//
//     permission = await Geolocator.checkPermission();
//     if (permission == LocationPermission.denied) {
//       permission = await Geolocator.requestPermission();
//       if (permission == LocationPermission.denied) {
//         Fluttertoast.showToast(msg: 'Location permissions are denied');
//       }
//     }
//
//     if (permission == LocationPermission.always) {
//       Fluttertoast.showToast(
//           msg:
//               'Location permissions are permanently denied, we cannot request permissions.');
//     }
//
//     Position position = await Geolocator.getCurrentPosition(
//         desiredAccuracy: LocationAccuracy.high);
//
//     try {
//       List<Placemark> placemarks =
//           await placemarkFromCoordinates(position.latitude, position.longitude);
//
//       Placemark place = placemarks[0];
//
//       setState(() {
//         currentPos = position;
//         currentAdd = "${place.locality}, ${place.postalCode}, ${place.country}";
//       });
//     } catch (e) {
//       print(e);
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("My Location"),
//       ),
//       body: Center(
//         child: Column(
//           children: [
//             currentPos != null
//                 ? Text('Longitude = ' + currentPos.longitude.toString())
//                 : Container(),
//             currentPos != null
//                 ? Text('Latitude = ' + currentPos.latitude.toString())
//                 : Container(),
//             Text(
//               currentAdd,
//               style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
//             ),
//             TextButton(
//               onPressed: () {
//                 _determinePosition();
//               },
//               child: Text('Get My Location'),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Home(),
    );
  }
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String currentAddress = 'My Address';
  Position? currentposition;
  @override
  void initState() {
    super.initState();
    _determinePosition();
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      Fluttertoast.showToast(msg: 'Please enable Your Location Service');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        Fluttertoast.showToast(msg: 'Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      Fluttertoast.showToast(
          msg:
              'Location permissions are permanently denied, we cannot request permissions.');
    }

    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    try {
      List<Placemark> placemarks =
          await placemarkFromCoordinates(position.latitude, position.longitude);

      Placemark place = placemarks[0];

      setState(() {
        currentposition = position;
        currentAddress =
            "${place.locality}, ${place.postalCode}, ${place.country}";
      });
    } catch (e) {
      print(e);
    }
    return position;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Location'),
      ),
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            Icons.location_on,
            size: 40,
            color: Colors.blue,
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            'Get user location',
            style: TextStyle(fontSize: 26.0, fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 20,
          ),
          Text(
            'Address = ' + currentAddress,
            style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.normal),
          ),
          currentposition != null
              ? Text(
                  'Latitude = ' + currentposition!.latitude.toString(),
                  style:
                      TextStyle(fontSize: 20.0, fontWeight: FontWeight.normal),
                )
              : Container(),
          currentposition != null
              ? Text(
                  'Longitude = ' + currentposition!.longitude.toString(),
                  style: TextStyle(fontSize: 20),
                )
              : Container(),
          SizedBox(
            height: 15,
          ),
          ElevatedButton(
              onPressed: () {
                _determinePosition();
              },
              child: Text('Locate me'))
        ],
      )),
    );
  }
}
