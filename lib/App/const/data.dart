import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';


FirebaseAuth auth = FirebaseAuth.instance;
FirebaseFirestore fire = FirebaseFirestore.instance;
FirebaseDatabase ref = FirebaseDatabase.instance;

String? selectedCity;
List stationList = [];
List metroData = [];
List<DropDownValueModel> metroStationsList = [];
Map<String, Set<String>> metroGraph = {};
Map<String, Color> stationLineColor = {};
List fareMatrix = [];


List<DropDownValueModel> Numbers = [
  const DropDownValueModel(name: "1", value: 1),
  const DropDownValueModel(name: "2", value: 2),
  const DropDownValueModel(name: "3", value: 3),
  const DropDownValueModel(name: "4", value: 4),
  const DropDownValueModel(name: "5", value: 5),
  const DropDownValueModel(name: "6", value: 6),
];

Map<String, double> StationPosition = {
  'AhmedabadX': 23.0375565601606,
  'AhmedabadY': 72.56700922564633,
  'NagpurX': 21.1412657,
  'NagpurY': 79.0816802
};

Map<String, Color> lineColor = {
  "Red": Colors.red,
  "Blue": Colors.blue,
  "Pink": Colors.pink,
  "Black": Colors.black,
  "White": Colors.white,
  "Green": Colors.green,
  "Aqua": Colors.lightBlueAccent,
  "Purple": Colors.purple,
  "Yellow": Colors.yellow,
  "Orange": Colors.orange
};

List Cities = [
  "Ahmedabad",
  "Agra",
  "Bengaluru",
  "Bhopal",
  "Chennai",
  "Delhi",
  "Hyderabad",
  "Jaipur",
  "Kanpur",
  "Kochi",
  "Kolkata",
  "Lucknow",
  "Mumbai",
  "Nagpur",
  "Noida",
  "Pune"
];

List FAQ = [
  [
    "I haven't received an OTP to log in/Sign up. What should I do ?",
    "By default, the MetroX app will recognize the OTP once you receive it. In case this doesn’t happen, then you can check your SMS inbox. If you still haven’t received it, then write to us at support@metromate.in"
  ],
  [
    "Why do I need to log in?",
    "Logging in to the MetroX app allows us to give you a personalised and seamless commute experience. You can save your select your city and add money to your wallet."
  ],
  [
    "What are the different ways to log in?",
    "There are only ways to log in to MetroX using your mobile number and an OTP."
  ],
  [
    "Why is the app asking to access my location?",
    "Since MetroX is a commuting app, accessing your location is important for us to provide the best service to you. It allows us to find metro stations near you"
  ],
  [
    "How can I cancel ticket and refund amount?",
    "Currently it is not possible to cancel your booked ticket and get refund."
  ],
  [
    "MetroX is not available in my city. How can I vote for my city?",
    "MetroX is available for all cities which have active metro rail service but some time due to any issue MetroX temporary unavailable for specific city."
  ],
  [
    "What do I do if the app shows an internet connectivity issue?",
    "Check the internet connectivity on your phone, or switch off your wifi/mobile data and restart it after a couple of minutes. You can also try closing and restarting MetroX app."
  ],
  [
    "How can I change my city on the MetroX app?",
    "It is very easy to change city. Follow step Open Drawer(Menu/Three Line) and you will get option like change/select city."
  ],
  [
    "Can I use the app offline?",
    "No, It is not possible to run app offline nut you can able to download ticket offline in gallery."
  ],
];