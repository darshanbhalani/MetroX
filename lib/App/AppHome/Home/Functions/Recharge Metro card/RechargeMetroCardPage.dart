import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:MetroX/App/const/color.dart';
import 'package:MetroX/App/const/data.dart';
import 'package:MetroX/App/const/wigets.dart';
import 'package:random_password_generator/random_password_generator.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:u_credit_card/u_credit_card.dart';

class RechargeMetroCardPage extends StatefulWidget {
  const RechargeMetroCardPage({super.key});

  @override
  State<RechargeMetroCardPage> createState() => _RechargeMetroCardPageState();
}

class _RechargeMetroCardPageState extends State<RechargeMetroCardPage> {

  late Razorpay _razorpay;
  double? balance;
  String tempController = "0.0";
  double? currentBalance;
  String? tempCardNo;
  double? currentWalletBalance;
  double? tempWallet;
  String? tempRazorpay;
  String? tempPaymentMode;

  @override
  void initState() {
    fatchCurrntBalance();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
    super.initState();
  }

  @override
  void dispose() {
    _razorpay.clear();
    super.dispose();
  }

  Future<void> _handlePaymentSuccess(PaymentSuccessResponse response) async {
    if(tempPaymentMode=="Dual"){
      await fire
          .collection('users')
          .doc(auth.currentUser!.phoneNumber)
          .update(
          {'Balance': "0.0"});
    }
    await fire.collection("cards").doc(tempCardNo.toString()).get().then((value) => currentBalance=double.parse(value["Balance"]));
    await fire
        .collection('cards')
        .doc(tempCardNo.toString())
        .update({
      'Balance': (currentBalance! + double.parse(tempController)).toString(),
    });
    await fire
        .collection("transactions")
        .doc(response.paymentId.toString())
        .set({
      "Id": response.paymentId.toString(),
      "Time": "${DateTime.now().hour}:${DateTime.now().minute}:${DateTime.now().second}",
      "Date": "${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}",
      "Method": "Razorpay",
      "Mode": "Metro-Card-Recharge",
      "Amount": tempRazorpay.toString(),
      "Phone No":auth.currentUser!.phoneNumber,
      "Status":"Credited",
      "TimeStamp":Timestamp.now()
    });
    if(tempPaymentMode=="Dual"){
      final RandomPasswordGenerator random = RandomPasswordGenerator();
      String randomId = random.randomPassword(
        passwordLength: 20,
        specialChar: false,
        letters: true,
        numbers: true,
        uppercase: true,
      );
      String bookingTime =
          "${DateTime.now().hour}:${DateTime.now().minute}:${DateTime.now().second}";
      String bookingDate =
          "${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}";
      String bookingId =
          "$randomId${auth.currentUser!.phoneNumber!.substring(3,7)}${DateTime.now().year}${DateTime.now().month}${DateTime.now().day}${auth.currentUser!.phoneNumber!.substring(8,12)}${DateTime.now().hour}${DateTime.now().minute}${DateTime.now().second}";
      await fire
          .collection("transactions")
          .doc("WP$bookingId")
          .set({
        "Id": "WP$bookingId",
        "Time": bookingTime,
        "Date": bookingDate,
        "Method": "Wallet",
        "Mode": "Metro-Card-Recharge",
        "Amount": tempWallet.toString(),
        "Phone No":auth.currentUser!.phoneNumber,
        "Status":"Debited",
        "TimeStamp":Timestamp.now()
      });
      await fire
          .collection("transactions")
          .doc("WCP$bookingId")
          .set({
        "Id": "WCP$bookingId",
        "Time": bookingTime,
        "Date": bookingDate,
        "Method": "Wallet",
        "Mode": "Metro-Card-Recharge",
        "Amount": tempWallet.toString(),
        "Phone No":auth.currentUser!.phoneNumber,
        "Status":"Credited",
        "TimeStamp":Timestamp.now()
      });
    }
    tempController = "0.0";
    tempCardNo=null;
    tempPaymentMode=null;
    tempRazorpay=null;
    tempWallet=null;
    currentBalance=null;
    Navigator.pop(context);
    snackBar(
        context, Colors.green, "Amount Successfully added into your Metro Card");
    setState(() {});
  }

