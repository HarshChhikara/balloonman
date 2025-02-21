import 'dart:async';
import 'package:balloonman/constants.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import '../game.dart';

class Cloud extends SpriteComponent
    with CollisionCallbacks, HasGameRef<BalloonMan> {
  bool scored = false;
  final bool isCloud;

  Cloud(Vector2 position, Vector2 size, {required this.isCloud})
      : super(
          position: position,
          size: size,
          anchor: Anchor.center,
        );

  @override
  FutureOr<void> onLoad() async {
    sprite = await Sprite.load('final_cloud_sprite.png');
    debugMode = false;
    add(
      RectangleHitbox(
        size: Vector2(size.x * 0.60, size.y * 0.25),
        position: Vector2(size.x * 0.22, size.y * 0.3),
      )..renderShape = false,
    );
  }

  @override
  void update(double dt) {
    position.y += backgroundScrollingSpeed * dt;
    if (!scored && gameRef.man.position.y < position.y) {
      scored = true;
      if (isCloud) {
        gameRef.incrementScore();
      }
    }
    if (position.y > game.size.y) {
      removeFromParent();
    }
  }
}
