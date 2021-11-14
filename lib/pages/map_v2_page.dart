import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_with_flutter/model/map_type_google.dart';
import 'package:permission_handler/permission_handler.dart';

class MapV2Page extends StatefulWidget {
  const MapV2Page({Key? key}) : super(key: key);

  @override
  _MapV2PageState createState() => _MapV2PageState();
}

class _MapV2PageState extends State<MapV2Page> {
  late GoogleMapController _controller;
  double latitude = -6.195101;
  double longitude = 106.794905;
  var mapType = MapType.normal;

  late String address;

  Position? userLocation;

  void selectedMapStyle(MapTypeGoogle type) {
    setState(() {
      if (type.title == "Normal") {
        mapType = MapType.normal;
      } else if (type.title == "Hybrid") {
        mapType = MapType.hybrid;
      } else if (type.title == "Terrain") {
        mapType = MapType.terrain;
      } else if (type.title == "Satellite") {
        mapType = MapType.satellite;
      }
    });
  }

  void searchAddress() {
    GeocodingPlatform.instance.locationFromAddress(address).then((value) {
      _controller.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
              target: LatLng(value[0].latitude, value[0].longitude), zoom: 16),
        ),
      );
    });
  }

  Future<void> requestPermission() async {
    await Permission.location.request();
  }

  @override
  void initState() {
    super.initState();
    requestPermission();
  }

  Future<Position?> getLocation() async {
    Position? currentLocation;
    try {
      currentLocation = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.best);
    } catch (e) {
      currentLocation = null;
    }
    return currentLocation;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'Google Maps v2',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        actions: [
          PopupMenuButton(
            onSelected: selectedMapStyle,
            icon: const Icon(
              Icons.more_vert,
              color: Colors.black,
            ),
            itemBuilder: (context) {
              return googleMapsTypes
                  .map((googleMapType) => PopupMenuItem(
                      child: Text(googleMapType.title!), value: googleMapType))
                  .toList();
            },
          ),
        ],
      ),
      body: Stack(
        children: [_buildMap(), _buildSearchCard()],
      ),
    );
  }

  Widget _buildMap() {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: GoogleMap(
        mapType: mapType,
        initialCameraPosition: CameraPosition(
          target: LatLng(latitude, longitude),
          zoom: 17,
        ),
        myLocationEnabled: true,
        onMapCreated: (GoogleMapController controller) {
          _controller = controller;
        },
      ),
    );
  }

  Widget _buildSearchCard() {
    return Positioned(
      top: 30,
      left: 15,
      right: 15,
      child: SizedBox(
        height: 150,
        width: double.infinity,
        child: Material(
          // spesialnya material ada elevationnya
          elevation: 8,
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.only(left: 20, right: 20, top: 8),
                child: TextField(
                  decoration: InputDecoration(
                      hintText: 'Masukkan alamat..',
                      contentPadding: const EdgeInsets.only(top: 15, left: 15),
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.search),
                        onPressed: () {
                          searchAddress();
                        },
                      )),
                  onChanged: (value) {
                    setState(() {
                      address = value;
                    });
                  },
                ),
              ),

              // Create button
              ElevatedButton(
                onPressed: () {
                  getLocation().then((value) {
                    setState(() {
                      userLocation = value;
                    });
                    _controller.animateCamera(CameraUpdate.newCameraPosition(
                        CameraPosition(
                            target: LatLng(userLocation!.latitude,
                                userLocation!.longitude),
                            zoom: 17)));
                  });
                },
                child: const Text('Get My Location'),
              ),
              const SizedBox(
                height: 10,
              ),
              userLocation == null
                  ? const Text('Lokasi belum terdeteksi')
                  : Text(
                      'My Location is : ${userLocation!.latitude}, ${userLocation!.longitude}')
            ],
          ),
        ),
      ),
    );
  }
}
