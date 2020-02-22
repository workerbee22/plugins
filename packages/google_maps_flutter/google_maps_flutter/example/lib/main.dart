/// Google Maps
//
// Using Google Maps Flutter package v0.4.0 Dev Preview
// Based on the Place tracker code from Medium article
// and as I implemented in google_maps_flutter_2 project

import 'dart:async'; // Completer needs the async dart package
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart'; // Google Maps plugin

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {

  // Set for all the markers
  static Set<Marker> markers = {};
  static Set<GroundOverlay> groundMap = {};

  static BitmapDescriptor groundImage;
  static BitmapDescriptor myMarker;
  static ImageConfiguration imageConfiguration;

  void getMarkers() async {

    /// Special BitmapDescriptor class methods
    myMarker = await BitmapDescriptor.fromAssetImage(
      ImageConfiguration(devicePixelRatio: 2.5),
      'assets/red_square.png',
    );

    /// Markers
    // Some custom markers to play with
    // TODO On iOS the markers are very big. Need to use workaround until fixed. Implement work around.
    // See https://github.com/flutter/flutter/issues/24865

    Marker _markerA = Marker(
      markerId: MarkerId('1'),
      position: LatLng(37.426121, -122.07714),
      onTap: () {

      },
      infoWindow: InfoWindow(
        title: 'Marker 1 Info Window',
        onTap: () { /* */ },
      ),
      //icon: BitmapDescriptor.fromAsset('assets/images/markers/map_marker_1.png'),
      icon: myMarker,
    );

    Marker _markerB = Marker(
      markerId: MarkerId('a'),
      position: LatLng(37.423988, -122.080016),
      infoWindow: InfoWindow(
        title: 'Marker A Info Window',
        onTap: () { /*  */ },
      ),
      //icon: BitmapDescriptor.fromAsset('assets/images/markers/map_marker_a.png'),
      icon: BitmapDescriptor.defaultMarker,
    );

    Marker _markerC = Marker(
      markerId: MarkerId('mothers_room'),
      position: LatLng(37.427549, -122.080365),
      infoWindow: InfoWindow(
        title: 'Marker Mothers Room Info Window',
        onTap: () { /*  */ },
      ),
      //icon: BitmapDescriptor.fromAsset('assets/images/markers/map_marker_mothers_room.png'),
      icon: BitmapDescriptor.defaultMarker,
    );

    markers.add(_markerA);
    markers.add(_markerB);
    markers.add(_markerC);

  }

  /// USes a future so need to make static variables and init in initState()
  void getGroundOverlay() async {

    /// Special BitmapDescriptor class methods
    groundImage = await BitmapDescriptor.fromAssetImage(
      ImageConfiguration(devicePixelRatio: 2.5),
      'assets/map_tile_2048x2048.png', // 'assets/red_square.png',
    );

    print("***** Flutter client app - groundImage retreived from assets: " + groundImage.toString());

    /// Note Android requirement is that southwest Latlong should be first + northwest should be 2nd parameter.
    LatLng groundMapSW = LatLng(37.423401, -122.081053);
    LatLng groundMapNE = LatLng(37.427622, -122.077824);
    LatLngBounds groundBounds = LatLngBounds(southwest: groundMapSW, northeast: groundMapNE);

    // TODO - Currently can specify BOTH position and positionFromBounds, but need to stop this happening; one not both
    var groundOverlay = GroundOverlay(
      groundOverlayId: GroundOverlayId("7890"),
      image: groundImage,               // type BitmapDescriptor
      //positionFromBounds: groundBounds, // type LatLngBounds
      position: Position(location: LatLng(37.4258, -122.0799), width: 570.0),
    );

    groundMap.add(groundOverlay);

  }

  @override
  Widget build(BuildContext context) {

    // cannot await these here, but button press in middle so I can delay via user input
    getMarkers();
    getGroundOverlay();

    return MaterialApp(
      title: 'Flutter Google Maps Demo',
      home: MapSample(markers: markers, groundMap: groundMap),
    );
  }
}

