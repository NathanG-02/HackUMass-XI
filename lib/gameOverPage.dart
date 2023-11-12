import 'package:flutter/material.dart';
import 'package:umass_geoguessr_app/main.dart';
import 'package:umass_geoguessr_app/homePage.dart';

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
    return Container(
        decoration:
            const BoxDecoration(color: Color.fromARGB(255, 163, 25, 25)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Score: ${widget.score}",
                style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    decoration: TextDecoration.none)),
            Text("Time: ${widget.time}",
                style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    decoration: TextDecoration.none)),
            const Text("Play again?",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    decoration: TextDecoration.none)),
            Container(
              padding: const EdgeInsets.all(30.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 76, 76, 76),
                      ),
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (BuildContext context) => const MyApp()));
                      },
                      child: const Text("Yes",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white))),
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 76, 76, 76),
                      ),
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            // link to home page
                            builder: (BuildContext context) =>
                                const HomePage()));
                      },
                      child: const Text("No",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white))),
                ],
              ),
            ),
          ],
        ));
  }
}