  void _handlePaymentError(PaymentFailureResponse response) {}

  Future<void> _handleExternalWallet(ExternalWalletResponse response) async {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Recharge Metro Card"),
        backgroundColor: c1,
        // actions: [
        //   IconButton(
        //       onPressed: () async {
        //         await fire.collection("cards").doc("4444-4444-4444-4444").set({
        //           "Card No":"4444-4444-4444-4444",
        //           "Phone No":"+917777909916",
        //           "Holder Name":"Mr. BHALANI",
        //           "Issue Date":"27/08/2023",
        //           "Expiry Date":"27/08/2025",
        //           "Balance":"0.0",
        //           "Type":"Senior Citizen",
        //           "Metro":"Ahmedabad"
        //         }).whenComplete((){
        //           snackBar(context, Colors.green, "Card Added");
        //         });
        //       },
        //       icon: Icon(Icons.add)
        //   )
        // ],
      ),
      body: StreamBuilder(
        stream: fire
            .collection("cards").where("Phone No",isEqualTo: auth.currentUser!.phoneNumber.toString())
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return ListView(
            children: snapshot.data!.docs.map((snap) {
              return  Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: GestureDetector(
                  onTap: () async {
                    loading(context);
                    await fatchCurrntBalance();
                    Navigator.pop(context);
                    addCash(context,snap["Card No"],snap["Holder Name"]);
                  },
                  child: Center(
                    child: Stack(
                      children: [
                        CreditCardUi(
                          scale: 1.15,
                          cardHolderFullName: snap["Holder Name"],
                          cardNumber:"",
                          validFrom: "${snap["Issue Date"].toString().split("/")[1]}/${snap["Issue Date"].toString().split("/")[2].substring(2,4)}",
                          validThru: "${snap["Expiry Date"].toString().split("/")[1]}/${snap["Expiry Date"].toString().split("/")[2].substring(2,4)}",
                          topLeftColor: snap["Type"]=="Normal" ? Colors.black87 : snap["Type"]=="Women" ? Colors.purple : snap["Type"]=="Student" ? Colors.blue :snap["Type"]=="Senior Citizen" ? Colors.teal :snap["Type"]=="Army" ? Colors.brown :Colors.grey,
                          doesSupportNfc: true,
                          cardProviderLogo: Text("${snap["Metro"]} Metro",textAlign: TextAlign.right,style: const TextStyle(fontSize:22,color: Colors.white,letterSpacing: 1,fontFamily: 'Courier New',fontWeight: FontWeight.bold),),
                          cardProviderLogoPosition: CardProviderLogoPosition.left,
                          cardType: CardType.other,
                        ),
                        Positioned(
                            top: 60,
                            right: 10,
                            child: Text("₹ ${snap["Balance"]}",style: const TextStyle(fontSize:25,color: Colors.amberAccent),)
                        ),
                        Positioned(
                            top: 105,
                            child: Text(snap["Card No"],style: const TextStyle(fontSize:25,color: Colors.white,fontFamily: 'Courier New',fontWeight: FontWeight.bold),)
                        ),
                        Positioned(
                            bottom: 5,
                            right: 5,
                            child: Text(snap["Type"],style: const TextStyle(fontSize:10,color: Colors.white38),)
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }

  addCash(context,String cardNo,String name) {
    TextEditingController controller = TextEditingController();
    bool wallet=true;
    final formkey = GlobalKey<FormState>();
    return showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setState /*You can rename this!*/){
                return Padding(
                  padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    child: Column(
                      // mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          "Add Amount",
                          style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 10,),
                        RichText(
                          text: TextSpan(
                            children: <TextSpan>[
                              const TextSpan(
                                text: 'Card No. : ',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.black87,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              TextSpan(
                                text: cardNo,
                                style: const TextStyle(
                                  fontSize: 18,
                                  color: Colors.grey, // Adjust color for lighter effect
                                ),
                              ),
                            ],
                          ),
                        ),
                        RichText(
                          text: TextSpan(
                            children: <TextSpan>[
                              const TextSpan(
                                text: 'Holder Name : ',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.black87,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              TextSpan(
                                text: name,
                                style: const TextStyle(
                                  fontSize: 18,
                                  color: Colors.grey, // Adjust color for lighter effect
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Form(
                          key: formkey,
                          child:
                          tFormField(context, "Amount", controller, true, false),
                        ),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              priceBox("50", controller),
                              priceBox("100", controller),
                              priceBox("150", controller),
                              priceBox("200", controller),
                              priceBox("250", controller),
                              priceBox("500", controller),
                              priceBox("600", controller),
                              priceBox("800", controller),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        // const Text("Maximum Wallet Capacity is ₹ 1000.",textAlign: TextAlign.center),
                        CheckboxListTile(
                          title: Text("Use Wallet Balance ( ₹ ${currentWalletBalance ?? 0.0})"),
                          value: wallet,
                          onChanged: (newValue) {
                            setState(() {
                              wallet = !wallet;
                            });
                          },
                          controlAffinity:
                          ListTileControlAffinity.leading, //  <-- leading Checkbox
                        ),
                        Container(
                          alignment: Alignment.center,
                          color: Colors.transparent,
                          width: MediaQuery.of(context).size.width,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 12),
                            child: GestureDetector(
                              onTap: () async {
                                if (formkey.currentState!.validate()) {
                                  // Navigator.pop(context);
                                  // setState(() {});
                                  // await razorpayMethod(controller);
                                  loading(context);
                                  tempCardNo=cardNo;
                                  if(wallet && (currentWalletBalance!) >= double.parse(controller.text)) {
                                    await fire
                                        .collection('users')
                                        .doc(auth.currentUser!.phoneNumber)
                                        .update(
                                        {'Balance': (currentWalletBalance! - double.parse(controller.text)).toString()});
                                    final RandomPasswordGenerator random = RandomPasswordGenerator();
                                    String randomId = random.randomPassword(
                                      passwordLength: 20,
                                      specialChar: false,
                                      letters: true,
                                      numbers: true,
                                      uppercase: true,
                                    );
                                    String bookingTime =
                                        "${DateTime.now().hour}:${DateTime.now().minute}:${DateTime.now().second}";
                                    String bookingDate =
                                        "${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}";
                                    String bookingId =
                                        "$randomId${auth.currentUser!.phoneNumber!.substring(3,7)}${DateTime.now().year}${DateTime.now().month}${DateTime.now().day}${auth.currentUser!.phoneNumber!.substring(8,12)}${DateTime.now().hour}${DateTime.now().minute}${DateTime.now().second}";
                                    await fire
                                        .collection("transactions")
                                        .doc("WP$bookingId")
                                        .set({
                                      "Id": "WP$bookingId",
                                      "Time": bookingTime,
                                      "Date": bookingDate,
                                      "Method": "Wallet",
                                      "Mode": "Metro-Card-Recharge",
                                      "Amount": controller.text.toString(),
                                      "Phone No":auth.currentUser!.phoneNumber,
                                      "Status":"Debited",
                                      "TimeStamp":Timestamp.now()
                                    });
                                    await fire
                                        .collection("transactions")
                                        .doc("WCP$bookingId")
                                        .set({
                                      "Id": "WCP$bookingId",
                                      "Time": bookingTime,
                                      "Date": bookingDate,
                                      "Method": "Wallet",
                                      "Mode": "Metro-Card-Recharge",
                                      "Amount": controller.text.toString(),
                                      "Phone No":auth.currentUser!.phoneNumber,
                                      "Status":"Credited",
                                      "TimeStamp":Timestamp.now()
                                    });
                                    await fire.collection("cards").doc(tempCardNo.toString()).get().then((value) => currentBalance=double.parse(value["Balance"]));
                                    await fire
                                        .collection('cards')
                                        .doc(tempCardNo.toString())
                                        .update({
                                      'Balance': (currentBalance! + double.parse(tempController)).toString(),
                                    });
                                    tempController = "0.0";
                                    tempCardNo=null;
                                    tempPaymentMode=null;
                                    tempRazorpay=null;
                                    tempWallet=null;
                                    currentBalance=null;
                                    Navigator.pop(context);
                                    Navigator.pop(context);
                                    snackBar(
                                        context, Colors.green, "Amount Successfully added into your Metro Card");
                                  } else if(wallet && (currentWalletBalance!) > 0.0 ){
                                    tempWallet = currentWalletBalance!;
                                    tempRazorpay = (double.parse(controller.text) - currentWalletBalance!).toString();
                                    tempPaymentMode="Dual";
                                    Navigator.pop(context);
                                    print("VVVVVVVVVVVVVVVVVVVVVVVVV");
                                    print(double.parse(controller.text) - currentWalletBalance!);
                                    print((double.parse(controller.text) - currentWalletBalance!).runtimeType);
                                    await razorpayMethod((double.parse(controller.text) - currentWalletBalance!).toString());
                                  }else {
                                    tempPaymentMode="Razorpay";
                                    tempWallet=0.0;
                                    tempRazorpay=(double.parse(controller.text) * 100).toString();
                                    await razorpayMethod(tempRazorpay.toString());
                                  }
                                }
                              },
                              child: Container(
                                height: 50,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color: c1,
                                ),
                                child: const Center(
                                    child: Text(
                                      "Add",
                                      style: TextStyle(fontSize: 20, color: Colors.white),
                                    )),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                );
              }
          );
        });
  }

  priceBox(lable, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: GestureDetector(
        onTap: () {
          controller.text = double.parse(lable).toString();
          tempController = controller.text.toString();
          setState(() {});
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6),
            color: c2,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: Text(
              "₹ $lable",
              style: TextStyle(color: c1),
            ),
          ),
        ),
      ),
    );
  }

  razorpayMethod(String controller) {
    var options = {
      'key': 'rzp_test_864jf5OoKDSQuT',
      'amount': (double.parse(controller) * 100)
          .toString(), //in the smallest currency sub-unit.
      'name': 'Metro Mate.',
      'currency': 'INR',
      'description': 'Add Money in Wallet',
      'timeout': 120, // in seconds
      'prefill': {
        'contact': auth.currentUser!.phoneNumber.toString(),
        'email':
        '${auth.currentUser!.displayName!.split(" ")[0]}${auth.currentUser!.displayName!.split(" ")[1]}@gmail.com'
      },
      "config": {
        "display": {
          "hide": [
            {"method": 'paylater'}
          ]
        }
      },
      "method": {
        "netbanking": "0",
        "card": "1",
        "upi": "1",
        "wallet": "0",
        "paylater": "0"
      }
    };
    _razorpay.open(options);
  }

  tFormField(context, String lable, TextEditingController controller,
      bool condition, bool flag) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: 50,
          child: TextFormField(
            cursorColor: Colors.black,
            controller: controller,
            obscureText: flag,
            enabled: condition,
            keyboardType: TextInputType.number,
            validator: (value) {
              if (value == null || value.isEmpty || value == "0.0") {
                return 'Please Enter Amount';
              }
              else if(double.parse(value)<1){
                return 'Minimum limit is ₹ 1';
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
            inputFormatters: [
              LengthLimitingTextInputFormatter(3),
              FilteringTextInputFormatter.digitsOnly,
            ],
            onChanged: (value) {
              tempController = controller.text.toString();
              setState(() {});
            },
          ),
        ),
        const SizedBox(height: 15),
      ],
    );
  }

  fatchCurrntBalance() async {
    await fire
        .collection('users')
        .doc(auth.currentUser!.phoneNumber)
        .get()
        .then((value) {
      currentWalletBalance = double.parse(value["Balance"]);
    });
    setState(() {});
  }
}
