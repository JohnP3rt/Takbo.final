import 'dart:math';
import 'package:flame/components.dart';
import 'package:takbo/components/bottom_power_up.dart';
import 'package:takbo/components/obstacle.dart';
import 'package:takbo/constants.dart';
import 'package:takbo/game.dart';
import 'package:takbo/components/floating_power_up.dart';

class ObstacleManager extends Component with HasGameRef<ManananggalGame> {
  double obstacleSpawnTimer = 0;

  @override
  void update(double dt) {
    // TODO: implement update
    obstacleSpawnTimer += dt;

    if (obstacleSpawnTimer > obstacleInterval) {
      obstacleSpawnTimer = 0;
      spawnPipe();
    }

    if (Random().nextDouble() < 0.0005) {
      spawnBottomPowerUp();
    }
  }

  void spawnBottomPowerUp() {
    final double groundY = gameRef.size.y - groundHeight;
    final double powerUpX =
        gameRef.size.x + Random().nextDouble() * 100; // Spawns slightly ahead

    final powerUp = BuntisPowerUp(
      Vector2(powerUpX, groundY - 40), // ✅ Position just above the ground
      Vector2(40, 40),
    );

    gameRef.add(powerUp);
  }

  void spawnPipe() {
    final double screenHeight = gameRef.size.y;

    // ✅ Introduce randomness to pipe gap size
    final double dynamicPipeGap =
        obstacleGap + Random().nextDouble() * 40.0; // Varies by 40px

    // ✅ Generate a random offset for variation in height
    final double offset = Random().nextDouble() * 50.0 - 25.0; // ±25 pixels

    final double maxPipeHeight = screenHeight - dynamicPipeGap - minPipeHeight;
    final double bottomPipeHeight = minPipeHeight +
        Random().nextDouble() * (maxPipeHeight - minPipeHeight) +
        offset;

    final double topPipeHeight =
        screenHeight - groundHeight - bottomPipeHeight - dynamicPipeGap;
 
    final double safeTopHeight = topPipeHeight.clamp(minPipeHeight, screenHeight - dynamicPipeGap - groundHeight);
    final double safeBottomHeight = bottomPipeHeight.clamp(minPipeHeight, screenHeight - groundHeight);

    // ✅ Adjust pipe positions for "windowed" layout
    final bottomPipe = Obstacle(
        Vector2(gameRef.size.x, screenHeight - groundHeight - safeBottomHeight),
        Vector2(obstacleWidth, safeBottomHeight),
        isTopObstacle: false);

    final topPipe = Obstacle(
        Vector2(gameRef.size.x, 0), Vector2(obstacleWidth, safeTopHeight),
        isTopObstacle: true);

    gameRef.add(bottomPipe);
    gameRef.add(topPipe);

    if (Random().nextDouble() < 0.1) {
    final floatingPowerUp = FloatingPowerUp(
      Vector2(
        gameRef.size.x, // Align with the pipes
        screenHeight - groundHeight - safeBottomHeight - 50, // Just above bottom pipe
      ),
      Vector2(40, 40),
    );
      gameRef.add(floatingPowerUp);
    }
  }
}
