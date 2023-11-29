import 'dart:io';

import 'package:MetroX/App/AppHome/Bookings/BookingHistoryPage.dart';
import 'package:MetroX/App/AppHome/Home/Drawer/ChangeCityPage.dart';
import 'package:MetroX/App/AppHome/Home/Drawer/DrawerPage.dart';
import 'package:MetroX/App/AppHome/Home/Drawer/Wallet/WalletPage.dart';
import 'package:MetroX/App/AppHome/Profile/ProfilePage.dart';
import 'package:MetroX/App/const/classes.dart';
import 'package:MetroX/App/const/color.dart';
import 'package:MetroX/App/const/data.dart';
import 'package:MetroX/App/const/wigets.dart';
import 'package:flutter/material.dart';


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

bool flag=false;

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async{
        showDialog(context: context, builder: (context) => AlertDialog(
          title: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.exit_to_app),
              SizedBox(width: 5,),
              Text("Exit Application"),
            ],
          ),
          content: const Text("Sure you want to Exit App ?"),
          actions: [
            TextButton(
                onPressed: (){
                  pop(context);
                },
                child:Text("No",style:TextStyle(color: c1),)),
            TextButton(
                onPressed: () async {
                  flag=true;
                  setState(() {});
                  exit(0);
                },
                child:Text("Yes",style: TextStyle(color: c1),))
          ],
        ));
        return flag;
      },
      child: Scaffold(
        backgroundColor: c1,
        appBar: AppBar(
          title: const Text("MetroX"),
          backgroundColor: c1,
          centerTitle: true,
          elevation: 0,
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 10.0),
              child: GestureDetector(
                  onTap: () {
                    push(context, WalletPage());
                  },
                  child: const Icon(Icons.account_balance_wallet_outlined)),
            )
          ],
        ),
        drawer: const DrawerPage(),
        body: Stack(
          children: [
            Positioned(
              bottom: 0,
              child: Container(
                  height: 450,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: c6,
                    borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(40),
                      topLeft: Radius.circular(40),
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const SizedBox(height: 100,),
                      Center(
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          height: 220,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  i1(context),
                                  i2(context),
                                  i3(context),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  i4(context),
                                  i5(context),
                                  i6(context),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  )),
            ),
            Positioned(
              top: 0,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                height: 180,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 30,),
                    Text("Hi, ${auth.currentUser!.displayName?.split(" ")[0]}",style: const TextStyle(color: Colors.white,fontSize: 30,fontWeight: FontWeight.bold),),
                    const Text("Welcome to MetroX",style: TextStyle(color: Colors.white60,fontSize: 15),),
                    const Text("Your Metro Companion",style: TextStyle(color: Colors.white60,fontSize: 15),),
                    const SizedBox(height: 25,),
                    GestureDetector(
                      onTap: (){
                        push(context, ChangeCityPage(flag: true));
                      },
                      child: Container(
                        height:45,
                        width: MediaQuery.of(context).size.width*0.9,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                                color: Colors.white54
                            )
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.my_location,color: Colors.white,),
                            Text("  $selectedCity",style: const TextStyle(color: Colors.white,fontSize: 18,fontWeight: FontWeight.bold),)
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: Card(
          elevation: 5,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25.0),
          ),
          child: ClipRect(
            child: Container(
              height: 55,
              width: MediaQuery.of(context).size.width * 0.9,
              decoration:
                  BoxDecoration(color: c1, borderRadius: BorderRadius.circular(25)),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Container(
                    height: 22,
                    width: 22,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage("assets/Icons/n1.png")
                      )
                    ),
                  ),
                  GestureDetector(
                    onTap: (){
                      Navigator.push(
                          context,
                          CustomPageRoute(child: const BookingHistoryPage(), flag: false));
                    },
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      height: 22,
                      width: 22,
                      decoration: const BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage("assets/Icons/n2.png")
                          )
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: (){
                      Navigator.push(
                          context,
                          CustomPageRoute(child: const ProfilePage(), flag: true));
                    },
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      height: 22,
                      width: 22,
                      decoration: const BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage("assets/Icons/n3.png")
                          )
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

