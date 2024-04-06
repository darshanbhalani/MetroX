import 'dart:async';

import 'package:flutter/material.dart';
import 'package:MetroX/App/AppHome/Home/Drawer/ChangeCityPage.dart';
import 'package:MetroX/App/AppHome/HomePage.dart';
import 'package:MetroX/App/WelcomeBanners/OnBoardPage.dart';
import 'package:MetroX/App/const/color.dart';
import 'package:MetroX/App/const/data.dart';
import 'package:MetroX/App/const/wigets.dart';


class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  AnimationController? _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );
    _animationController!.forward();
    Timer(const Duration(seconds: 3), () {
    });
    _animationController!.addStatusListener((status) async {
      if (status == AnimationStatus.completed) {
        if(auth.currentUser == null){
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) => const OnBoardPage(),
            ),
          );
        }else{
          await getLocalDetails();
          if(Cities.contains(selectedCity)){
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const HomePage(),
                ));
          }else{
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const ChangeCityPage(flag: false),
                ));
          }

        }

      }
    });
  }

  @override
  void dispose() {
    _animationController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController!,
      builder: (BuildContext context, Widget? child) {
        return  FadeTransition(
          opacity: _animationController!,
          child: child,
        );
      },
      child: const YourSplashScreenContent(), // Replace with your own splash screen content
    );
  }
}

class YourSplashScreenContent extends StatelessWidget {
  const YourSplashScreenContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: c1,
      body: Padding(
        padding: const EdgeInsets.only(top: 50),
        child: Center(
          child: SizedBox(
              height: MediaQuery.of(context).size.height * 0.6,
              width: MediaQuery.of(context).size.width * 0.6,
              child: Image.asset('assets/Other/A3.png')),
        ),
      ),
      bottomNavigationBar: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
              height: MediaQuery.of(context).size.height * 0.3,
              width: MediaQuery.of(context).size.width * 0.3,
              child: Image.asset('assets/Other/A4.png')),
        ],
      ),

    );
  }
}
