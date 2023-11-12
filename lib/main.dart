import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:math';

void main() {
  runApp(const MapSample());
}

class MapSample extends StatefulWidget {
  const MapSample({super.key});

  @override
  State<MapSample> createState() => MapSampleState();
}

class MapSampleState extends State<MapSample> {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  static const CameraPosition _kLake = CameraPosition(
      bearing: 192.8334901395799,
      target: LatLng(37.43296265331129, -122.08832357078792),
      tilt: 59.440717697143555,
      zoom: 19.151926040649414);

  @override
  Widget build(BuildContext context) {
<<<<<<< Updated upstream
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Scaffold(
        body: GoogleMap(
          mapType: MapType.hybrid,
          initialCameraPosition: _kGooglePlex,
          onMapCreated: (GoogleMapController controller) {
            _controller.complete(controller);
          },
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: _goToTheLake,
          label: const Text('To the lake!'),
          icon: const Icon(Icons.directions_boat),
        ),
      ));
  }

  Future<void> _goToTheLake() async {
    final GoogleMapController controller = await _controller.future;
    await controller.animateCamera(CameraUpdate.newCameraPosition(_kLake));
  }
}

/*
// Takes in two LatLng objects and an int elapsed time in milliseconds
function score(guess, answer, elapsed){ 
    double score;
    double dist = sqrt(pow(guess.lat() - answer.lat(), 2) + pow(guess.lng() - answer.lng(), 2));
    score = 100000000/(dist * elapsed)
    return score;
}
*/
=======
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Stack(
        children: <Widget>[
          Container(
            width: double.infinity,
            height: double.infinity,
            child: GoogleMap(
              // key:
              markers: {
                const Marker(
                  markerId: MarkerId('marker1'),
                  position: LatLng(42.389769, -72.523326),
                )
              },
              mapType: MapType.hybrid,
              initialCameraPosition: umasscampus,
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
              },
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: IconButtonExample(),
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        child: Container(height: 50.0),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _makeGuess,
        tooltip: 'Make your guess',
        label: const Text('Guess'),
        icon: const Icon(Icons.check_circle_outline),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}

class IconButtonExample extends StatefulWidget {
  const IconButtonExample({super.key});

  @override
  State<IconButtonExample> createState() => _IconButtonExampleState();
}

class _IconButtonExampleState extends State<IconButtonExample> {
  @override
  double _scale = 0.5;
  int _coeff = -1;
  Widget build(BuildContext context) {
    return Transform.scale(
      scale: _scale,
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.inversePrimary,
        ),
        child: IconButton(
          icon: Image.asset('images/Image 1.png'),
          tooltip: 'Expand image',
          onPressed: () {
          setState(() {
            _coeff = _coeff * -1;
            _scale = _scale + 0.54 * _coeff;
          });
        }),
      )
    );
  }
}
>>>>>>> Stashed changes
