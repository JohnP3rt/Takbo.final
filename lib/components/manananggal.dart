import 'dart:async';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:takbo/components/ground.dart';
import 'package:takbo/components/obstacle.dart';
import 'package:takbo/constants.dart';
import 'package:takbo/game.dart';

class Manananggal extends SpriteAnimationComponent with CollisionCallbacks, HasGameRef<ManananggalGame> {
  final Vector2 hiddenPosition = Vector2(-150, playerStartY); 
  final Vector2 targetPosition = Vector2(playerStartX, playerStartY); 

  Manananggal() : super( position: Vector2(playerStartX, playerStartY), size: Vector2(playerWidth, playerHeight));

  double velocity = 0;
  bool isGliding = false; 

  @override
  FutureOr<void> onLoad() async {
    // TODO: implement onLoad
    final spriteSheet = await Flame.images.load('og/Manananggal.png');
    final data = SpriteAnimationData.sequenced(
      textureSize: Vector2(150, 65), 
      amount: 6, 
      stepTime: 0.12, 
      loop: true
    );
    animation = SpriteAnimation.fromFrameData(spriteSheet, data);
    add(RectangleHitbox.relative(
      Vector2(0.8, 0.5),
      parentSize: Vector2(playerWidth, playerHeight)
    ));

    return super.onLoad();
  }

  void flap() {
    velocity = jumpStrength;
  }

  @override
  void update(double dt) {
    // TODO: implement update

    if (!gameRef.gameStart) {
      position = hiddenPosition; // Nakatago si Manananggalis
    } else {
      // Punta siya sa target position
      if (position.x < targetPosition.x) {
        position.x += groundScrollingSpeed * dt; // Move towards right
      } else {
        position.x = targetPosition.x; // Stop at the target position
        
        if (position.y < 0) {
          position.y = 0;
        }

        if (isGliding) {
          velocity = glideUpwardVelocity;
        } else {
          velocity += gravity * dt;
        }

        position.y += velocity * dt;
      }
    }

    super.update(dt);
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    // TODO: implement onCollision
    super.onCollision(intersectionPoints, other);

    if (other is Ground) {
      (parent as ManananggalGame).gameOver();
    }

    if (other is Obstacle) {
      (parent as ManananggalGame).gameOver();
    }
  }
}
