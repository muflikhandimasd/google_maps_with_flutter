import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_with_flutter/model/map_type_google.dart';

class MapV1Page extends StatefulWidget {
  const MapV1Page({Key? key}) : super(key: key);

  @override
  _MapV1PageState createState() => _MapV1PageState();
}

class _MapV1PageState extends State<MapV1Page> {
  final Completer<GoogleMapController> _controller = Completer();

  double latitude = -6.195101;
  double longitude = 106.794905;
  double zoom = 15;
  MapType mapType = MapType.normal;

  void _placeCardClicked(double lat, double lng) async {
    setState(() {
      latitude = lat;
      longitude = lng;
    });

    GoogleMapController controller = await _controller.future;
    controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
            target: LatLng(latitude, longitude),
            zoom: 17,
            tilt: 55,
            bearing: 192),
      ),
    );
  }

  void _zoomAction(double zoom, double lat, double lng) async {
    GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(target: LatLng(lat, lng), zoom: zoom)));
  }

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
          'Google Maps v1',
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
        children: [
          _buildMap(),
          _buildDetailCard(),
          _buildZoomIn(),
          _buildZoomOut()
        ],
      ),
    );
  }

  static Marker imaStudio = Marker(
      markerId: const MarkerId("imaStudio"),
      position: const LatLng(-6.195303, 106.7926562),
      infoWindow: const InfoWindow(title: "Training Mobile App"),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed));

  static Marker monas = Marker(
      markerId: const MarkerId("monas"),
      position: const LatLng(-6.1753871, 106.8249587),
      infoWindow: const InfoWindow(title: "Monumen Nasional"),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed));

  static Marker istana = Marker(
      markerId: const MarkerId("Istana Merdeka"),
      position: const LatLng(-6.1701812, 106.8219803),
      infoWindow: const InfoWindow(title: "Istana Merdeka"),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed));

  static Marker masjid = Marker(
      markerId: const MarkerId("Masjid Istiqlal"),
      position: const LatLng(-6.1699883, 106.8287337),
      infoWindow: const InfoWindow(title: "Masjid Istiqlal"),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed));

  Widget _buildMap() {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: GoogleMap(
        mapType: mapType,
        zoomControlsEnabled: false,
        initialCameraPosition: CameraPosition(
          target: LatLng(latitude, longitude),
          zoom: 17,
        ),
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
        markers: {imaStudio, masjid, istana, monas},
      ),
    );
  }

// karena cm dipake di class ini doang
  Widget _buildZoomOut() {
    return Padding(
      padding: const EdgeInsets.only(top: 50),
      child: Align(
        alignment: Alignment.topRight,
        child: IconButton(
            onPressed: () {
              zoom--;
              _zoomAction(zoom, latitude, longitude);
            },
            icon: const Icon(Icons.zoom_out)),
      ),
    );
  }

  Widget _buildZoomIn() {
    return Align(
      alignment: Alignment.topRight,
      child: IconButton(
        onPressed: () {
          zoom++;
          _zoomAction(zoom, latitude, longitude);
        },
        icon: const Icon(Icons.zoom_in),
      ),
    );
  }

  Widget _buildDetailCard() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: SizedBox(
        height: 150,
        child: ListView(
          scrollDirection: Axis.horizontal,
          children: [
            const SizedBox(
              width: 10,
            ),
            _displayPlaceCard(
                "https://idn.sch.id/wp-content/uploads/2016/10/ima-studio.png",
                "ImaStudio",
                -6.1952988,
                106.7926625),
            const SizedBox(
              width: 10,
            ),
            _displayPlaceCard(
                "https://2.bp.blogspot.com/-0WirdbkDv4U/WxUkajG0pAI/AAAAAAAADNA/FysRjLMqCrw_XkcU0IQwuqgKwXaPpRLRgCLcBGAs/s1600/1528109954774.jpg",
                "Monas",
                -6.1753871,
                106.8249587),
            const SizedBox(
              width: 10,
            ),
            _displayPlaceCard(
                "https://cdn1-production-images-kly.akamaized.net/n8uNqIv9lZ3PJVYw-8rfy8DZotE=/640x360/smart/filters:quality(75):strip_icc():format(jpeg)/kly-media-production/medias/925193/original/054708200_1436525200-6-Masjid-Megah-Istiqlal.jpg",
                "Masjid Istiqlal",
                -6.1702229,
                106.8293614),
            const SizedBox(
              width: 10,
            ),
            _displayPlaceCard(
                "https://img-z.okeinfo.net/library/images/2018/08/14/gtesxf7d7xil1zry76xn_14364.jpg",
                "Istana Merdeka",
                -6.1701238,
                106.8219881),
          ],
        ),
      ),
    );
  }

  Widget _displayPlaceCard(String image, String name, double lat, double lng) {
    return GestureDetector(
      onTap: () {
        _placeCardClicked(lat, lng);
      },
      child: Container(
        width: MediaQuery.of(context).size.width - 30,
        margin: const EdgeInsets.only(bottom: 20),
        child: Material(
          color: Colors.white,
          borderRadius: BorderRadius.circular(25),
          elevation: 10,
          child: Row(
            children: [
              Container(
                width: 90,
                height: 90,
                margin: const EdgeInsets.all(15.0),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    image: DecorationImage(
                        image: NetworkImage(image), fit: BoxFit.cover)),
              ),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      name,
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Row(
                      children: const [
                        Text(
                          "4.9",
                          style: TextStyle(fontSize: 15),
                        ),
                        Icon(
                          Icons.star,
                          color: Colors.orange,
                          size: 15,
                        ),
                        Icon(
                          Icons.star,
                          color: Colors.orange,
                          size: 15,
                        ),
                        Icon(
                          Icons.star,
                          color: Colors.orange,
                          size: 15,
                        ),
                        Icon(
                          Icons.star,
                          color: Colors.orange,
                          size: 15,
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    const Text(
                      "Indonesia \u00B7 Jakarta Barat",
                      style: TextStyle(color: Colors.black, fontSize: 15),
                    ),
                    const Text(
                      "Closed \u00B7 Open 09.00 Monday",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 15,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
