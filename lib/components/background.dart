import 'dart:async';

import 'package:flame/components.dart';

class Background extends SpriteComponent {
  Background(Vector2 size)
      : super(
          size: size,
          position: Vector2(0, 0),
        );

  @override
  FutureOr<void> onLoad() async {
    // TODO: implement onLoad
    sprite = await Sprite.load('og/Background 1.png');
  }
}
