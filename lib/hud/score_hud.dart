import 'package:flutter/material.dart';
import 'package:takbo/game.dart';

class ScoreHUD extends StatefulWidget {
  final ManananggalGame game;
  const ScoreHUD(this.game, {super.key});

  @override
  State<ScoreHUD> createState() => _ScoreHUDState();
}

class _ScoreHUDState extends State<ScoreHUD> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          ValueListenableBuilder<int>(
            valueListenable: widget.game.score, // Listen to the score changes
            builder: (context, score, child) {
              return Text(
                score.toString(),
                style: const TextStyle(
                  decoration: TextDecoration.none,
                  color: Colors.white,
                  fontFamily: "PressStart2P",
                  fontSize: 20,
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
