import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:MetroX/App/AppHome/Home/Drawer/Wallet/ShowAllTransactionHistory.dart';
import 'package:MetroX/App/AppHome/Home/Drawer/Wallet/ShowWalletTransactionHistory.dart';
import 'package:MetroX/App/const/color.dart';
import 'package:MetroX/App/const/data.dart';
import 'package:MetroX/App/const/wigets.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class WalletPage extends StatefulWidget {
  const WalletPage({Key? key}) : super(key: key);

  @override
  State<WalletPage> createState() => _WalletPageState();
}

class _WalletPageState extends State<WalletPage> {
  late Razorpay _razorpay;
  double? balance;
  String tempController = "0.0";

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
    if (balance == null) {
      balance = double.parse(tempController);
    } else {
      balance = balance! + double.parse(tempController);
    }
    await fire
        .collection('users')
        .doc(auth.currentUser!.phoneNumber.toString())
        .update({
      'Balance': (cureentBalance! + double.parse(tempController)).toString(),
      "Transaction": FieldValue.arrayUnion([response.paymentId.toString()])
    });
    await fire
        .collection("transactions")
        .doc(response.paymentId.toString())
        .set({
      "Id": response.paymentId.toString(),
      "Time": "${DateTime.now().hour}:${DateTime.now().minute}:${DateTime.now().second}",
      "Date": "${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}",
      "Method": "Razorpay",
      "Mode": "Wallet-Payment",
      "Amount": tempController.toString(),
      "Phone No":auth.currentUser!.phoneNumber,
      "Status":"Credited",
      "TimeStamp":Timestamp.now()
    });
    fatchCurrntBalance();
    snackBar(
        context, Colors.green, "Amount Successfully added into your wallet");
    tempController = "0.0";
    setState(() {});
  }

  void _handlePaymentError(PaymentFailureResponse response) {}

  Future<void> _handleExternalWallet(ExternalWalletResponse response) async {}

  double? cureentBalance;

  fatchCurrntBalance() {
    fire
        .collection('users')
        .doc(auth.currentUser!.phoneNumber.toString())
        .get()
        .then((value) {
      cureentBalance = double.parse(value["Balance"]);
    }).whenComplete(() async {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: c1,
        title: const Text("My Wallet"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Column(
            children: [
              Column(
                children: [
                  const Text(
                    "Total Balance",
                    style: TextStyle(fontWeight: FontWeight.w400, fontSize: 20),
                  ),
                  Text("₹ ${cureentBalance ?? 0.0}",
                      style: const TextStyle(
                          fontWeight: FontWeight.w900, fontSize: 20)),
                  const SizedBox(
                    height: 25,
                  ),
                  GestureDetector(
                    onTap: () async {
                      addCash();
                      // temp();
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6),
                        color: c1,
                      ),
                      child: const Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                        child: Text(
                          "Add Cash",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      "Note : Our high-speed wallet feature in the metro ticket booking app ensures lightning-fast transactions. Easily preload funds for instant ticket purchases, allowing commuters to skip the lines and board the metro with a simple tap, making urban travel faster and more convenient than ever.",
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ShowAllTransactionHistory(),
                          ));
                    },
                    child: ListTile(
                      tileColor: c2,
                      title: const Text("Show All Transaction History"),
                      trailing: const Icon(Icons.chevron_right),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ShowWalletTransactionHistory(),
                          ));
                    },
                    child: ListTile(
                      tileColor: c2,
                      title: const Text("Show Wallet Payments History"),
                      trailing: const Icon(Icons.chevron_right),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  addCash() {
    TextEditingController controller = TextEditingController();
    final formkey = GlobalKey<FormState>();
    return showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (context) {
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
                  const Text(
                    "Note : Once you add money in your wallet it can't be revice.",
                    textAlign: TextAlign.center,
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
                            Navigator.pop(context);
                            setState(() {});
                            fatchCurrntBalance();
                            await razorpayMethod(controller);
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
            ),
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

  razorpayMethod(controller) {
    var options = {
      'key': 'rzp_test_864jf5OoKDSQuT',
      'amount': (double.parse(controller.text) * 100)
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
        TextFormField(
          cursorColor: Colors.black,
          controller: controller,
          obscureText: flag,
          enabled: condition,
          keyboardType: TextInputType.number,
          validator: (value) {
            if (value == null || value.isEmpty || value == "0.0") {
              return 'Please Enter Amount';
            }else if(double.parse(value)<1){
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
        const SizedBox(height: 15),
      ],
    );
  }
}
