import 'dart:async';
import 'package:balloonman/constants.dart';
import 'package:flame/components.dart';
import 'package:flame/collisions.dart';
import '../game.dart';

class Coin extends SpriteComponent
    with CollisionCallbacks, HasGameRef<BalloonMan> {
  bool collected = false;
  final bool isPurple;

  Coin(Vector2 position, Vector2 size, {this.isPurple = false})
      : super(position: position, size: size, anchor: Anchor.center);

  @override
  FutureOr<void> onLoad() async {
    sprite = await Sprite.load(
        isPurple ? 'final_double_coin_sprite.png' : 'final_coin_sprite.png');
    add(CircleHitbox(
      radius: size.x * 0.4, // Hitbox is 80% of the coin's width
      position: Vector2(size.x * 0.1, size.y * 0.1),
    ));
  }

  @override
  void update(double dt) {
    position.y += backgroundScrollingSpeed * dt;
    if (position.y > gameRef.size.y) {
      removeFromParent();
    }
  }

  void collect() {
    if (!collected) {
      collected = true;
      gameRef.audioManager.play('coin_collecting_sound_effect.wav');
      if (isPurple) {
        gameRef.incrementDoubleScore();
      } else {
        gameRef.incrementScore();
      }
      removeFromParent();
    }
  }
}
