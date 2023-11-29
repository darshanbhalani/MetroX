import 'dart:convert';
import 'package:MetroX/App/AppHome/Home/Functions/Find%20Route/FindRoutePage.dart';
import 'package:MetroX/App/AppHome/Home/Functions/Metro%20Line%20Map/MetroLineMapPage.dart';
import 'package:MetroX/App/AppHome/Home/Functions/Nearest%20Station/NearestStationPage.dart';
import 'package:MetroX/App/AppHome/Home/Functions/Recharge%20Metro%20card/RechargeMetroCardPage.dart';
import 'package:MetroX/App/AppHome/Home/Functions/Station%20List/StationListPage.dart';
import 'package:MetroX/App/AppHome/Home/Functions/Ticket%20Booking/TicketBookingPage.dart';
import 'package:MetroX/App/WelcomeBanners/OnBoardPage.dart';
import 'package:MetroX/App/const/color.dart';
import 'package:MetroX/App/const/data.dart';
import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:random_password_generator/random_password_generator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

showField(String lable, String value) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(lable,
          style: TextStyle(
            color: c1,
            fontSize: 15,
          )),
      const SizedBox(
        height: 5,
      ),
      SizedBox(
        height: 45,
        child: TextFormField(
          enabled: false,
          decoration: InputDecoration(
            border: const OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.teal,
                )),
            labelText: value,
            labelStyle:
            const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            hintStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
          ),
        ),
      ),
      const SizedBox(
        height: 20,
      ),
    ],
  );
}

i1(context){
  return GestureDetector(
    onTap: () {
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const TicketBookingPage(),
          ));
    },
    child: Container(
      height: MediaQuery.of(context).size.width / 4.2,
      width: MediaQuery.of(context).size.width / 4.2,
      decoration: BoxDecoration(
        color: c2,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: MediaQuery.of(context).size.width / 10,
            width: MediaQuery.of(context).size.width / 10,
            decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("assets/Icons/i1.png")
                )
            ),
          ),
          const Text("Ticket",style: TextStyle(fontSize: 12),),
          const Text("Booking",style: TextStyle(fontSize: 12),)
        ],
      ),
    ),
  );
}

i2(context){
  return GestureDetector(
    onTap: () {
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const FindRoutePage(),
          ));
    },
    child: Container(
      height: MediaQuery.of(context).size.width / 4.2,
      width: MediaQuery.of(context).size.width / 4.2,
      decoration: BoxDecoration(
        color: c2,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: MediaQuery.of(context).size.width / 10,
            width: MediaQuery.of(context).size.width / 10,
            decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("assets/Icons/i2.png")
                )
            ),
          ),
          const Text("Find",style: TextStyle(fontSize: 12),),
          const Text("Route",style: TextStyle(fontSize: 12),)
        ],
      ),
    ),
  );
}

i3(context){
  return GestureDetector(
    onTap: () {
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const NearestStationPage(),
          ));
    },
    child: Container(
      height: MediaQuery.of(context).size.width / 4.2,
      width: MediaQuery.of(context).size.width / 4.2,
      decoration: BoxDecoration(
        color: c2,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: MediaQuery.of(context).size.width / 10,
            width: MediaQuery.of(context).size.width / 10,
            decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("assets/Icons/i3.png")
                )
            ),
          ),
          const Text("Nearest",style: TextStyle(fontSize: 12),),
          const Text("Station",style: TextStyle(fontSize: 12),)
        ],
      ),
    ),
  );
}

i4(context){
  return GestureDetector(
    onTap: () {
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const MetroLineMapPage(),
          ));
    },
    child: Container(
      height: MediaQuery.of(context).size.width / 4.2,
      width: MediaQuery.of(context).size.width / 4.2,
      decoration: BoxDecoration(
        color: c2,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: MediaQuery.of(context).size.width / 10,
            width: MediaQuery.of(context).size.width / 10,
            decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("assets/Icons/i4.png")
                )
            ),
          ),
          const Text("Metro",style: TextStyle(fontSize: 12),),
          const Text("Line Map",style: TextStyle(fontSize: 12),)
        ],
      ),
    ),
  );
}

i5(context){
  return GestureDetector(
    onTap: () {
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const RechargeMetroCardPage(),
          ));
    },
    child: Container(
      height: MediaQuery.of(context).size.width / 4.2,
      width: MediaQuery.of(context).size.width / 4.2,
      decoration: BoxDecoration(
        color: c2,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: MediaQuery.of(context).size.width / 10,
            width: MediaQuery.of(context).size.width / 10,
            decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("assets/Icons/i5.png")
                )
            ),
          ),
          const Text("Recharge",style: TextStyle(fontSize: 12),),
          const Text("Metro Card",style: TextStyle(fontSize: 12),)
        ],
      ),
    ),
  );
}

i6(context){
  return GestureDetector(
    onTap: () {
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const StationListpage(),
          ));
    },
    child: Container(
      height: MediaQuery.of(context).size.width / 4.2,
      width: MediaQuery.of(context).size.width / 4.2,
      decoration: BoxDecoration(
        color: c2,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: MediaQuery.of(context).size.width / 10,
            width: MediaQuery.of(context).size.width / 10,
            decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("assets/Icons/i6.png")
                )
            ),
          ),
          const Text("Station",style: TextStyle(fontSize: 12),),
          const Text("List",style: TextStyle(fontSize: 12),)
        ],
      ),
    ),
  );
}

