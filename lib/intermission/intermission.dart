import 'dart:async';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:takbo/game.dart';

class StoryIntermissionScreen extends StatefulWidget {
  final ManananggalGame game;

  const StoryIntermissionScreen(this.game, {Key? key}) : super(key: key);

  @override
  _StoryIntermissionScreenState createState() => _StoryIntermissionScreenState();
}

class _StoryIntermissionScreenState extends State<StoryIntermissionScreen> {
  int _currentIndex = 0;
  Timer? _timer;
  late AudioPlayer audioPlayer;
  
  @override
  void initState() {
    super.initState();
    audioPlayer = AudioPlayer();
    togglePlayer();
    _startSlideshow();
  }

  void togglePlayer() async {
    audioPlayer.setAsset('assets/audio/ili_ili.wav');
    audioPlayer.setLoopMode(LoopMode.one);
    audioPlayer.play();
  }

  void _startSlideshow() {
    _timer = Timer.periodic(Duration(seconds: 2), (timer) {
      if (_currentIndex < 9) {
        setState(() {
          _currentIndex++;
        });
      } else {
        _timer?.cancel();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Stack all images on top of each other with fade transition
          for (int i = 0; i < 10; i++)
            AnimatedOpacity(
              duration: Duration(
                seconds: 1,
              ),  // Fade duration
              opacity: i == _currentIndex ? 1.0 : 0.0,
              child: Image.asset(
                'assets/images/intermission/frame${i + 1}.jpg',
                fit: BoxFit.fill,
                width: double.infinity,
                height: double.infinity,
              ),
            ),

          // Show "Continue" button at the end
          if (_currentIndex >= 9)
            Positioned(
              bottom: 50,
              left: 0,
              right: 0,
              child: Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.white,
                  ),
                  onPressed: () {
                    widget.game.resumeAfterIntermission();
                   
                    audioPlayer.pause();
                  },
                  child: Text(
                    "Magpatuloy",
                    style: TextStyle(color: Colors.redAccent.shade400),
                  ),
                ),
              ),
            )
        ],
      ),
    );
  }
}
