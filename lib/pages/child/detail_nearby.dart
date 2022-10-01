import 'package:dollan/models/viewmodels/detail_model.dart';
import 'package:dollan/utilities/helper.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:location/location.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:scoped_model/scoped_model.dart';

class DetailNearby extends StatefulWidget {
  DetailNearby();

  @override
  _DetailNearbyState createState() => _DetailNearbyState();
}

class _DetailNearbyState extends State<DetailNearby> {
  LocationData currentLocation;
  var location = Location();
  double latitude, longitude;
  ImageConfiguration configuration = ImageConfiguration(devicePixelRatio: 1);
  int markerNumber = 0;
  bool locationRetrieved = false;

  // Google Map
  Completer<GoogleMapController> _controller = Completer();
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};

  _addMarker({double lat, double lng}) async {
    markerNumber += 1;
    MarkerId markerId = MarkerId('$markerNumber');
    Marker marker = Marker(
        markerId: markerId,
        position: LatLng(lat, lng),
        icon: await BitmapDescriptor.fromAssetImage(
            configuration, 'assets/marker_style_48.png'),
        onTap: () {
          _showInfo(id: '$markerNumber');
        });

    setState(() {
      markers[markerId] = marker;
    });
  }

  initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => init());
  }

  init() {
    if (ScopedModel.of<DetailModel>(context).getLocation) {
      setState(() {
        locationRetrieved = true;
        latitude = ScopedModel.of<DetailModel>(context).lat;
        longitude = ScopedModel.of<DetailModel>(context).lng;
      });
    }
  }

  _showInfo({String id}) async {
    await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Image.asset('assets/images/$id.jpg'),
                SizedBox(
                  height: 10,
                ),
                Align(
                    alignment: Alignment.centerLeft,
                    child: Text('Nama Lokasi',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold))),
                SizedBox(
                  height: 10,
                ),
                Text(
                    'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Vestibulum egestas mattis magna vitae imperdiet.')
              ],
            ),
          );
        });
  }

  Future<void> _updateLocation() async {
    if (ScopedModel.of<DetailModel>(context).getLocation) {
      setState(() {
        latitude = ScopedModel.of<DetailModel>(context).lat;
      longitude = ScopedModel.of<DetailModel>(context).lng;
      _gotoMyPlace(lat: latitude, lng: longitude);  
      });      
      return;
    }

    Helper().showProgressDialog(context, 'Mengambil lokasi Anda...');

    markers = <MarkerId, Marker>{};
    currentLocation = await location.getLocation().then((res){
      print('---------------------------');
      print('location: $res');
      print('---------------------------');

      setState(() {
      latitude = res.latitude;
      longitude = res.longitude;
      _addMarker(lat: latitude, lng: longitude);
    });

    }).catchError((err){
      print('---------------------------');
      print('location ERROR : $err');
      print('---------------------------');
      return;
    });

    ScopedModel.of<DetailModel>(context)
        .updateLocationStatus(lat: latitude, lng: longitude);

  
    Navigator.of(context).pop();

    

    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(target: LatLng(latitude, longitude), zoom: 15.0)));

    _simulateMarkers();
  }

  _simulateMarkers() {
    // _addMarker(lat: -8.688280, lng: 115.217514);
    _addMarker(lat: latitude + 0.002026, lng: longitude + 0.000547);
    _addMarker(lat: latitude + 0.001676, lng: longitude + 0.002146);
    _addMarker(lat: latitude - 0.002576, lng: longitude - 0.002547);

    // -8.686604, 115.215368
  }

  _gotoMyPlace({double lat, double lng}) async {
    setState(() {
      latitude = lat;
      longitude = lng;
    });
    _addMarker(lat: lat, lng: lng);
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(target: LatLng(lat, lng), zoom: 15.0)));
    _simulateMarkers();
  }

  @override
  Widget build(BuildContext context) {
    return 
    Stack(
      children: <Widget>[
        Container(
          color: Colors.blue,
          height: 300,
          child: Column(
            children: <Widget>[
              Expanded(
                flex: 1,
                child: 
                GoogleMap(
                  initialCameraPosition:
                      CameraPosition(target: LatLng(0.0, 0.0), zoom: 15.0),
                  onMapCreated: (GoogleMapController controller) {
                    _controller.complete(controller);

                    // _gotoMyPlace(lat: -8.690306, lng: 115.216967);

                    // widget.locationRetrieved ? _gotoMyPlace(lat: widget.lat, lng: widget.lng) : _updateLocation();

                    _updateLocation();
                  },
                  markers: Set<Marker>.of(markers.values),
                ),
              ),
              // Expanded(
              //   flex: 1,
              //   child: Center(
              //     child: RaisedButton(
              //       onPressed: _updateLocation,
              //       child: Text('Get My Location'),
              //     ),
              //   ),
              // )
            ],
          ),
        ),
        Positioned(
          bottom: 10,
          right: 10,
          child: GestureDetector(
            onTap: _updateLocation,
            child: Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Theme.of(context).primaryColor),
              child: Icon(Icons.location_searching),
            ),
          ),
        ),
        // Positioned(
        //   bottom: 10,
        //   left: 10,
        //   child: GestureDetector(
        //     onTap: () {
        //       _addMarker(lat: latitude + 0.002026, lng: longitude + 0.000547);
        //       _addMarker(lat: latitude + 0.00205, lng: longitude + 0.000560);
        //     },
        //     child: Container(
        //       padding: EdgeInsets.all(8),
        //       decoration: BoxDecoration(
        //           shape: BoxShape.circle,
        //           color: Theme.of(context).primaryColor),
        //       child: Icon(Icons.add_location),
        //     ),
        //   ),
        // )
      ],
    );
  }
}
