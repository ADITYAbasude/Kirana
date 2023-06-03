import 'package:Kirana/screens/splash/splash_screen.dart';
import 'package:Kirana/utils/screen_size.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geocoding/geocoding.dart';

import '../../constants/SystemColors.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../tools/Toast.dart';

class MyAddressScreen extends StatefulWidget {
  const MyAddressScreen({super.key});

  @override
  State<MyAddressScreen> createState() => _MyAddressScreenState();
}

class _MyAddressScreenState extends State<MyAddressScreen> {
  late GoogleMapController mapController;

  final _address = TextEditingController();
  final List<Marker> _listOfAddress = [];
  var _center;
  @override
  void initState() {
    _address.text = SplashScreen.address;
    _convertAddressIntoLatLng(_address.text);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (_center == null) {
      _center = LatLng(SplashScreen.currentLocation!.latitude,
          SplashScreen.currentLocation!.longitude);
    }
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mainColor,
        automaticallyImplyLeading: false,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back_ios_new_rounded,
              color: Colors.white,
            )),
        title: Text(
          "My Address",
          style: TextStyle(color: textColor),
        ),
        centerTitle: true,
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        child: SingleChildScrollView(
            physics: ClampingScrollPhysics(),
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  height: getScreenSize(context).height / 2.2,
                  child: GoogleMap(
                    onMapCreated: _onMapCreated,
                    mapType: MapType.normal,
                    markers: _listOfAddress.toSet(),
                    initialCameraPosition: CameraPosition(
                      target: _center,
                      zoom: 18,
                    ),
                    zoomControlsEnabled: false,
                    onTap: _onTap,
                  ),
                ),
                Container(
                  // transform: Matrix4.translationValues(0, -20, 100),
                  width: double.infinity,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: const EdgeInsets.all(10),
                        child: Text(
                          'Address',
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 10),
                        child: TextField(
                          textAlign: TextAlign.start,
                          textAlignVertical: TextAlignVertical.center,
                          maxLengthEnforcement: MaxLengthEnforcement.enforced,
                          controller: _address,
                          style: const TextStyle(height: 1),
                          cursorHeight: 20,
                          minLines: 1,
                          maxLines: 2,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 15, horizontal: 20),
                            hintText: "",
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                                borderSide: BorderSide(
                                    color: Theme.of(context).primaryColor,
                                    width: 2)),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        margin:
                            const EdgeInsets.only(top: 20, left: 10, right: 10),
                        width: double.infinity,
                        height: 45,
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: mainColor,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15))),
                            onPressed: () {
                              if (_address.text.isNotEmpty) {
                                SplashScreen.address = _address.text;
                                Navigator.pop(context);
                              } else {
                                showToast("Please enter your address");
                              }
                            },
                            child: Text(
                              'Change your address',
                              style: TextStyle(fontSize: 17),
                            )),
                      )
                    ],
                  ),
                )
              ],
            )),
      ),
    );
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  _onDrag(LatLng position) {
    print(position);
  }

  _onTap(LatLng position) async {
    _listOfAddress.clear();
    setState(() {
      _listOfAddress.add(Marker(
          markerId: MarkerId('1'),
          position: position,
          draggable: true,
          flat: true,
          onDrag: _onDrag));
    });
    await placemarkFromCoordinates(position.latitude, position.longitude)
        .then((value) {
      Placemark place = value[0];
      setState(() {
        _address.text =
            "${place.street}, ${place.subLocality}, ${place.locality}, ${place.postalCode}, ${place.country}";
      });
    });
  }

  void _convertAddressIntoLatLng(address) async {
    var addresses = await locationFromAddress(address);
    var first = addresses.first;
    setState(() {
      _listOfAddress.add(Marker(
          markerId: MarkerId('1'),
          position: LatLng(first.latitude, first.longitude),
          draggable: true,
          flat: true,
          onDrag: _onDrag));
      _center = LatLng(first.latitude, first.longitude);
    });
  }
}
