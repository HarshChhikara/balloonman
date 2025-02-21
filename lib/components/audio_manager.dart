import 'package:balloonman/game.dart';
import 'package:flame/components.dart';
import 'package:flame_audio/flame_audio.dart';

class AudioManager extends Component with HasGameRef<BalloonMan> {
  AudioManager();
  initialize() async {
    await FlameAudio.audioCache.loadAll([
      'coin_collecting_sound_effect.wav',
      'final_background_sound.mp3',
      'final_start_sound.mp3',
    ]);
    FlameAudio.bgm.initialize();
  }

  bool audioOn = true;

  void play(String audioFile) {
    if (audioOn) FlameAudio.play(audioFile);
  }

  void toggleSound() {
    audioOn = !audioOn;

    switch (audioOn) {
      case true:
        playBgmMusic();
      case false:
        FlameAudio.bgm.stop();
    }
  }

  void playBgmMusic() {
    FlameAudio.bgm.play('final_background_sound.mp3');
  }
}
