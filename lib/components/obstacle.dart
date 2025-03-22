import 'dart:async';
import 'dart:math';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:takbo/constants.dart';
import 'package:takbo/game.dart';

class Obstacle extends SpriteComponent
    with CollisionCallbacks, HasGameRef<ManananggalGame> {
  final bool isTopObstacle;
  bool scored = false;

  Obstacle(Vector2 position, Vector2 size, {required this.isTopObstacle})
      : super(position: position, size: size);

  @override
  FutureOr<void> onLoad() async {
    // TODO: implement onLoad
    final random = Random();
    String assetPath;

    if (isTopObstacle) {
      if (size.y < 120) {
        assetPath = random.nextBool() ? 'og/Top 1.png' :'og/Top 2 Small.png';
      } else {
        assetPath = random.nextBool() ? 'og/Top 1.png' : 'og/Top 2.png';
      }
    } else {
      assetPath = random.nextBool() ? 'og/Bottom 1.png' : 'og/Bottom 2.png';
    }
    sprite = await Sprite.load(assetPath);
    add(RectangleHitbox());
  }

  @override
  void update(double dt) {
    // TODO: implement update
    position.x -= groundScrollingSpeed * dt;

    if (!scored && position.x + size.x < gameRef.player.position.x) {
      scored = true;
      if (isTopObstacle) {
        gameRef.incrementScore();
      }
    }

    if (position.x + size.x <= 0) {
      removeFromParent();
    }
  }
}
