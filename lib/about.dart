import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutPage extends StatelessWidget {
  void _launchUrl(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri , mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch $uri';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 80,
                backgroundImage: AssetImage('assets/images/haha.png'),
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
                'Anish Mishra',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Hello Graduation',
                ),
              ),
              SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: FaIcon(
                      FontAwesomeIcons.envelope,
                      size: 28,
                    ),
                    onPressed: () {
                      _launchUrl('mailto:920anish920@gmail.com');
                    },
                  ),
                  SizedBox(width: 16),
                  IconButton(
                    icon: FaIcon(
                      FontAwesomeIcons.link,
                      size: 28,
                    ),
                    onPressed: () {
                      _launchUrl('https://anishmishra.com.np');
                    },
                  ),
                  SizedBox(width: 16),
                  IconButton(
                    icon: FaIcon(
                      FontAwesomeIcons.twitter,
                      size: 28,
                    ),
                    onPressed: () {
                      _launchUrl('https://twitter.com/anish920920');
                    },
                  ),
                ],
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
              Text(
                'Connect with me:',
                style: TextStyle(
                  fontSize: 32,
                  // fontWeight: FontWeight.bold,
                  fontFamily: 'Hello Graduation',
                ),
              ),
              SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: FaIcon(
                      FontAwesomeIcons.github,
                      size: 36,
                    ),
                    onPressed: () {
                      _launchUrl('https://github.com/920anish');
                    },
                  ),
                  SizedBox(width: 16),
                  IconButton(
                    icon: FaIcon(
                      FontAwesomeIcons.linkedin,
                      size: 36,
                    ),
                    onPressed: () {
                      _launchUrl('https://linkedin.com/in/920anish920');
                    },
                  ),
                  SizedBox(width: 16),
                  IconButton(
                    icon: FaIcon(
                      FontAwesomeIcons.instagram,
                      size: 36,
                    ),
                    onPressed: () {
                      _launchUrl('https://instagram.com/920anish920');
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
