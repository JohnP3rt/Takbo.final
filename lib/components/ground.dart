import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:takbo/constants.dart';
import 'package:takbo/game.dart';

class Ground extends SpriteComponent
    with HasGameRef<ManananggalGame>, CollisionCallbacks {
  Ground() : super();

  @override
  FutureOr<void> onLoad() async {
    size = Vector2(2 * gameRef.size.x, groundHeight);
    position = Vector2(0, gameRef.size.y - groundHeight);

    sprite = await Sprite.load('og/Ground_copy.png');

    add(RectangleHitbox());
  }

  @override
  void update(double dt) {
    position.x -= groundScrollingSpeed * dt;
    if (position.x + size.x / 2 <= 0) {
      position.x = 0;
    }
  }
}
