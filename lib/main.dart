import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:takbo/game.dart';
import 'package:takbo/hud/game_over_hud.dart';
import 'package:takbo/hud/main_menu.dart';
import 'package:takbo/hud/pause_button_hud.dart';
import 'package:takbo/hud/pause_hud.dart';
import 'package:takbo/hud/score_hud.dart';
import 'package:takbo/intermission/intermission.dart';
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Flame.device.fullScreen();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]).then((_) {
    runApp(MyApp());
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: "PressStart2P"
      ),
      home: GameWidget(
        game: ManananggalGame(),
        overlayBuilderMap: {
          'PauseButton': (context, game) =>
              PauseButton(game as ManananggalGame),
          'PauseMenu': (context, game) => PauseMenu(game as ManananggalGame),
          'GameOverHUD' : (context, game) => GameOverHud(game as ManananggalGame),
          'MainMenu' : (context,game) => MainMenu(game as ManananggalGame),
          'ScoreHUD' : (context, game) => ScoreHUD(game as ManananggalGame),
          'Intermission' : (context, game) => StoryIntermissionScreen(game as ManananggalGame)
        },
        initialActiveOverlays: const ['MainMenu'],
      ),
    );
  }
}
