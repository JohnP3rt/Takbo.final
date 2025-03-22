import 'dart:async';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:takbo/components/manananggal.dart';
import 'package:takbo/constants.dart';
import 'package:takbo/game.dart';

class FloatingPowerUp extends SpriteComponent
    with CollisionCallbacks, HasGameRef<ManananggalGame> {
  FloatingPowerUp(Vector2 position, Vector2 size)
      : super(position: position, size: size);

  @override
  FutureOr<void> onLoad() async {
    sprite = await Sprite.load('powerup.png'); // Add your power-up sprite here
    add(RectangleHitbox());
  }

  @override
  void update(double dt) {
    position.x -= groundScrollingSpeed * dt;
    if (position.x + size.x <= 0) {
      removeFromParent();
    }
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    if (other is Manananggal) {
      gameRef.incrementScoreBy(5); // Grant 5 extra points
      removeFromParent();
    }
    super.onCollision(intersectionPoints, other);
  }
}
