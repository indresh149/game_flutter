import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AboutPage extends StatefulWidget {
  @override
  State<AboutPage> createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  void _launchUrl(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri , mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch $uri';
    }
  }

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
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 80,
                backgroundImage: AssetImage('assets/indresh.jpg'),
              ),
              SizedBox(height: 16),
              Text(
                'Developed by',
                style: TextStyle(
                  fontSize: 24,
                  color: Colors.white70,
                  fontFamily: 'Hello Graduation',
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Indresh Goswami',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Hello Graduation',
                ),
              ),
              SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
            
              ),
              SizedBox(height: 24),
              Text(
                '\nSimple Tic Tac Toe game with Unbeatable AI\n',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 32,
                  fontFamily: 'Hello Graduation',
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 24),
              
              SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
               
              ),
            ],
          ),
        ),
      ),
    );
  }
}
