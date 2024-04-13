import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:toe_tack_tick/menu.dart';
import 'package:toe_tack_tick/setting.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await MobileAds.instance.initialize();
  loadads();
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  // Load the music settings
  MusicSettings musicSettings = MusicSettings();
  await musicSettings.loadMusicSetting();

  runApp(
    ChangeNotifierProvider.value(
      value: musicSettings,
      child: MyApp(),
    ),
  );
}

AppOpenAd? _appOpenAd;

loadads() {
  AppOpenAd.load(
    adUnitId: 'ca-app-pub-1123677122450039/5978927202',
    request: AdRequest(),
    adLoadCallback: AppOpenAdLoadCallback(
      onAdLoaded: (ad) {
        _appOpenAd = ad;
        _appOpenAd!.show();
      },
      onAdFailedToLoad: (error) {
        debugPrint("Error: $error");
      },
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Toe Tack Tick',
      theme: ThemeData(),
      darkTheme: ThemeData.dark(),
      themeMode: ThemeMode.system,
      home: MenuScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
