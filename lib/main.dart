import 'package:balloonman/api/firebase_api.dart';
import 'package:balloonman/components/audio_manager.dart';
import 'package:balloonman/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'game.dart';
import 'screens/main_menu.dart';

final navigatorKey = GlobalKey<NavigatorState>();
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await FirebaseApi().initNotifications();

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
      navigatorKey: navigatorKey,
      routes: {
        '/main_menu': (context) =>
            MainMenu(game: game, audioManager: AudioManager(), key: key),
      },
    );
  }
}
