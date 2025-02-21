import 'dart:async';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import '../game.dart';

class ScoreText extends TextComponent with HasGameRef<BalloonMan> {
  ScoreText()
      : super(
          text: '0',
          textRenderer: TextPaint(
            style: TextStyle(
              color: Colors.grey.shade900,
              fontSize: 48,
            ),
          ),
          priority: 100,
        );

  @override
  FutureOr<void> onLoad() {
    double topPadding = 50;

    anchor = Anchor.topCenter;
    position = Vector2(
      gameRef.size.x / 2,
      topPadding,
    );
  }

  @override
  void update(double dt) {
    final newText = gameRef.score.toString();
    if (text != newText) {
      text = newText;
      width = (text.length * 24).toDouble();
    }
  }
}
