import 'dart:async';
import 'dart:io';
import 'package:balloonman/components/audio_manager.dart';
import 'package:flutter/material.dart';
import 'package:flame/game.dart';
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
  int highScore = 0;

  @override
  void initState() {
    super.initState();
    widget.audioManager.play('final_start_sound.mp3');
    loadHighScore();
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
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/final_background_sprite.png',
              fit: BoxFit.cover,
            ),
          ),
          Positioned(
            bottom: 150,
            right: 0,
            left: 0,
            child: Center(
              child: Text(
                "High Score: $highScore",
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  shadows: [
                    Shadow(
                      blurRadius: 3,
                      color: Colors.black,
                      offset: Offset(2, 2),
                    ),
                  ],
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
                Positioned(
                  top: 100,
                  right: 0,
                  left: 0,
                  child: Center(
                    child: Text(
                      "Balloon Man",
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        shadows: [
                          Shadow(
                            blurRadius: 3,
                            color: Colors.black,
                            offset: Offset(2, 2),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    widget.game.removeFromParent();
                    final newGame = BalloonMan();
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => GameWidget(game: newGame),
                      ),
                    );
                  },
                  child: const Text("Start Game"),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    exit(0);
                  },
                  child: const Text("Exit"),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
