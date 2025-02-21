import 'dart:async';
import 'package:balloonman/constants.dart';
import 'package:flame/components.dart';
import '../game.dart';

class Background extends SpriteComponent with HasGameRef<BalloonMan> {
  Background(Vector2 size)
      : super(
          size: size,
          position: Vector2(0, 0),
        );

  @override
  FutureOr<void> onLoad() async {
    size = Vector2(gameRef.size.x, 2 * gameRef.size.y);
    position = Vector2(0, 0);
    sprite = await Sprite.load('final_background_sprite.png');
  }

  @override
  void update(double dt) {
    position.y -= backgroundScrollingSpeed * dt;

    if (position.y + size.y / 2 <= 0) {
      position.y = 0;
    }
  }
}
