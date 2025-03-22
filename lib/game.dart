import 'dart:async';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:takbo/components/background.dart';
import 'package:takbo/components/bottom_power_up.dart';
import 'package:takbo/components/floating_power_up.dart';
import 'package:takbo/components/manananggal.dart';
import 'package:takbo/components/ground.dart';
import 'package:takbo/components/parallax_background.dart';
import 'package:takbo/components/obstacle_manager.dart';
import 'package:takbo/components/obstacle.dart';
import 'package:takbo/constants.dart';

class ManananggalGame extends FlameGame
    with TapDetector, HasCollisionDetection {
  late Manananggal player;
  late Background background;
  late Ground ground;
  late ObstacleManager obstacleManager;
  late AudioPlayer _audioPlayer;
  late AudioPlayer audioFlap;
  late ParallaxBackground parallax;
  ValueNotifier<int> score = ValueNotifier<int>(0);
  late SharedPreferences sharedPrefs;
  bool gameStart = false;
  bool gameComplete = false;
  bool isGameOver = false;
  bool isPaused = false;
  bool isComplete = false;
  var highestScore;

  @override
  FutureOr<void> onLoad() async {
    debugMode = false;
    // background = Background(size);
    // add(background);

    parallax = ParallaxBackground();
    add(parallax);

    player = Manananggal();
    add(player);

    ground = Ground();
    add(ground);

    obstacleManager = ObstacleManager();

    _audioPlayer = AudioPlayer();
    await _audioPlayer.setAsset('assets/audio/scariest_bg.mp3');

    audioFlap = AudioPlayer();
    await audioFlap.setAsset('assets/audio/flap.wav');

    _audioPlayer.setLoopMode(LoopMode
        .one); //ginawa ko siyang all, diko na natest pero naka one lang sakin kanina, parang 1 time looping lang kasi
  }

  @override
  void onDetach() {
    _audioPlayer.dispose(); // Properly dispose of the audio player
    super.onDetach();
  }

  @override
  void onTap() {
    if (gameStart) {
      player.flap();
      audioFlap.seek(Duration.zero);
      audioFlap.play();
    }
  }

  @override
  void onTapDown(TapDownInfo info) {
    player.isGliding = true;
  }

  @override
  void onTapUp(TapUpInfo info) {
    player.isGliding = false;
  }

  void incrementScore() => score.value += 1;

  void incrementScoreBy(int points) => score.value += points;
  int lastDifficultyIncrease = 0;

  void increaseDifficulty() {
    if (score.value % 10 == 0 &&
        score.value > 0 &&
        lastDifficultyIncrease != score.value) {
      groundScrollingSpeed += 20;
      obstacleInterval = (obstacleInterval - .5).clamp(1.0, double.infinity);
      lastDifficultyIncrease = score.value;
    }
  }

  void compareScore() async {
    sharedPrefs = await SharedPreferences.getInstance();
    highestScore = sharedPrefs.getInt('highestScore');
    if (highestScore != null) {
      if (score.value > highestScore) {
        await sharedPrefs.setInt('highestScore', score.value);
      }
    } else {
      await sharedPrefs.setInt('highestScore', score.value);
    }
  }

  void togglePlayer({bool forceStop = false}) async {
    if (forceStop) {
      await _audioPlayer.stop();
      return;
    }

    if (_audioPlayer.processingState == ProcessingState.ready &&
        _audioPlayer.playing) {
      await _audioPlayer.stop();
    } else {
      _audioPlayer.seek(Duration.zero);
      await _audioPlayer.play();
    }
  }

  void gameDone() {
    if (!gameComplete) {
      gameComplete = true;
      togglePause();
      togglePlayer(forceStop: true);
      overlays.add('Intermission');
      overlays.remove('PauseButton');
    }
  }

  void resumeAfterIntermission() {
    overlays.remove('Intermission');
    togglePlayer();
  }

  void gameOver() {
    if (isGameOver) return;
    isGameOver = true;
    pauseEngine();
    obstacleInterval = 3;
    groundScrollingSpeed = 150;
    overlays.remove('PauseButton');
    overlays.remove('ScoreHUD');
    overlays.add('GameOverHUD');
  }

  void resetGame() {
    player.position = Vector2(playerStartX, playerStartY);
    player.velocity = 0;
    score.value = 0;
    isGameOver = false;
    gameComplete = false;
    children.whereType<Obstacle>().forEach((pipe) => pipe.removeFromParent());
    children
        .whereType<BuntisPowerUp>()
        .forEach((buntis) => buntis.removeFromParent());
    resumeEngine();
    children
        .whereType<FloatingPowerUp>()
        .forEach((power) => power.removeFromParent());
    resumeEngine();
    overlays.remove('GameOverHUD');
    overlays.add('ScoreHUD');
    overlays.add('PauseButton');
  }

  void togglePause() {
    isPaused = !isPaused;
    if (isPaused == true) {
      pauseEngine();
      overlays.add('PauseMenu');
      overlays.remove('PauseButton');
    } else {
      overlays.remove('PauseMenu');
      overlays.add('PauseButton');
      resumeEngine();
    }
  }

  @override
  void update(double dt) {
    // TODO: implement update
    compareScore();
    if (gameStart) {
      add(obstacleManager);
      if (obstacleInterval >= 1.0) {
        increaseDifficulty();
      }

      overlays.remove('MainMenu');
    }

    if (score.value >= 5 && !gameComplete) {
      gameDone();
    }

    super.update(dt);
  }
}
