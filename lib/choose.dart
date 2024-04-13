import 'package:flutter/material.dart';
import 'package:rive/rive.dart';
import 'package:flame_audio/flame_audio.dart';
import 'play.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class ChooseScreen extends StatefulWidget {
  @override
  State<ChooseScreen> createState() => _ChooseScreenState();
}

class _ChooseScreenState extends State<ChooseScreen> {
  bool isBannerLoaded = false;

  late BannerAd bannerAd;

  initializeBannerAd() async {
    bannerAd = BannerAd(
      adUnitId: 'ca-app-pub-1123677122450039/3863899755',
      size: AdSize.banner,
      request: AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          setState(() {
            isBannerLoaded = true;
          });
        },
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
          isBannerLoaded = false;
          print('Ad failed to load with error: $error');
        },
      ),
    );
    bannerAd.load();
  }

  @override
  void initState() {
    super.initState();
    initializeBannerAd();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       bottomNavigationBar: isBannerLoaded
          ? Container(
              height: 100,
              child: AdWidget(ad: bannerAd),
            )
          : null,
      body: Stack(
        fit: StackFit.expand,
        children: [
          RiveAnimation.asset(
            'assets/space.riv',
            fit: BoxFit.cover,
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildMarkButton(context, 'X'),
                SizedBox(height: 30),
                _buildMarkButton(context, 'O'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMarkButton(BuildContext context, String userMark) {
    return ElevatedButton(
      onPressed: () {
        _startGame(context, userMark);
        _playButtonClickSound();
      },
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.symmetric(horizontal: 60, vertical: 20),
        backgroundColor: Colors.blue,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(40),
        ),
        shadowColor: Colors.black.withOpacity(0.3),
        elevation: 5,
      ),
      child: Text(
        'Play as $userMark',
        style: TextStyle(
          fontFamily: 'Hello Graduation',
          fontSize: 28,
          color: Colors.white,
        ),
      ),
    );
  }

  void _startGame(BuildContext context, String userMark) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => PlayScreen(userMark: userMark),
      ),
    );
  }

  void _playButtonClickSound() {
    FlameAudio.play('button.mp3');
  }
}
