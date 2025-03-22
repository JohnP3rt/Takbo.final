import 'dart:async';
import 'package:flame/components.dart';
import 'package:flame/parallax.dart';
import 'package:takbo/game.dart';

class ParallaxBackground extends ParallaxComponent<ManananggalGame>
    with HasGameRef<ManananggalGame> {
  @override
  FutureOr<void> onLoad() async {
    // TODO: implement onLoad

    parallax = await game.loadParallax(
      [
        ParallaxImageData('og/Background 1.png'),
        ParallaxImageData('og/Background 2.png'),
        ParallaxImageData('og/Background 3.png'),
      ],
      baseVelocity: Vector2(50, 0),
      velocityMultiplierDelta: Vector2(1.5, 0),
    );

    parallax?.layers[0].velocityMultiplier = Vector2(0, 0);

    return super.onLoad();
  }
}
