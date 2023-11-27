import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:MetroX/App/AppHome/Home/Drawer/ChangeCityPage.dart';
import 'package:MetroX/App/LogIn/SignupPage.dart';
import 'package:MetroX/App/const/color.dart';
import 'package:MetroX/App/const/data.dart';
import 'package:MetroX/App/const/wigets.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController controller1 = TextEditingController();
  final TextEditingController controller2 = TextEditingController();
  final GlobalKey<FormState> _key1 = GlobalKey<FormState>();
  final GlobalKey<FormState> _key2 = GlobalKey<FormState>();
  bool flag = false;
  String varId = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            top: 200,
            right: 200,
            child: Container(
              height: 600,
              width: 600,
              decoration: BoxDecoration(color: c2, shape: BoxShape.circle),
            ),
          ),
          Positioned(
            top: -200,
            right: -200,
            child: Container(
              height: 400,
              width: 400,
              decoration: BoxDecoration(color: c2, shape: BoxShape.circle),
            ),
          ),
          Positioned(
            bottom: -150,
            right: -150,
            child: Container(
              height: 300,
              width: 300,
              decoration: BoxDecoration(color: c2, shape: BoxShape.circle),
            ),
          ),
          Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(
                      child: Container(
                        height: 250,
                        width: 250,
                        decoration: const BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage("assets/Other/LogIn.png"))),
                      ),
                    ),
                    Text("Phone Varification",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: c1,
                            fontSize: 28)),
                    const SizedBox(
                      height: 5,
                    ),
                    const Text(
                      "We need to varify your phone before getting started !",
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    Form(
                      key: _key1,
                      child: formField(context, "Phone No.", controller1, !flag),
                    ),
                    Visibility(
                      visible: flag,
                      child: Form(
                          key: _key2,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              formField(context, "OTP", controller2, true),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  GestureDetector(
                                    child: const Text("Resend OTP"),
                                    onTap: () async {
                                      loading(context);
                                      await sendOTP(context, "+91${controller1.text}");
                                      controller2.clear();
                                    },
                                  )
                                ],
                              )
                            ],
                          )),
                    ),
                    const SizedBox(
                      height: 80,
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20),
        child: FloatingActionButton.extended(
          elevation: 0,
          focusElevation: 0,
          hoverElevation: 0,
          highlightElevation: 0,
          disabledElevation: 0,
          onPressed: () async {
            if (_key1.currentState!.validate() &&
                controller1.text.length == 10) {
              loading(context);
              try {
                if(flag && _key1.currentState!.validate()){
                  await verifyOTP(context, varId, controller2.text, "+91${controller1.text}");
                }
                else{
                  await sendOTP(context, "+91${controller1.text}");
                }
              } on FirebaseException catch (e){
                Navigator.pop(context);
                snackBar(context,  Colors.red,e.code);
              }
            }
          },
          label: Container(
            height: 55,
            width: MediaQuery.of(context).size.width * 0.9,
            decoration: BoxDecoration(
                color: c1, borderRadius: BorderRadius.circular(20)),
            child: Center(
                child: Text(
              flag ? "Verify OTP" : "Next",
              style: const TextStyle(color: Colors.white, fontSize: 20),
            )),
          ),
        ),
      ),
    );
  }

  sendOTP(context, String pnone) async {
    try {
      await auth.verifyPhoneNumber(
            phoneNumber: pnone,
            codeSent: (String verificationId, int? resendToken) async {
              varId = verificationId;
              flag = true;
              Navigator.pop(context);
              snackBar(context,  Colors.green,"OTP sended");
              setState(() {});
            },
            verificationCompleted: (PhoneAuthCredential phoneAuthCredential) {},
            timeout: const Duration(minutes: 1),
            codeAutoRetrievalTimeout: (String verificationId) {},
            verificationFailed: (FirebaseAuthException error) {
              Navigator.pop(context);
              snackBar(context, Colors.red,error.message.toString());
            },
          );
    } on FirebaseException catch (e) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(e.message.toString()),
      ));
    }
  }

  verifyOTP(context, verificationId, String code, String phone) async {
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
          verificationId: verificationId, smsCode: code);
      UserCredential userCredential =
          await auth.signInWithCredential(credential);
      if (userCredential.user != null) {
        var snapShot = await fire.collection("users").doc(phone).get();
        Navigator.pop(context);
        if (snapShot.exists) {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const ChangeCityPage(flag: false),
              ));
        } else {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const SignupPage(),
              ));
        }
      } else {
        Navigator.pop(context);
        snackBar(context,  Colors.red,"Oops! Somthing went wrong please try again later");
      }
    } on FirebaseException catch (e) {
      Navigator.pop(context);
      if (e.code == "invalid-verification-code") {
        snackBar(context,  Colors.red,"Oops! Wrong OTP");
      } else if (e.code == "session-expired") {
        snackBar(context,  Colors.red,"Oops! OTP timed out please resend OTP");
      } else {
        snackBar(context,  Colors.red,"${e.message}");
      }
    }
  }
}
