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
  int _roundScore = 0;
  int _totalScore = 0;
  final List<String> _imagePaths = [
    "images/road_near_frank.png",
    "images/fine_arts_roof.jpg",
    "images/hasbrouck_bridge.jpg",
    "images/ilc_table_room.jpg",
    "images/back_of_hasbrouck.png",
    "images/front_of_hasbrouck.png",
    "images/integrated_science_bldg.png",
  ];
  final List<LatLng> _targetCoords = [
    const LatLng(42.389777, -72.523340),
    const LatLng(42.389777, -72.523340),
    const LatLng(42.389777, -72.523340),
    const LatLng(42.389777, -72.523340),
    const LatLng(42.391851, -72.526404),
    const LatLng(42.392471, -72.526093),
    const LatLng(42.391759, -72.524170),
  ];
  int _roundIndex = 0;

  // switch image to next in array
  // if went thru all images, stop game
  void _switchTargetLocation() {
    setState(() {
      _roundIndex = _roundIndex + 1;
    });
    if (_roundIndex == _imagePaths.length) {
      _stopGame();
    }
  }

  // late means not initialized until first use
  late Timer gameTimer;
  late Timer roundTimer;
  final int _totalRoundSeconds = 30;
  int _gameSeconds = 210;
  int _roundSeconds = 30;

  Timer _startRoundTimer() {
    const oneSec = Duration(seconds: 1);
    return Timer.periodic(
      oneSec,
      (Timer timer) {
        if (_roundSeconds == 0) {
          setState(() {
            timer.cancel();
          });
        } else if (_roundSeconds == 1) {
          // weird thing when roundTime = 0 but gameTime still goes down
          setState(() {
            _roundSeconds--;
            _stopRound();
          });
        } else if (_roundOver) {
          // do nothing
        } else if (!_roundOver) {
          setState(() {
            _roundSeconds--;
          });
        }
      },
    );
  }

  // initialize timer
  @override
  void initState() {
    super.initState();
    const oneSec = Duration(seconds: 1);
    gameTimer = Timer.periodic(
      oneSec,
      (Timer timer) {
        if (_gameSeconds == 0) {
          setState(() {
            timer.cancel();
            _stopGame();
          });
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Timer Finished'),
                content: const Text('The timer has run out.'),
                actions: [
                  ElevatedButton(
                    onPressed: () {
                      _nextRound();
                      Navigator.of(context).pop(); // Close the dialog
                    },
                    child: const Text('Next'),
                  ),
                ],
              );
            },
          );
          // stop game timer from running while round is over
        } else if (!_roundOver) {
          setState(() {
            _gameSeconds--;
          });
        }
      },
    );
    roundTimer = _startRoundTimer();
  }

  // cancel timer when removing widget
  @override
  void dispose() {
    gameTimer.cancel();
    roundTimer.cancel();
    super.dispose();
  }

  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  static const CameraPosition umasscampus = CameraPosition(
    target: LatLng(42.390663, -72.528478),
    zoom: 15.8,
  );

  LatLng guessPos = const LatLng(0, 0);

  LatLng answerPos = const LatLng(0, 0);

  Polyline line = const Polyline(
      polylineId: PolylineId('guessanswerline'),
      points: <LatLng>[LatLng(0, 0), LatLng(0, 0)]);

  double dist = 0;

  double degToRad(deg) {
    return (deg * pi) / 180;
  }

  void makeGuess() {
    setState(() {
      answerPos = _targetCoords[_roundIndex];

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

      _roundScore = ((1000.0 - (1000.0 * (dist / 1000))) *
              ((_roundSeconds) / _totalRoundSeconds))
          .toInt();

      if (_roundScore < 0) {
        _roundScore = 0;
      }

      _totalScore += _roundScore;
    });

    _stopRound();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Text(
              "Distance: ${dist.toInt()} meters \n Round time: ${_totalRoundSeconds - _roundSeconds} seconds\n Round score: $_roundScore points",
              style: const TextStyle(fontWeight: FontWeight.bold),
              textAlign: TextAlign.center),
          actions: [
            ElevatedButton(
              onPressed: () {
                roundTimer.cancel();
                _nextRound();
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Next'),
            ),
          ],
        );
      },
    );
  }

  void markGuess(coords) {
    setState(() {
      guessPos = coords;
    });
  }

  void _nextRound() {
    setState(() {
      _roundOver = false;
      _roundSeconds = _totalRoundSeconds;
      roundTimer = _startRoundTimer();
      line = const Polyline(
          polylineId: PolylineId('guessanswerline'),
          points: <LatLng>[LatLng(0, 0), LatLng(0, 0)]);
      guessPos = const LatLng(0, 0);
      answerPos = const LatLng(0, 0);
    });
    _switchTargetLocation();
  }

  void _stopRound() {
    setState(() {
      _roundOver = true;
    });
  }

  void _stopGame() {
    setState(() {
      _gameOver = true;
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
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Stack(
        children: <Widget>[
          SizedBox(
            width: double.infinity,
            height: double.infinity,
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
          Align(
            alignment: Alignment.centerRight,
            child: IconButtonExample(
                imagePaths: _imagePaths, currentImageIdx: _roundIndex),
          ),
        ],
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
              child: Text("distance: ${dist.toInt()} meters"),
            ),
            Container(
              margin: const EdgeInsets.all(8.0),
              child: Text("round score: $_roundScore"),
            ),
            Container(
              margin: const EdgeInsets.all(8.0),
              child: Text("total score: $_totalScore"),
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
  final List<String> imagePaths;
  final int currentImageIdx;
  const IconButtonExample(
      {super.key, required this.imagePaths, required this.currentImageIdx});

  @override
  State<IconButtonExample> createState() => _IconButtonExampleState();
}

class _IconButtonExampleState extends State<IconButtonExample> {
  double _scale = 0.5;
  int _coeff = -1;
  @override
  Widget build(BuildContext context) {
    return Transform.scale(
        scale: _scale,
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.inversePrimary,
          ),
          child: IconButton(
              icon: Image.asset(widget.imagePaths[widget.currentImageIdx],
                  scale: 2.5),
              tooltip: 'Expand image',
              onPressed: () {
                setState(() {
                  _coeff = _coeff * -1;
                  _scale = _scale + 0.54 * _coeff;
                });
              }),
        ));
  }
}
