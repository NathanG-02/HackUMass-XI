import "package:flutter/material.dart";
import 'dart:async';
import 'package:google_maps_flutter/google_maps_flutter.dart';

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

  void _makeGuess() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _score++;
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
      body: Stack(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
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
          children: <Widget>[
            SizedBox(
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
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FloatingActionButton(
              onPressed: _makeGuess,
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
          ],
        ),
      ),
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
          icon: Image.asset('images/image_1.PNG'),
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