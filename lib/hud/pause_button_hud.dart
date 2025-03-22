import 'package:flutter/material.dart';
import 'package:takbo/game.dart';

class PauseButton extends StatelessWidget {
  const PauseButton(this.game, {super.key});
  final ManananggalGame game;

  @override
  Widget build(BuildContext context) {
    return Positioned(
        child: IconButton(
            onPressed: () {
              game.togglePause();
            },
            icon: Icon(
              Icons.pause,
              size: 40,
              color: Colors.white,
            )));
  }
}
