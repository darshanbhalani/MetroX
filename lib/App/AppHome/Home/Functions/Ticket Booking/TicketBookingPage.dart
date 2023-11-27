import 'package:MetroX/App/AppHome/Home/Functions/Ticket%20Booking/TicketViewPage.dart';
import 'package:MetroX/App/const/color.dart';
import 'package:MetroX/App/const/data.dart';
import 'package:MetroX/App/const/wigets.dart';
import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:flutter/material.dart';
import 'package:random_password_generator/random_password_generator.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class TicketBookingPage extends StatefulWidget {
  const TicketBookingPage({super.key});

  @override
  State<TicketBookingPage> createState() => _TicketBookingPageState();
}

class _TicketBookingPageState extends State<TicketBookingPage> {
  final _controller1 = SingleValueDropDownController();
  final _controller2 = SingleValueDropDownController();
  final _controller3 = SingleValueDropDownController();
  final _formkey = GlobalKey<FormState>();
  String? qrData;
  int fare = 0;
  int totalFare = 0;
  bool flag = false;
  String bookingTime = "";
  String bookingDate = "";
  late Razorpay _razorpay;
  String bookingId = "";
  bool wallet = true;
  double? cureentBalance;
  double? tempWallet;
  String? tempRazorpay;
  String? tempPaymentMode;

  @override
  void initState() {
    fatchCurrntBalance();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    // _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
    super.initState();
  }

  @override
  void dispose() {
    _controller1.clearDropDown();
    _controller2.clearDropDown();
    _controller3.clearDropDown();
    _razorpay.clear();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    fatchCurrntBalance();
    super.didChangeDependencies();
  }

  fatchCurrntBalance() async {
    await fire
        .collection('users')
        .doc(auth.currentUser!.phoneNumber)
        .get()
        .then((value) {
      cureentBalance = double.parse(value["Balance"]);
    });
    setState(() {});
  }

