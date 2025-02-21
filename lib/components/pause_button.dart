import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import '../game.dart';
import 'package:flame/events.dart';
import 'package:flame_audio/flame_audio.dart';

class PauseButton extends PositionComponent
    with TapCallbacks, HasGameRef<BalloonMan> {
  PauseButton() : super(priority: 100);
  late TextPaint textPaint;

  @override
  Future<void> onLoad() async {
    size = Vector2(50, 50);
    double topPadding = 50;
    double rightPadding = 20;

    anchor = Anchor.topRight;

    position = Vector2(
      gameRef.size.x - rightPadding,
      topPadding,
    );
    textPaint = TextPaint(
      style: const TextStyle(
        fontSize: 40,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    );
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    textPaint.render(canvas, "⏸", Vector2(10, 5));
  }

  @override
  void onTapDown(TapDownEvent event) {
    FlameAudio.bgm.stop();
    gameRef.togglePause();
  }
}
