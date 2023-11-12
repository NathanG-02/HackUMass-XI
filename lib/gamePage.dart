import 'package:flutter/material.dart';
import 'dart:async';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:math';

class GamePage extends StatefulWidget {
  const GamePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  bool _roundOver = false;
  bool _gameOver = false;
  int _score = 0;

  // late means not initialized until first use
  late Timer _gameTimer;
  late Timer _roundTimer;
  int _gameSeconds = 180;
  int _roundSeconds = 60;

  // initialize timer
  @override
  void initState() {
    super.initState();
    const oneSec = Duration(seconds: 1);
    _gameTimer = Timer.periodic(
      oneSec,
      (Timer timer) {
        if (_gameSeconds == 0) {
          setState(() {
            timer.cancel();
          });
        } else {
          setState(() {
            _gameSeconds--;
          });
        }
      },
    );
    _roundTimer = Timer.periodic(
      oneSec,
      (Timer timer) {
        if (_roundSeconds == 0) {
          setState(() {
            timer.cancel();
          });
        } else {
          setState(() {
            _roundSeconds--;
          });
        }
      },
    );
  }

  // cancel timer when removing widget
  @override
  void dispose() {
    _gameTimer.cancel();
    _roundTimer.cancel();
    super.dispose();
  }

  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  static const CameraPosition umasscampus = CameraPosition(
    target: LatLng(42.390663, -72.528478),
    zoom: 15.8,
  );

  LatLng guessPos = const LatLng(0, 0);

  LatLng answerPos = const LatLng(42.389777, -72.523340);

  Polyline line = const Polyline(
      polylineId: PolylineId('guessanswerline'),
      points: <LatLng>[LatLng(0, 0), LatLng(0, 0)]);

  double dist = 0;

  double degToRad(deg) {
    return (deg * pi) / 180;
  }

  void makeGuess() {
    setState(() {
      line = Polyline(
          width: 3,
          polylineId: const PolylineId('guessanswerline'),
          points: <LatLng>[guessPos, answerPos]);

      // dist = acos(sin(lat1)*sin(lat2)+cos(lat1)*cos(lat2)*cos(lon2-lon1))*6371  (in kilometers)
      dist = (acos((sin(degToRad(guessPos.latitude)) *
                      sin(degToRad(answerPos.latitude))) +
                  (cos(degToRad(guessPos.latitude)) *
                      cos(degToRad(answerPos.latitude)) *
                      cos(degToRad(
                          answerPos.longitude - guessPos.longitude)))) *
              6371) *
          1000;

      _score = (1000.0 - (1000.0 * (dist / 1000)))
          .toInt(); // (time remaining/total time)

      if (_score < 0) {
        _score = 0;
      }
    });
  }

  void markGuess(coords) {
    setState(() {
      guessPos = coords;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Row(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          //
          // TRY THIS: Invoke "debug painting" (choose the "Toggle Debug Paint"
          // action in the IDE, or press "p" in the console), to see the
          // wireframe for each widget.
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              width: 750,
              height: 750,
              child: GoogleMap(
                onTap: (coords) => markGuess(coords),
                markers: {
                  Marker(
                    markerId: const MarkerId('guess'),
                    position: guessPos,
                  ),
                  Marker(
                    markerId: const MarkerId('answer'),
                    position: answerPos,
                  )
                },
                polylines: {line},
                cloudMapId: '74ae03550584037b',
                cameraTargetBounds: CameraTargetBounds(LatLngBounds(
                    southwest: const LatLng(42.383764, -72.536265),
                    northeast: const LatLng(42.396610, -72.516493))),
                minMaxZoomPreference: const MinMaxZoomPreference(15.5, 19),
                initialCameraPosition: umasscampus,
                onMapCreated: (GoogleMapController controller) {
                  _controller.complete(controller);
                },
              ),
            ),
            Image.asset('images/image_1.png', scale: 2.5),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FloatingActionButton(
              onPressed: makeGuess,
              child: const Text("Guess"),
            ),
            Container(
              margin: const EdgeInsets.all(8.0),
              child: Text("score: $_score"),
            ),
            Container(
              margin: const EdgeInsets.all(8.0),
              child: Text("round time: $_roundSeconds"),
            ),
            Container(
              margin: const EdgeInsets.all(8.0),
              child: Text("game time: $_gameSeconds"),
            ),
            Container(
              margin: const EdgeInsets.all(8.0),
              child: Text("distance: ${dist.toInt()} meters"),
            ),
          ],
        ),
      ),
    );
  }
}
