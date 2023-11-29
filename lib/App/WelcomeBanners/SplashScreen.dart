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
      duration: const Duration(seconds: 2),
    );
    _animationController!.forward();
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
        return Scaffold(
          body: Center(
            child: FadeTransition(
              opacity: _animationController!,
              child: child,
            ),
          ),
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
    return Center(
      child: Stack(
        children: [
          Positioned(
            top: 200,
            right: 200,
            child: Container(
              height: 600,
              width: 600,
              decoration: BoxDecoration(
                  color: c2,
                  shape: BoxShape.circle
              ),
            ),
          ),
          Positioned(
            top: -200,
            right: -200,
            child: Container(
              height: 400,
              width: 400,
              decoration: BoxDecoration(
                  color: c2,
                  shape: BoxShape.circle
              ),
            ),
          ),
          Positioned(
            bottom: -250,
            right: -250,
            child: Container(
              height: 400,
              width: 400,
              decoration: BoxDecoration(
                  color: c2,
                  shape: BoxShape.circle
              ),
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                    height: MediaQuery.of(context).size.height * 0.6,
                    width: MediaQuery.of(context).size.width * 0.6,
                    child: Image.asset('assets/Other/App-Icon-Name.png')),
                const Text("Your Instant Pass to Smooth Metro Rides!",textAlign:TextAlign.center,style: TextStyle(color: Colors.grey,fontSize: 15),),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