  Future<void> _handlePaymentSuccess(PaymentSuccessResponse response) async {
    if (wallet) {
      await fire
          .collection('users')
          .doc(auth.currentUser!.phoneNumber)
          .update({'Balance': (0.0).toString()});
    }
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => TicketViewPage(
            city: selectedCity.toString(),
            phone: "${auth.currentUser!.phoneNumber}",
            qrData: qrData!,
            source: _controller2.dropDownValue!.value,
            destination: _controller3.dropDownValue!.value,
            bookingTime: bookingTime,
            bookingDate: bookingDate,
            numberOfTickets:
            _controller1.dropDownValue!.value.toString(),
            totalFare: totalFare.toString(),
            bookingId: bookingId,
            paymentId: ["WP$bookingId",tempWallet.toString(),response.paymentId.toString(),tempRazorpay.toString()],
            paymentMode: tempPaymentMode.toString(),
          ),
        ));
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    snackBar(context, Colors.red, "Payment Error");
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Ticket Booking"),
        backgroundColor: c1,
      ),
      body: Form(
        key: _formkey,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              dropField(
                  context, "Number of Tickets", Numbers, _controller1, true),
              dropField(
                  context, "Source", metroStationsList, _controller2, true),
              dropField(context, "Destination", metroStationsList, _controller3,
                  true),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("Fare of Single Ticket :- $fare"),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("Total Payable Amount :- $totalFare"),
              ),
              CheckboxListTile(
                title: Text("Use Wallet Balance ( ₹ ${cureentBalance ?? 0.0})"),
                value: wallet,
                onChanged: (newValue) {
                  setState(() {
                    wallet = !wallet;
                  });
                },
                controlAffinity:
                    ListTileControlAffinity.leading, //  <-- leading Checkbox
              )
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: GestureDetector(
        onTap: () async {
          if (_formkey.currentState!.validate()) {
            if (_controller2.dropDownValue!.value !=
                _controller3.dropDownValue!.value) {
              await calculateFare();
              loading(context);
              final RandomPasswordGenerator random = RandomPasswordGenerator();
              String randomId = random.randomPassword(
                passwordLength: 20,
                specialChar: false,
                letters: true,
                numbers: true,
                uppercase: true,
              );

              bookingTime =
                  "${DateTime.now().hour}:${DateTime.now().minute}:${DateTime.now().second}";
              bookingDate =
                  "${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}";
              bookingId =
                  "$randomId${auth.currentUser!.phoneNumber!.substring(3,7)}${DateTime.now().year}${DateTime.now().month}${DateTime.now().day}${auth.currentUser!.phoneNumber!.substring(8,12)}${DateTime.now().hour}${DateTime.now().minute}${DateTime.now().second}";

              qrData =
                  "$selectedCity-Metro::$bookingId::${_controller2.dropDownValue!.value}-${_controller3.dropDownValue!.value}::$bookingTime::$bookingDate::$fare";
              setState(() {});
              Navigator.pop(context);

              if(wallet && (cureentBalance!) >= totalFare) {
                await fire
                    .collection('users')
                    .doc(auth.currentUser!.phoneNumber)
                    .update(
                        {'Balance': (cureentBalance! - totalFare).toString()});
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TicketViewPage(
                          city: selectedCity.toString(),
                          phone: "${auth.currentUser!.phoneNumber}",
                          qrData: qrData!,
                          source: _controller2.dropDownValue!.value,
                          destination: _controller3.dropDownValue!.value,
                          bookingTime: bookingTime,
                          bookingDate: bookingDate,
                          numberOfTickets:
                              _controller1.dropDownValue!.value.toString(),
                          totalFare: totalFare.toString(),
                          bookingId: bookingId,
                        paymentId: ["WP$bookingId",totalFare.toString(),"","0"],
                        paymentMode: "Wallet",
                      ),
                    ));
              } else if(wallet && (cureentBalance!) > 0.0 ){
                tempWallet = cureentBalance!;
                tempRazorpay = (totalFare - cureentBalance!).toString();
                tempPaymentMode="Dual";
                await razorpayMethod(((totalFare - cureentBalance!) * 100).toString());
              }else {
                tempPaymentMode="Razorpay";
                tempWallet=0.0;
                tempRazorpay=(totalFare * 100).toString();
                await razorpayMethod(tempRazorpay.toString());
              }
            } else {
              snackBar(context, Colors.red, "Source and Destination both are Same !");
            }
          }
        },
        child: Container(
          height: 55,
          width: MediaQuery.of(context).size.width * 0.9,
          decoration:
              BoxDecoration(color: c1, borderRadius: BorderRadius.circular(20)),
          child: const Center(
              child: Text(
            "Next",
            style: TextStyle(color: Colors.white, fontSize: 22),
          )),
        ),
      ),
    );
  }

  calculateFare() async {
    int x = 0;
    int y = 0;
    if (_controller1.dropDownValue!.value != null &&
        _controller2.dropDownValue!.value != null &&
        _controller3.dropDownValue!.value != null) {
      if (_controller2.dropDownValue!.value !=
          _controller3.dropDownValue!.value) {
        loading(context);
        fatchCurrntBalance();

        final snapshot1 =
            await ref.ref("Fare/$selectedCity/locations").orderByKey().get();
        List<dynamic> values1 = snapshot1.value as List<dynamic>;
        List<Object> list1 = List<Object>.from(values1);
        final snapshot2 =
            await ref.ref("Fare/$selectedCity/distances").orderByKey().get();
        List<dynamic> values2 = snapshot2.value as List<dynamic>;
        List<Object> list2 = List<Object>.from(values2);
        fareMatrix.add(list1);
        for (var x in list2) {
          fareMatrix.add(x);
        }
        for (int i = 0; i < fareMatrix[0].length; i++) {
          if (fareMatrix[0][i] ==
              _controller2.dropDownValue!.value.toString()) {
            x = i;
            break;
          }
        }

        for (int i = 0; i < fareMatrix.length; i++) {
          if (fareMatrix[i][0] == _controller3.dropDownValue!.value) {
            y = i;
            break;
          }
        }
        fare = int.parse(fareMatrix[x][y]);
        totalFare = fare * (_controller1.dropDownValue!.value as int);
        setState(() {
          flag = true;
        });

        Navigator.pop(context);
      } else {
        fare = 0;
        totalFare = 0;
        setState(() {});
        snackBar(context, Colors.red, "Source and Destination both are Same !");
      }
    }
  }

  dropField(context, String lable, List<DropDownValueModel> items,
      SingleValueDropDownController controller, bool condition) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        DropDownTextField(
          onChanged: (value) async {
            await calculateFare();
          },
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please select an option';
            }
            return null;
          },
          isEnabled: condition,
          clearOption: false,
          controller: controller,
          dropDownItemCount: 5,
          dropDownList: items,
          dropdownRadius: 0,
          textFieldDecoration: InputDecoration(
            labelStyle: const TextStyle(color: Colors.black87),
            labelText: lable,
            disabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.grey,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                width: 2,
                color: c1,
              ),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderSide: BorderSide(
                width: 2,
                color: c1,
              ),
            ),
            errorBorder: const OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.grey,
              ),
            ),
            enabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey),
            ),
          ),
        ),
        const SizedBox(height: 15),
      ],
    );
  }

  razorpayMethod(String amount) {
    var options = {
      'key': 'rzp_test_864jf5OoKDSQuT',
      'amount': amount,
      'name': 'Metro Mate.',
      'currency': 'INR',
      'description': '$selectedCity Metro Ticket',
      'timeout': 120,
      'prefill': {
        'contact': '${auth.currentUser!.phoneNumber}',
        'email':
            '${auth.currentUser!.displayName?.split(" ")[0]}${auth.currentUser!.displayName?.split(" ")[1]}@gmail.com'
      },
    };

    _razorpay.open(options);
  }
}
