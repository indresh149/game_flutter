import 'package:flutter/material.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:provider/provider.dart';
import 'package:rive/rive.dart';
import 'package:toe_tack_tick/setting.dart';
import 'about.dart';
import 'choose.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class MenuScreen extends StatefulWidget {
  @override
  _MenuScreenState createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  late AnimationController titleAnimationController;
  late Animation<double> titleAnimation;
  bool _isRiveLoading = false;
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

  //Interestial Adds on clicking button

  bool isInterestialLoaded = false;
  late InterstitialAd interstitialAd;

  adloaded() async {
    InterstitialAd.load(
        adUnitId: 'ca-app-pub-1123677122450039/9431603974',
        request: AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(
          onAdLoaded: (ad) {
            setState(() {
              interstitialAd = ad;
              isInterestialLoaded = true;
            });
          },
          onAdFailedToLoad: (error) {
            print('Interstitial failed to load: $error');
            interstitialAd.dispose();
            isInterestialLoaded = false;
          },
        ));
  }

  //rewarded add

  RewardedAd? rewardedAd;
  int rewardscore = 0;

  
   
  loadrewardads() {
    RewardedAd.load(
        adUnitId: 'ca-app-pub-1123677122450039/4985409738',
        request: AdRequest(),
        rewardedAdLoadCallback: RewardedAdLoadCallback(
          onAdLoaded: (ad) {
            setState(() {
              rewardedAd = ad;
            });
          },
          onAdFailedToLoad: (error) {
            setState(() {
              rewardedAd = null;
            });
          },
        ));
  }

  void showAds() {
    if(rewardedAd != null){
      rewardedAd!.fullScreenContentCallback = FullScreenContentCallback(
        onAdDismissedFullScreenContent: (ad){
          setState(() {
            rewardedAd!.dispose();
            loadrewardads();
          });
        },

        onAdFailedToShowFullScreenContent: (ad, error){
          setState(() {
            rewardedAd!.dispose();
            loadrewardads();
          });
        },
      );
      rewardedAd!.show(onUserEarnedReward: (ad, reward){
        setState(() {
          rewardscore++;
        });
      });
      
    }
  }

  //Native add
  // bool isNativeLoaded = false;
  // late NativeAd nativeAd;

// void initializeNativeAd() async {
//   WidgetsFlutterBinding.ensureInitialized(); // Ensure Flutter is initialized

//   MobileAds.instance.initialize(); // Initialize MobileAds

//   nativeAd = NativeAd(
//     adUnitId: 'ca-app-pub-3940256099942544/2247696110', 
//     listener: NativeAdListener(
//       onAdLoaded: (ad) {
//         setState(() {
//           isNativeLoaded = true;
//         });
//       },
//       onAdFailedToLoad: (ad, error) {
//         setState(() {
//           isNativeLoaded = false;
//           nativeAd?.dispose();
//           print(error);
//         });
//       }
//     ),
//     request: const AdManagerAdRequest(),
//   );

//   nativeAd.load();
// }

  @override
  void initState() {
    super.initState();
    initializeBannerAd();
    adloaded();
    loadrewardads();
  
    WidgetsBinding.instance.addObserver(this);
    setupAnimation();

    final musicSettings = Provider.of<MusicSettings>(context, listen: false);

    if (musicSettings.isMusicOn) {
      _playBackgroundMusic();
    }
  }

  void setupAnimation() {
    titleAnimationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1),
    )..repeat(reverse: true);

    titleAnimation = Tween<double>(begin: 0, end: 20).animate(
      CurvedAnimation(
        parent: titleAnimationController,
        curve: Curves.easeInOut,
      ),
    );
  }

  void _playBackgroundMusic() {
    final musicSettings = Provider.of<MusicSettings>(context, listen: false);

    if (musicSettings.isMusicOn) {
      try {
        FlameAudio.bgm.play('background.mp3', volume: 1.0);
      } catch (e) {
        print('Error loading and playing background music: $e');
      }
    } else {
      FlameAudio.bgm.stop();
    }
  }

  @override
  void dispose() {
    titleAnimationController.dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final musicSettings = Provider.of<MusicSettings>(context, listen: false);

    if (state == AppLifecycleState.paused || !musicSettings.isMusicOn) {
      FlameAudio.bgm.pause();
    } else if (state == AppLifecycleState.resumed && musicSettings.isMusicOn) {
      FlameAudio.bgm.resume();
    }
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (isInterestialLoaded) {
            interstitialAd.show();
          }
        },
        child: Icon(Icons.add),
      ),
      body: Stack(
        children: [
          if (!_isRiveLoading)
            RiveAnimation.asset(
              'assets/riv.riv',
              fit: BoxFit.cover,
              alignment: Alignment.center,
              antialiasing: true,
            ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // SizedBox(
                //   height: 20,
                //   child: AdWidget(ad: nativeAd),
                // ),
                SizedBox(height: 20),
                AnimatedTextKit(
                  animatedTexts: [
                    TyperAnimatedText(
                      'Toe Tack Tick!',
                      textStyle: TextStyle(
                        fontFamily: 'Hello Graduation',
                        fontSize: 60,
                        color: Colors.white,
                      ),
                      speed: Duration(milliseconds: 200),
                    ),
                  ],
                ),
                SizedBox(height: 50),
                CustomButton(
                  onPressed: () {
                    FlameAudio.play('button.mp3');
                    Navigator.push(context,
                        MaterialPageRoute(builder: (_) => ChooseScreen()));
                  },
                  label: 'Play',
                ),
                SizedBox(height: 20),
                CustomButton(
                  onPressed: () {
                    FlameAudio.play('button.mp3');
                    Navigator.push(context,
                        MaterialPageRoute(builder: (_) => SettingsScreen()));
                  },
                  label: 'Settings',
                ),
                SizedBox(height: 20),
                CustomButton(
                  onPressed: () {
                    FlameAudio.play('button.mp3');
                    Navigator.push(context,
                        MaterialPageRoute(builder: (_) => AboutPage()));
                  },
                  label: 'About',
                ),
                Text('rewarded score: $rewardscore'),
                ElevatedButton(
                  onPressed: showAds, child: Text('Show Ads'))
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class CustomButton extends StatefulWidget {
  final VoidCallback onPressed;
  final String label;

  const CustomButton({
    Key? key,
    required this.onPressed,
    required this.label,
  }) : super(key: key);

  @override
  _CustomButtonState createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton> {
  bool isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => isPressed = true),
      onTapUp: (_) => setState(() => isPressed = false),
      onTapCancel: () => setState(() => isPressed = false),
      onTap: widget.onPressed,
      child: AnimatedContainer(
        duration: Duration(milliseconds: 100),
        width: 200,
        height: 60,
        decoration: BoxDecoration(
          color: isPressed ? Colors.green : Colors.blue,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 5,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Center(
          child: Text(
            widget.label,
            style: TextStyle(
              fontFamily: 'Hello Graduation',
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
