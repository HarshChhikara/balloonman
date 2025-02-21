import 'dart:async';
import 'package:balloonman/components/coin.dart';
import 'package:balloonman/game.dart';
import 'package:balloonman/components/cloud.dart';
import 'package:flame/collisions.dart';
import 'package:balloonman/constants.dart';
import 'package:flame/components.dart';

class Man extends SpriteComponent
    with CollisionCallbacks, HasGameRef<BalloonMan> {
  Man() : super(size: Vector2(manWidthX, manHeightY));

  double velocity = 0;

  @override
  FutureOr<void> onLoad() async {
    sprite = await Sprite.load('final_man_sprite.png');
    debugMode = false;

    position = Vector2(
      (gameRef.size.x - size.x) / 2,
      gameRef.size.y - size.y - 50,
    );

    add(
      RectangleHitbox(
        size: Vector2(size.x * 0.41, size.y * 0.2),
        position: Vector2(size.x * 0.22, size.y * 0.14),
      )..renderShape = false,
    );
  }

  void move(Vector2 delta) {
    position.add(delta);
  }

  @override
  void update(double dt) {
    velocity += gravity * dt;
    position.y += velocity * dt;
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);

    if (other is Cloud) {
      (parent as BalloonMan).gameOver();
    }
    if (other is Coin) {
      other.collect();
    }
  }
}
