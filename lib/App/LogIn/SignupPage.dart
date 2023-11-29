import 'package:flutter/material.dart';
import 'package:MetroX/App/AppHome/Home/Drawer/ChangeCityPage.dart';
import 'package:MetroX/App/const/color.dart';
import 'package:MetroX/App/const/data.dart';
import 'package:MetroX/App/const/wigets.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final TextEditingController controller1 = TextEditingController();
  final TextEditingController controller2 = TextEditingController();
  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  bool flag = false;

  @override
  void dispose() {
    controller1.dispose();
    controller2.dispose();
    super.dispose();
  }

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
            top: 550,
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
                                image: AssetImage("assets/Other/SignUp.png"))),
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
                        key: _key,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            formField(context, "First Name", controller1, true),
                            formField(context, "Last Name", controller2, true),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Checkbox(
                                  value: flag,
                                  onChanged: (value) {
                                    flag = !flag;
                                    setState(() {});
                                  },
                                ),
                                const Text(
                                    'I agree to the terms and conditions'),
                              ],
                            )
                          ],
                        )),
                    const Text(
                      "Note : Your details can't be change in future so be careful to provide right details.",
                      textAlign: TextAlign.center,
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
            if (_key.currentState!.validate() && flag) {
              loading(context);
              await auth.currentUser!
                  .updateDisplayName(
                      "${controller1.text.trim().toUpperCase()} ${controller2.text.trim().toUpperCase()}")
                  .whenComplete(() async {
                await fire
                    .collection("users")
                    .doc(auth.currentUser?.phoneNumber.toString())
                    .set({
                  "First Name": controller1.text.trim().toUpperCase(),
                  "Last Name": controller2.text.trim().toUpperCase(),
                  "Phone No": auth.currentUser?.phoneNumber.toString(),
                  "Balance": "0.0",
                  "Transaction":[]
                }).whenComplete(() {
                  pop(context);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ChangeCityPage(flag: false,),
                      ));
                });
              });
            } else if (!flag) {
              return snackBar(
                  context, Colors.red, "Please agree Terms & Conditions");
            }
          },
          label: Container(
            height: 55,
            width: MediaQuery.of(context).size.width * 0.9,
            decoration: BoxDecoration(
                color: c1, borderRadius: BorderRadius.circular(20)),
            child: const Center(
                child: Text(
              "Next",
              style: TextStyle(color: Colors.white, fontSize: 22),
            )),
          ),
        ),
      ),
    );
  }
}
