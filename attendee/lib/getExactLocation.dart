import 'package:flutter/material.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';

class GetExactLocation extends StatefulWidget {
  @override
  _GetExactLocationState createState() => _GetExactLocationState();
}

class _GetExactLocationState extends State<GetExactLocation> {
  var locationMessage = '';
  String address1 = "";
  String address2 = "";

  void getCurrentLocation() async {
    var position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best);
    var lastPosition = await Geolocator.getLastKnownPosition();
    final coordinates = new Coordinates(17.3982814, 78.4214637);
    var adresses =
        await Geocoder.local.findAddressesFromCoordinates(coordinates);

    print(lastPosition);

    setState(() {
      locationMessage =
          "Lattitude : ${position.latitude} Longitude : ${position.longitude}";
      address1 = adresses.first.featureName;
      address2 = adresses.first.addressLine;
    });
    print("Address1 :$address1 \nAddress2 : $address2");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: 10.0,
          ),
          Text("Get location"),
          SizedBox(height: 10.0),
          Text(locationMessage),
          MaterialButton(
              onPressed: () {
                getCurrentLocation();
              },
              child: Text("Gel Location"))
        ],
      ),
    ));
  }
}
