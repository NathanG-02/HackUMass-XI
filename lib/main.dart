import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:math';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'UMass GeoGuessr App',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a blue toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(
            seedColor: const Color.fromARGB(255, 163, 25, 25)),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'UMass GeoGuessr'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
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
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      line = Polyline(
          width: 3,
          polylineId: const PolylineId('guessanswerline'),
          points: <LatLng>[guessPos, answerPos]);

      // dist = acos(sin(lat1)*sin(lat2)+cos(lat1)*cos(lat2)*cos(lon2-lon1))*6371  (in kilometers)
      dist = acos((sin(degToRad(guessPos.latitude)) *
                  sin(degToRad(answerPos.latitude))) +
              (cos(degToRad(guessPos.latitude)) *
                  cos(degToRad(answerPos.latitude)) *
                  cos(degToRad(answerPos.longitude - guessPos.longitude)))) *
          6371;
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
            Text(dist.toString()),
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
            Image.asset('images/Image 1.png', scale: 2.5),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        child: Container(height: 50.0),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: makeGuess,
        tooltip: 'Make your guess',
        label: const Text('Guess'),
        icon: const Icon(Icons.check_circle_outline),
      ), // This trailing comma makes auto-formatting nicer for build methods.
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
