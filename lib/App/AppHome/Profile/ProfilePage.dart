import 'package:flutter/material.dart';
import 'package:MetroX/App/const/color.dart';
import 'package:MetroX/App/const/data.dart';
import 'package:MetroX/App/const/wigets.dart';
import 'package:rive/rive.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {

  @override
  void initState() {

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
        backgroundColor: c1,
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            const SizedBox(
              height: 250,
              width: 250,
              child: RiveAnimation.asset("assets/Animations/animation-3.riv"),
            ),
            Card(
              elevation: 4,
              child: ListTile(
                tileColor: c2,
                title: const Text("First Name"),
                subtitle:  Text("${auth.currentUser!.displayName?.split(" ")[0]}"),
              ),
            ),
            const SizedBox(height: 10,),
            Card(
              elevation: 4,
              child: ListTile(
                tileColor: c2,
                title: const Text("Last Name"),
                subtitle: Text("${auth.currentUser!.displayName?.split(" ")[1]}"),
              ),
            ),
            const SizedBox(height: 10,),
            Card(
              elevation: 4,
              child: ListTile(
                tileColor: c2,
                title: const Text("Phone Number"),
                subtitle: Text("${auth.currentUser!.phoneNumber}"),
              ),
            ),
            const SizedBox(height: 20,),
            GestureDetector(
              onTap: (){
                logOut(context);
              },
              child: Container(
                height: 50,
                width: 120,
                decoration: BoxDecoration(
                  color: c1,
                  borderRadius: BorderRadius.circular(12)
                ),
                child:const Center(child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.logout,color: Colors.white,),
                    Text("  LogOut",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
                  ],
                )),
              ),
            )
          ],
        ),
      ),
    );
  }
}
