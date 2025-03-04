import 'dart:io';

class AdHelper {
  static String get bannerAdUnitId {
    if (Platform.isAndroid) {
      return 'ca-app-pub-3482970658164433/7702246686';
    } else {
      throw UnimplementedError('Exception');
    }
  }

  static String get rewardedAdUnitId {
    if (Platform.isAndroid) {
      return 'ca-app-pub-3482970658164433/2051131039';
    } else {
      throw UnimplementedError('Exception');
    }
  }
}
