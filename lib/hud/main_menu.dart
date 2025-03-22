import 'package:flutter/material.dart';
import 'package:takbo/game.dart';
import 'package:just_audio/just_audio.dart';

class MainMenu extends StatefulWidget {
  const MainMenu(this.game, {super.key});
  final ManananggalGame game;

  @override
  _MainMenuState createState() => _MainMenuState();
}

class _MainMenuState extends State<MainMenu> {
  late AudioPlayer _audioPlayer;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    _playIntroAudio();
  }

  Future<void> _playIntroAudio() async {
    await _audioPlayer.setAsset('assets/audio/ili_ili.wav');
    _audioPlayer.setLoopMode(LoopMode.one);
    _audioPlayer.play();
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Sa Kanto',
              style: TextStyle(
                decoration: TextDecoration.none,
                color: Colors.white,
                fontFamily: "PressStart2P",
              )),
          SizedBox(
            height: 35,
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(),
            onPressed: () {
              _audioPlayer.pause();
              widget.game.gameStart = true;
              widget.game.togglePlayer();
              widget.game.overlays.add('PauseButton');
              widget.game.overlays.add('ScoreHUD');
            },
            child: Text(
              'Simula',
              style: TextStyle(color: Colors.red),
            ),
          )
        ],
      ),
    );
  }
}
