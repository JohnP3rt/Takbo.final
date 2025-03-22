import 'package:flutter/material.dart';
import 'package:takbo/game.dart';

class PauseMenu extends StatelessWidget {
  const PauseMenu(this.game, {super.key});
  final ManananggalGame game;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: 100,
        width: 200,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: Color.fromRGBO(255, 255, 255, 0.30)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Resume",
              style: TextStyle(
              fontSize: 24,
              decoration: TextDecoration.none,
              color: Colors.white,
              fontFamily: "PressStart2P"
            )
            ),
            IconButton(
                onPressed: game.togglePause,
                icon: Icon(
                  Icons.play_arrow,
                  color: Colors.white,
                  size: 30,
                ))
          ],
        ),
      ),
    );
  }
}
