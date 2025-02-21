import 'dart:math';
import 'package:balloonman/components/cloud.dart';
import 'package:flame/components.dart';
import '../game.dart';

class CloudManager extends Component with HasGameRef<BalloonMan> {
  double cloudSpawnTimer = 0;
  @override
  void update(double dt) {
    cloudSpawnTimer += dt;
    const double cloudInterval = 2;
    if (cloudSpawnTimer > cloudInterval) {
      cloudSpawnTimer = 0;
      spawnCloud();
    }
  }

  void spawnCloud() {
    final double screenWidth = gameRef.size.x;
    final double cloudGap = 200;
    const double minCloudWidth = 150;
    const double maxCloudWidth = 250;
    const double cloudHeight = 200;

    List<double> cloudPositions = [];

    double currentX = 0;
    while (currentX < screenWidth) {
      double cloudWidth = minCloudWidth +
          Random().nextDouble() * (maxCloudWidth - minCloudWidth);

      if (currentX + cloudWidth > screenWidth) {
        cloudWidth = screenWidth - currentX;
      }

      cloudPositions.add(currentX);

      currentX += cloudWidth + Random().nextDouble() * cloudGap;
    }

    if (cloudPositions.length > 1) {
      cloudPositions.removeAt(Random().nextInt(cloudPositions.length));
    }

    for (double cloudX in cloudPositions) {
      final cloud = Cloud(
        Vector2(cloudX, -cloudHeight),
        Vector2(
            minCloudWidth +
                Random().nextDouble() * (maxCloudWidth - minCloudWidth),
            cloudHeight),
        isCloud: true,
      );
      gameRef.add(cloud);
    }
  }
}