formField(context, String lable, TextEditingController controller,
    bool condition) {
  return Column(
    children: [
      SizedBox(
        height: 50,
        child: TextFormField(
          cursorColor: Colors.black,
          controller: controller,
          enabled: condition,
          keyboardType:
          lable == "Phone No." ? TextInputType.number : TextInputType.text,
          validator: (value) {
            if (lable == "Phone No." && controller.text.length != 10) {
              return "Please Enter Valid $lable";
            } else if (lable == "OTP" && controller.text.length != 6) {
              return "Please Enter Valid $lable";
            }
            else if (controller.text.isEmpty) {
              return "Please Enter $lable";
            }
            return null;
          },
          decoration: InputDecoration(
            disabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey),
            ),
            border: const OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.teal,
                )),
            focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: c1,
                  width: 2,
                )),
            focusedErrorBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: c1,
                  width: 2,
                )),
            enabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey),
            ),
            labelText: lable,
            labelStyle: const TextStyle(fontSize: 16, color: Colors.black),
          ),
          inputFormatters: lable == "Phone No."
              ? [
            LengthLimitingTextInputFormatter(10),
            FilteringTextInputFormatter.digitsOnly,
          ]
              :
              lable == "OTP"
              ? [
              LengthLimitingTextInputFormatter(6),
              FilteringTextInputFormatter.digitsOnly,
              ]:[
              ]
          ,
        ),
      ),
      const SizedBox(height: 15),
    ],
  );
}


snackBar(context,Color color,String msg){
  final snackbar = SnackBar(
    content: Text(msg),
    duration: Duration(seconds: 2),
    backgroundColor: color,
  );
  ScaffoldMessenger.of(context).hideCurrentSnackBar();
  ScaffoldMessenger.of(context).showSnackBar(snackbar);
}


loading(context) {
  return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return (
            Center(
              child: SizedBox(
                  height: 40,
                  width: 40,
                  child:  CircularProgressIndicator(color: c1)
            )
        ));
      });
}

Future setLocalDetails(city) async {
  SharedPreferences sp = await SharedPreferences.getInstance();
  sp.setString("selectedCity", city);
  String metroStationsListJSON = json.encode(metroStationsList);
  sp.setString('metroStationsListJSON', metroStationsListJSON);
  final dataJson1 = jsonEncode(metroData);
  sp.setString('metroData', dataJson1);
}

Future getLocalDetails() async {
  SharedPreferences sp = await SharedPreferences.getInstance();
  selectedCity = sp.getString("selectedCity") ?? selectedCity;
  String? jsonList = sp.getString('metroStationsListJSON');
  metroStationsList = json
      .decode(jsonList!)
      .map<DropDownValueModel>((item) => DropDownValueModel.fromJson(item))
      .toList();
  stationList = metroStationsList.map((item) => item.value).toList();
  final dataJson = sp.getString('metroData');
  final dataX = jsonDecode(dataJson!);
  metroData = List<List<Object>>.from(dataX.map((list) => List<Object>.from(list)));
}

Future buildDataBase(String city) async {
  selectedCity=city;
  metroStationsList = [];
  metroGraph = {};
  stationList = [];
  fareMatrix = [];
  stationLineColor = {};
  metroData = [];
  List list = [];

  final snapshot = await ref.ref("Cities/$city").orderByKey().get();
  Map<dynamic, dynamic> values = snapshot.value as Map;
  values.forEach((key, value) {
    list.add(value);
  });
  for (int i = 0; i < list.length; i++) {
    Map temp = list[i];
    List temp1 = [];
    temp1.add(int.parse(temp["No"]));
    temp1.add(temp["Name"]);
    temp1.add(temp["X"]);
    temp1.add(temp["Y"]);
    temp1.add(temp["Line"]);
    temp1.add(temp["Terminal"]);
    metroData.add(temp1);
  }
  for (int i = 0; i < metroData.length; i++) {
    metroData.sort((a, b) => a[1].compareTo(b[1]));
  }
  for (int i = 0; i < metroData.length; i++) {
    metroStationsList
        .add(DropDownValueModel(name: metroData[i][1], value: metroData[i][1]));
  }
  await setLocalDetails(city);
}

logOut(context) {
  return showDialog(context: context, builder: (context) => AlertDialog(
    title: const Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.logout),
        SizedBox(width: 5,),
        Text("Sign Out"),
      ],
    ),
    content: const Text("sure you want to Sign Out ?"),
    actions: [
      TextButton(
          onPressed: (){
            pop(context);
          },
          child:Text("No",style:TextStyle(color: c1),)),
      TextButton(
          onPressed: () async {
            loading(context);
            // cardList=[];
            selectedCity=null;
            metroStationsList = [];
            metroGraph = {};
            stationList=[];
            fareMatrix=[];
            stationLineColor= {};
            await auth.signOut();
            Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>const OnBoardPage()), (route) => false);
          },
          child:Text("Yes",style: TextStyle(color: c1),))
    ],
  ));
}

openGoogleMap(context,String destination) async {
  final Uri url = Uri.parse('https://www.google.com/maps/dir/?api=1&destination=${destination.replaceAll(" ", "_")} metro Station');
  if (!await launchUrl(url)) {
        throw Exception('Could not launch $url');
   }
}

push(context,Widget function){
  Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => function,
      ));
}

pop(context){
  Navigator.of(context).pop();
}

String bookingIdGenerator(){
  final RandomPasswordGenerator random = RandomPasswordGenerator();
  String randomString = random.randomPassword(
    passwordLength: 20,
    specialChar: false,
    letters: true,
    numbers: true,
    uppercase: true,
  );
  return randomString;
}

String time(){
  return "${DateTime.now().hour}:${DateTime.now().minute}:${DateTime.now().second}";
}

String date(){
  return "${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}";
}