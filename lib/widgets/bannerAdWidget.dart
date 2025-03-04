import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class BannerAdWidget extends StatefulWidget {
  const BannerAdWidget({Key? key}) : super(key: key);

  @override
  State<BannerAdWidget> createState() => _BannerAdWidgetState();
}

class _BannerAdWidgetState extends State<BannerAdWidget> {
  BannerAd? _bannerAd;
  bool _isBannerAdLoaded = false;

  @override
  void initState() {
    super.initState();
    print("🚀 Initializing BannerAdWidget");
    _loadBannerAd();
  }

  Future<void> _loadBannerAd() async {
    print("⏳ Loading Banner Ad...");
    _bannerAd = BannerAd(
      adUnitId: "ca-app-pub-3940256099942544/9214589741",
      size: AdSize.banner,
      request: AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          print("✅ Banner Ad Loaded");
          setState(() {
            _isBannerAdLoaded = true;
          });
        },
        onAdFailedToLoad: (ad, error) {
          print("❌ Failed to load banner ad: $error");
          ad.dispose();
        },
      ),
    )..load();
  }

  @override
  void dispose() {
    print("♻️ Disposing BannerAdWidget");
    _bannerAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print("🏗️ Building BannerAdWidget");
    return _isBannerAdLoaded
        ? SizedBox(
            width: _bannerAd!.size.width.toDouble(),
            height: _bannerAd!.size.height.toDouble(),
            child: AdWidget(ad: _bannerAd!),
          )
        : const SizedBox(); // Show nothing if the ad is not loaded
  }
}
