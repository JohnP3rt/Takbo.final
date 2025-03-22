import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:takbo/components/manananggal.dart';
import 'package:takbo/constants.dart';
import 'package:takbo/game.dart';

class BuntisPowerUp extends SpriteComponent
    with CollisionCallbacks, HasGameRef<ManananggalGame> {
  BuntisPowerUp(Vector2 position, Vector2 size)
      : super(position: position, size: size);

  @override
  FutureOr<void> onLoad() async {
    // TODO: implement onLoad

    sprite = await Sprite.load('og/Powerup.png');
    add(RectangleHitbox());
    return super.onLoad();
  }

  @override
  void update(double dt) {
    // TODO: implement update
    position.x -= groundScrollingSpeed * dt;
    
    if (position.x + size.x <= 0) {
      removeFromParent();
    }
    super.update(dt);
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    // TODO: implement onCollision
    if (other is Manananggal) {
      gameRef.incrementScoreBy(10);
      removeFromParent();
    }
    super.onCollision(intersectionPoints, other);
  }
}