/// Map Sample
// Based on the Sample app code structure and the Place Tracker projects

class MapSample extends StatefulWidget {

  final Set<Marker> markers;
  final Set<GroundOverlay> groundMap;

  MapSample({Key key, @required this.markers, @required this.groundMap}) : super(key: key);

  @override
  _MapSampleState createState() => _MapSampleState();
}

class _MapSampleState extends State<MapSample> {
  // NEW Google Maps Completer for the map controller, which is like a Future for async
  // operations
  Completer<GoogleMapController> _controller = Completer();

  // Variable for the current type of map
  MapType currentMapType;

  static BitmapDescriptor groundImage;
  static BitmapDescriptor myMarker;
  static ImageConfiguration imageConfiguration;

  static const LatLng _center = LatLng(37.4256, -122.0790);

  LatLng _lastMapPosition = _center;

  /// Static CameraPositions
  // Could be static const as well
  static final CameraPosition _shoreline = CameraPosition(
    target: _center,
    zoom: 16.5,
  );

  @override
  void initState() {
    super.initState();
    // Variable for the current type of map
    currentMapType = MapType.satellite;
  }

  /// Change Location
  // Changes and animates to a NEW Camera Position

  Future<void> newCameraPosition(LatLng coordinates) async {

    // Controller reference from the Completer _controller await as a future
    final GoogleMapController controller = await _controller.future;

    // Controller animates to newCameraPosition via CameraUpdate
    await controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(target: coordinates, zoom: 12)));

  }

  /// On Map Created, takes a GoogleMapController as a param
  // This is called when the GoogleMap is ready

  void _onMapCreated(GoogleMapController controller) {
    // When the Completer completes and we have get a controller
    _controller.complete(controller);
  }

  /// Map icon FAB - changes the map types and cycles through them
  //All the types cycle through and set in state using setState()

  void _onMapTypeButtonPressed() {

    print('*** Current Map Type was: ' + currentMapType.toString());

    setState(() {
      // Run through all MapType values going from one to the next on every press
      switch (currentMapType) {
        case MapType.normal:
          currentMapType = MapType.hybrid;
          print('*** Current Map Type is now: ' + currentMapType.toString());
          break;
        case MapType.hybrid:
          currentMapType = MapType.satellite;
          print('*** Current Map Type is now: ' + currentMapType.toString());
          break;
        case MapType.satellite:
          currentMapType = MapType.terrain;
          print('*** Current Map Type is now: ' + currentMapType.toString());
          break;
        case MapType.terrain:
          currentMapType = MapType.normal;
          print('*** Current Map Type is now: ' + currentMapType.toString());
          break;
        default:
          print('*** Current Map Type UNKNOWN: ' + currentMapType.toString());
      }
    });

  }

  /// Camera Position
  // Sets the _lastMapPosition to the center of the map LatLng once it stops moving
  // That is records the LatLng of where the center of the map currently is
  // better name might be _currentMapPosition

  void _onCameraMove(CameraPosition position) {
    _lastMapPosition = position.target;
  }

  /// Marker icon FAB - Adds a marker to the map at the camera position coordinates
  // with an infoWindow for that marker

  void _onAddMarkerButtonPressed() {
    // Add marker for the current LatLng center of the map which is the camera position
    setState(() {
      widget.markers.add(Marker(
        // This marker id can be anything that uniquely identifies each marker.
        markerId: MarkerId(_lastMapPosition.toString()),
        position: _lastMapPosition,
        infoWindow: InfoWindow(
          title: 'Really cool place',
          snippet: '5 Star Rating',
        ),
        icon: BitmapDescriptor.defaultMarker,
      ));
    });
  }



  Set<Circle> circles() {

    var myCircle = Circle(
      circleId: CircleId("1234"),
      radius: 50.0,
      strokeColor: Colors.white,
      center: LatLng(37.426121, -122.07714),
    );

    return {myCircle};    // needs to be a Set for now
  }


  @override
  Widget build(BuildContext context) {

    print("----------------Building Map ...");
    print("***** Flutter client app - groundMap Set has: " + widget.groundMap.toString());

    return Scaffold(
      appBar: AppBar(
        title: Text('Map'),
        backgroundColor: Colors.red[700],
      ),
      body: Stack(
        children: <Widget>[
          GoogleMap(
            // Controller of type GoogleMapController
            onMapCreated: _onMapCreated,
            // Type of map to display
            mapType: currentMapType,
            // Initial camera position for the map
            initialCameraPosition: _shoreline,
            // Set holding all of the markers for the map
            markers: widget.markers,
            onCameraMove: _onCameraMove,
            groundOverlays: widget.groundMap,
            //circles: circles(),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Align(
              alignment: Alignment.topRight,
              child: Column(
                children: <Widget>[
                  // FAB to change and cycle through the various map types
                  FloatingActionButton(
                    // state change on each button press to cycle through map types
                    onPressed: () => _onMapTypeButtonPressed(),
                    materialTapTargetSize: MaterialTapTargetSize.padded,
                    backgroundColor: Colors.green,
                    child: const Icon(Icons.map, size: 26.0),
                  ),
                  SizedBox(height: 16.0),
                  // FAB to add a new marker to the map at the current Camera Position (center of the map)
                  FloatingActionButton(
                    onPressed: _onAddMarkerButtonPressed,
                    materialTapTargetSize: MaterialTapTargetSize.padded,
                    backgroundColor: Colors.green,
                    child: const Icon(Icons.add_location, size: 26.0),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );

  }
}

/// Example project - for the google_maps_flutter plugin.
//// Copyright 2018 The Chromium Authors. All rights reserved.
//// Use of this source code is governed by a BSD-style license that can be
//// found in the LICENSE file.
//
//// ignore_for_file: public_member_api_docs
//
//import 'package:flutter/material.dart';
//import 'animate_camera.dart';
//import 'map_click.dart';
//import 'map_coordinates.dart';
//import 'map_ui.dart';
//import 'marker_icons.dart';
//import 'move_camera.dart';
//import 'padding.dart';
//import 'page.dart';
//import 'place_circle.dart';
//import 'place_marker.dart';
//import 'place_polygon.dart';
//import 'place_polyline.dart';
//import 'scrolling_map.dart';
//
//final List<Page> _allPages = <Page>[
//  MapUiPage(),
//  MapCoordinatesPage(),
//  MapClickPage(),
//  AnimateCameraPage(),
//  MoveCameraPage(),
//  PlaceMarkerPage(),
//  MarkerIconsPage(),
//  ScrollingMapPage(),
//  PlacePolylinePage(),
//  PlacePolygonPage(),
//  PlaceCirclePage(),
//  PaddingPage(),
//];
//
//class MapsDemo extends StatelessWidget {
//  void _pushPage(BuildContext context, Page page) {
//    Navigator.of(context).push(MaterialPageRoute<void>(
//        builder: (_) => Scaffold(
//              appBar: AppBar(title: Text(page.title)),
//              body: page,
//            )));
//  }
//
//  @override
//  Widget build(BuildContext context) {
//    return Scaffold(
//      appBar: AppBar(title: const Text('GoogleMaps examples')),
//      body: ListView.builder(
//        itemCount: _allPages.length,
//        itemBuilder: (_, int index) => ListTile(
//          leading: _allPages[index].leading,
//          title: Text(_allPages[index].title),
//          onTap: () => _pushPage(context, _allPages[index]),
//        ),
//      ),
//    );
//  }
//}
//
//void main() {
//  runApp(MaterialApp(home: MapsDemo()));
//}
