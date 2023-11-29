import 'package:flutter/material.dart';
import 'package:MetroX/App/LogIn/LoginPage.dart';
import 'package:MetroX/App/const/color.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnBoardPage extends StatefulWidget {
  const OnBoardPage({super.key});

  @override
  State<OnBoardPage> createState() => _OnBoardPageState();
}

class _OnBoardPageState extends State<OnBoardPage> {
  PageController controller = PageController();
  int? page;

  bannerScreen(int number,String title,String text,String path){
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            top: 300,
            left: number.isOdd ? -300:null,
            right: number.isEven ? -300:null,
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
            left: number.isEven ? -200:null,
            right: number.isOdd ? -200:null,
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
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    height: MediaQuery.of(context).size.width,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage(path)
                        )
                    ),
                  ),
                  Text(title,style: TextStyle(fontSize: number==1 ? 50:35,fontWeight: FontWeight.bold,color: c1),),
                  Text(text,textAlign: TextAlign.center,)
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> get Screens => [
    bannerScreen(1, "Welcome", "Streamline your commute effortlessly with our MetroX.", "assets/OnBoardScreens/s1.png"),
    bannerScreen(2, "Easy to Use", "Effortless and intuitive, Our platform is designed with you in mind.", "assets/OnBoardScreens/s2.png"),
    bannerScreen(3, "Easy Payment", "Experience seamless transactions with our easy payment options.", "assets/OnBoardScreens/s3.png"),
    bannerScreen(4, "Data Security", "Your safety is our priority, We ensure a protected environment for your data and transactions, providing you with peace of mind.", "assets/OnBoardScreens/s4.png"),
    bannerScreen(5, "Generate Ticket", "Effortlessly generate Metro tickets from anywhere in our app, ensuring a quick and convenient way to book ticket with just a few taps.", "assets/OnBoardScreens/s5.png"),
    bannerScreen(6, "27x7 Support", "Our support is available around the clock, 24x7. Contact us anytime, and we'll be happy to assist you.", "assets/OnBoardScreens/s6.png"),
  ];

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Stack(
        children: [
        PageView(
        controller: controller,
        onPageChanged: (index){
          page=controller.page?.round()??0;
          setState(() {
          });
        },
        children: Screens
      ),
          Visibility(
            visible: !(page==Screens.length-1),
            child:  Align(
                alignment: const Alignment(1,-0.85),
                child: GestureDetector(
                  onTap: (){
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LoginPage(),
                        ));
                  },
                  child: const Padding(
                    padding: EdgeInsets.symmetric(vertical: 15.0,horizontal: 5),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text("Skip",style: TextStyle(fontSize: 16,color: Colors.black)),
                        Icon(Icons.keyboard_double_arrow_right),
                      ],
                    ),
                  ),
                )),
          ),
          Align(
            alignment: const Alignment(-1,0.97),
            child: GestureDetector(
                onTap: (){
                  controller.previousPage(
                      duration:const Duration(milliseconds: 400),
                      curve: Curves.easeInOut
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20.0,horizontal: 10),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      page==0 ? const Text(""):const Icon(Icons.chevron_left),
                      Text(
                        page==0 ? "":"Previous",
                        style: const TextStyle(fontSize: 16,color: Colors.black),),
                    ],
                  ),
                )
            ),
          ),
          Container(
              alignment: const Alignment(0,0.95),
              padding: const EdgeInsets.symmetric(vertical: 20.0,horizontal: 5),
              child: SmoothPageIndicator(
                controller: controller,
                count: Screens.length,
                effect: SlideEffect(
                  dotHeight: 10,
                  dotWidth: 10,
                  offset: 10,
                  radius: 10,
                  spacing: 5,
                  activeDotColor: c1,
                ),
              )
          ),
          Align(
            alignment: const Alignment(1,0.97),
            child: GestureDetector(
                onTap: (){
                  if(controller.page?.round()==Screens.length-1){
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LoginPage(),
                        ));
                  }else{
                    controller.nextPage(
                        duration:const Duration(milliseconds: 200),
                        curve: Curves.easeIn
                    );
                  }
                },
                child:  Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20.0,horizontal: 10),
                  child:
                  page==Screens.length-1 ?
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
                    decoration: BoxDecoration(
                        color: c1,
                        borderRadius: BorderRadius.circular(15)
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "Let's go",
                          style: const TextStyle(fontSize: 16,color: Colors.white),),
                        const Icon(Icons.chevron_right,color: Colors.white,),
                      ],
                    ),
                  ):
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "Next",
                        style: const TextStyle(fontSize: 16,color: Colors.black),),
                      const Icon(Icons.chevron_right),
                    ],
                  ),
                )
            ),
          ),
        ],
      ),
    );
  }
}


