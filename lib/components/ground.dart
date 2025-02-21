import 'dart:async';
import 'package:flame/components.dart';
import '../game.dart';

class Ground extends SpriteComponent with HasGameRef<BalloonMan> {
  Ground() : super();

  @override
  FutureOr<void> onLoad() async {
    size = Vector2(gameRef.size.x, 200);
    position = Vector2(0, 0);
  }
}
