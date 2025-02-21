import 'dart:math';
import 'package:balloonman/components/cloud.dart';
import 'package:flame/components.dart';
import '../game.dart';
import 'coin.dart';

class CoinManager extends Component with HasGameRef<BalloonMan> {
  final Random random = Random();
  double spawnTimer = 0.0;
  final double spawnInterval = 0.8;

  @override
  void update(double dt) {
    spawnTimer += dt;
    if (spawnTimer >= spawnInterval) {
      spawnTimer = 0;
      spawnCoin();
    }
  }

  void spawnCoin() {
    final double coinSize = 30.0;
    double coinX = 0, coinY = -20;
    bool safePosition = false;
    int attempts = 0;

    while (!safePosition && attempts < 15) {
      attempts++;
      coinX = random.nextDouble() * (gameRef.size.x - coinSize);
      safePosition = true;

      for (var cloud in gameRef.children.whereType<Cloud>()) {
        double cloudX = cloud.position.x;
        double cloudY = cloud.position.y;
        double cloudWidth = cloud.size.x;
        double cloudHeight = cloud.size.y;

        bool isTooCloseX = (coinX - cloudX).abs() < (cloudWidth * 0.9);
        bool isTooCloseY = (coinY - cloudY).abs() < (cloudHeight * 0.9);

        if (isTooCloseX && isTooCloseY) {
          safePosition = false;
          break;
        }
      }
    }

    if (random.nextBool()) {
      coinX = gameRef.size.x - coinX;
    }

    bool isPurple = random.nextDouble() < 0.2;

    final coin =
        Coin(Vector2(coinX, coinY), Vector2.all(coinSize), isPurple: isPurple);
    gameRef.add(coin);
  }
}
