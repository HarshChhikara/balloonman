import 'dart:async';
import 'dart:io';
import 'package:balloonman/components/audio_manager.dart';
import 'package:flutter/material.dart';
import 'package:flame/game.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../game.dart';

class MainMenu extends StatefulWidget {
  final BalloonMan game;
  final AudioManager audioManager;

  const MainMenu({required this.game, required this.audioManager, super.key});

  @override
  State<MainMenu> createState() => _MainMenuState();
}

class _MainMenuState extends State<MainMenu> {
  BannerAd? _bannerAd;
  bool _isBannerAdLoaded = false;
  int highScore = 0;

  @override
  void initState() {
    super.initState();
    widget.audioManager.play('final_start_sound.mp3');
    loadHighScore();
    _loadBannerAd();
  }

  void _loadBannerAd() {
    _bannerAd = BannerAd(
      adUnitId: "ca-app-pub-3482970658164433/2371729077",
      size: AdSize.banner,
      request: AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          setState(() {
            _isBannerAdLoaded = true;
          });
          Future.delayed(Duration(milliseconds: 200), () {
            setState(() {});
          });
        },
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
        },
      ),
    )..load();
  }

  Future<void> loadHighScore() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      highScore = prefs.getInt('highScore') ?? 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: Stack(
              children: [
                Positioned.fill(
                  child: Image.asset(
                    'assets/images/final_background_sprite.png',
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  bottom: 150,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: Text(
                      "High Score: $highScore",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        height: 150,
                        width: 180,
                        color: Color.fromARGB(255, 153, 216, 235),
                        child: Image.asset(
                          'assets/images/final_menu_man_sprite.png',
                          fit: BoxFit.fill,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        "Balloon Man",
                        style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          print("🎮 Navigating to GameScreen");
                          widget.game.removeFromParent();
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    GameWidget(game: BalloonMan())),
                          );
                        },
                        child: const Text("Start Game"),
                      ),
                      const SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: () => exit(0),
                        child: const Text("Exit"),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          if (_isBannerAdLoaded)
            Align(
              alignment: Alignment.bottomCenter,
              child: Visibility(
                visible: _isBannerAdLoaded,
                child: SizedBox(
                  width: _bannerAd!.size.width.toDouble(),
                  height: _bannerAd!.size.height.toDouble(),
                  child: AdWidget(ad: _bannerAd!),
                ),
              ),
            ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    super.dispose();
  }
}
