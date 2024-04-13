import 'package:flutter/material.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class MusicSettings extends ChangeNotifier {
  bool _isMusicOn = true;

  bool get isMusicOn => _isMusicOn;

  Future<void> loadMusicSetting() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _isMusicOn = prefs.getBool('isMusicOn') ?? true;
    notifyListeners();
    if (_isMusicOn) {
      FlameAudio.bgm.resume();
    } else {
      FlameAudio.bgm.pause();
    }
  }

  void toggleMusic(BuildContext context, bool value) async {
    _isMusicOn = value;
    notifyListeners();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('isMusicOn', _isMusicOn);
    if (_isMusicOn) {
      FlameAudio.bgm.play('background.mp3', volume: 1.0);
    } else {
      FlameAudio.bgm.pause();
    }
  }
}
class SettingsScreen extends StatefulWidget {
  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
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
      backgroundColor: Colors.blueGrey,
      appBar: AppBar(
        elevation: 0, // Remove the shadow
        backgroundColor: Colors.transparent,
        title: Text(
          'Settings',
          style: TextStyle(
            fontFamily: 'Hello Graduation',
            fontSize: 36,
            color: Colors.white,
            fontWeight: FontWeight.bold
          ),
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20),
            _buildSettingItem(
              title: 'Music',
              description: 'Turn on or off',
              value: context.watch<MusicSettings>().isMusicOn,
              onChanged: (value) => _toggleMusic(context, value),
            ),
            // Add more settings here
          ],
        ),
      ),
    );
  }

  void _toggleMusic(BuildContext context, bool value) {
    FlameAudio.play('button.mp3');
    context.read<MusicSettings>().toggleMusic(context, value);
  }

  Widget _buildSettingItem({
    required String title,
    required String description,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 28,
            fontFamily: 'Hello Graduation',
            color: Colors.white,
          ),
        ),
        SizedBox(height: 10),
        Text(
          description,
          style: TextStyle(
            fontSize: 26,
            fontFamily: 'Hello Graduation',
            color: Colors.white,
          ),
        ),
        SizedBox(height: 20),
        Row(
          children: [
            Text(
              'Background Music',
              style: TextStyle(
                fontSize: 28,
                fontFamily: 'Hello Graduation',
                color: Colors.white,
              ),
            ),
            Spacer(),
            Switch(
              value: value,
              onChanged: onChanged,
              activeColor: Colors.blue,
              inactiveThumbColor: Colors.white,
              inactiveTrackColor: Colors.grey[400],
            ),
          ],
        ),
        Divider(height: 20, color: Colors.grey),
      ],
    );
  }
}