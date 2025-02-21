import 'package:balloonman/components/audio_manager.dart';
import 'package:flutter/material.dart';
import 'game.dart';
import 'screens/main_menu.dart';

void main() {
  final game = BalloonMan();
  runApp(MyApp(game: game));
}

class MyApp extends StatelessWidget {
  final BalloonMan game;
  const MyApp({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MainMenu(game: game, audioManager: AudioManager(), key: key),
    );
  }
}
