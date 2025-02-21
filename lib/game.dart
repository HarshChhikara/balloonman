import 'dart:async';
import 'package:balloonman/components/audio_manager.dart';
import 'package:balloonman/components/background.dart';
import 'package:balloonman/components/cloud.dart';
import 'package:balloonman/components/cloud_manager.dart';
import 'package:balloonman/components/coin.dart';
import 'package:balloonman/components/coin_manager.dart';
import 'package:balloonman/components/ground.dart';
import 'package:balloonman/components/man.dart';
import 'package:balloonman/components/score.dart';
import 'package:balloonman/constants.dart';
import 'package:balloonman/screens/main_menu.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'components/pause_button.dart';
import 'package:flame_audio/flame_audio.dart';

class BalloonMan extends FlameGame
    with PanDetector, HasCollisionDetection, TapDetector {
  late Man man;
  late Background background;
  late Ground ground;
  late CloudManager cloudManager;
  late ScoreText scoreText;
  late CoinManager coinManager;
  late PauseButton pauseButton;
  late AudioManager audioManager;

  bool isPaused = false;

  @override
  FutureOr<void> onLoad() async {
    audioManager = AudioManager();
    await audioManager.initialize();
    add(audioManager);

    background = Background(size);
    add(background);

    ground = Ground();

    cloudManager = CloudManager();
    add(cloudManager);

    man = Man();
    add(man);

    coinManager = CoinManager();
    add(coinManager);

    scoreText = ScoreText();
    add(scoreText);

    await loadHighScore();

    pauseButton = PauseButton();
    add(pauseButton);
  }

  @override
  void onPanUpdate(DragUpdateInfo info) {
    man.move(info.delta.global);
  }

  int score = 0;
  int highScore = 0;
  void incrementScore() {
    score += 1;
  }

  void incrementDoubleScore() {
    score += 2;
  }

  Future<void> loadHighScore() async {
    final prefs = await SharedPreferences.getInstance();
    highScore = prefs.getInt('highScore') ?? 0;
  }

  Future<void> saveHighScore() async {
    final prefs = await SharedPreferences.getInstance();
    if (score > highScore) {
      highScore = score;
      await prefs.setInt('highScore', highScore);
    }
  }

  void togglePause() {
    if (isPaused) {
      resumeEngine();
    } else {
      pauseEngine();
      showPauseMenu();
    }
    isPaused = !isPaused;
  }

  void showPauseMenu() {
    showDialog(
      context: buildContext!,
      builder: (context) => AlertDialog(
        title: const Text("Game Paused"),
        actions: [
          Column(mainAxisSize: MainAxisSize.min, children: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                togglePause();
              },
              child: const Text("Resume"),
            ),
            const SizedBox(height: 0.5),
            TextButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MainMenu(
                      game: this,
                      audioManager: audioManager,
                    ),
                  ),
                );
              },
              child: const Text("Back to Menu"),
            ),
          ]),
        ],
      ),
    );
  }

  bool isGameOver = false;

  void gameOver() {
    if (isGameOver) return;

    isGameOver = true;
    pauseEngine();
    saveHighScore();
    FlameAudio.bgm.stop();

    showDialog(
      context: buildContext!,
      builder: (context) => AlertDialog(
        title: const Text("Game Over"),
        content: Text("Current Score: $score\nHigh Score: $highScore"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              resetGame();
            },
            child: const Text("Restart"),
          ),
        ],
      ),
    );
  }

  void resetGame() {
    man.position = Vector2(
      (size.x - man.size.x) / 2,
      size.y - man.size.y - 50,
    );
    man.velocity = 0;
    score = 0;
    children.whereType<Cloud>().forEach((cloud) => cloud.removeFromParent());
    children.whereType<Coin>().forEach((coin) => coin.removeFromParent());
    background.position = Vector2(0, 0);
    isGameOver = false;
    backgroundScrollingSpeed = 150;
    resumeEngine();
  }

  @override
  void update(double dt) {
    super.update(dt);

    backgroundScrollingSpeed += dt * 5;
  }
}
