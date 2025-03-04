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
import 'package:google_mobile_ads/google_mobile_ads.dart';
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

  RewardedAd? _rewardedAd;
  bool _isRewardedAdLoaded = false;

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

    await _loadRewardedAd();
  }

  int _savedScore = 0;
  void _saveScore() {
    _savedScore = score;
  }

  void _restoreScore() {
    score = _savedScore;
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

  Future<void> _loadRewardedAd() async {
    await RewardedAd.load(
      adUnitId: "ca-app-pub-3482970658164433/2051131039",
      request: AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          _rewardedAd = ad;
          _isRewardedAdLoaded = true;
        },
        onAdFailedToLoad: (error) {
          _isRewardedAdLoaded = false;
        },
      ),
    );
  }

  void _showRewardedAd() {
    if (_isRewardedAdLoaded) {
      _rewardedAd?.fullScreenContentCallback = FullScreenContentCallback(
        onAdDismissedFullScreenContent: (ad) {
          ad.dispose();
          _loadRewardedAd();
        },
        onAdFailedToShowFullScreenContent: (ad, error) {
          ad.dispose();
          _loadRewardedAd();
        },
      );

      _rewardedAd?.show(
        onUserEarnedReward: (ad, reward) {
          resumeGameAfterAd();
        },
      );
    }
  }

  void resumeGameAfterAd() {
    _restoreScore();
    resetGame(keepScore: true);
    isGameOver = false;
    resumeEngine();
  }

  @override
  void onRemove() {
    _rewardedAd?.dispose();
    super.onRemove();
  }

  void showPauseMenu() {
    showDialog(
      context: buildContext!,
      barrierDismissible: false,
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
  Vector2? lastPlayerPosition;

  void gameOver() {
    if (isGameOver) return;

    isGameOver = true;
    _saveScore();
    pauseEngine();
    saveHighScore();
    FlameAudio.bgm.stop();

    showDialog(
      context: buildContext!,
      barrierDismissible: false,
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
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _showRewardedAd();
            },
            child: const Text("Watch Ad to Continue"),
          ),
        ],
      ),
    );
  }

  void resetGame({bool keepScore = false}) {
    man.position = Vector2(
      (size.x - man.size.x) / 2,
      size.y - man.size.y - 50,
    );
    man.velocity = 0;
    if (!keepScore) {
      score = 0;
    }
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
