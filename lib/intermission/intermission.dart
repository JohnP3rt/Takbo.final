import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:just_audio/just_audio.dart';
import 'package:takbo/game.dart';

class StoryIntermissionScreen extends StatefulWidget {
  final ManananggalGame game;

  const StoryIntermissionScreen(this.game, {Key? key}) : super(key: key);

  @override
  _StoryIntermissionScreenState createState() =>
      _StoryIntermissionScreenState();

  // State<StoryIntermissionScreen> createState() => _StoryIntermissionScreenState();
}

class _StoryIntermissionScreenState extends State<StoryIntermissionScreen> {
  PageController _pageController = PageController();
  int _currentIndex = 0;
  Timer? _timer;
  late AudioPlayer audioPlayer;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    audioPlayer = AudioPlayer();
    togglePlayer();
    _startSlideshow();
  }

  void togglePlayer() async {
    audioPlayer.setAsset('assets/audio/introdu_bg.mp3');
    audioPlayer.setLoopMode(LoopMode.one);
    audioPlayer.play();
  }

  void _startSlideshow() {
    _timer = Timer.periodic(Duration(seconds: 3), (timer) {
      if (_currentIndex < 9) {
        setState(() {
          _currentIndex++;
        });

        _pageController.animateToPage(
          _currentIndex,
          duration: Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      } else {
        _timer?.cancel();
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            itemCount: 10,
            physics: NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              return Image.asset(
                'assets/images/intermission/frame${index + 1}.jpg',
                fit: BoxFit.fill,
                width: double.infinity,
                height: double.infinity,
              );
            },
          ),
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
                      "Simula",
                      style: TextStyle(color: Colors.redAccent.shade400),
                    ),
                  ),
                ))
        ],
      ),
    );
  }
}
