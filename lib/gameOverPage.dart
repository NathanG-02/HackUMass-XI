import 'package:flutter/material.dart';
import 'package:umass_geoguessr_app/gamePage.dart';

class GameOverPage extends StatefulWidget {
  final int score;
  final int time;
  const GameOverPage({super.key, required this.score, required this.time});

  @override
  State<GameOverPage> createState() => _GameOverPageState();
}

class _GameOverPageState extends State<GameOverPage> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
            padding: const EdgeInsets.all(8.0),
            child: Text("Score: ${widget.score}")),
        Container(
            padding: const EdgeInsets.all(8.0),
            child: Text("Time: ${widget.time}")),
        Container(
            padding: const EdgeInsets.all(8.0),
            child: const Text("Play again?")),
        Row(
          children: [
            ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (BuildContext context) => const GamePage()));
                },
                child: const Text("Yes")),
            ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    // link to home page
                      builder: (BuildContext context) => const GamePage()));
                },
                child: const Text("No")),
          ],
        ),
      ],
    );
  }
}
