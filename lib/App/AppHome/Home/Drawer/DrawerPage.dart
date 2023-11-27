import 'package:flutter/material.dart';
import 'package:MetroX/App/AppHome/Home/Drawer/ChangeCityPage.dart';
import 'package:MetroX/App/AppHome/Home/Drawer/FAQandSupportPage.dart';
import 'package:MetroX/App/AppHome/Home/Drawer/TermsofUsagePage.dart';
import 'package:MetroX/App/AppHome/Home/Drawer/Wallet/WalletPage.dart';
import 'package:MetroX/App/const/color.dart';
import 'package:MetroX/App/const/data.dart';
import 'package:MetroX/App/const/wigets.dart';
import 'package:rive/rive.dart';

class DrawerPage extends StatefulWidget {
  const DrawerPage({super.key});

  @override
  State<DrawerPage> createState() => _DrawerPageState();
}

class _DrawerPageState extends State<DrawerPage> {
  double cureentBalance = 0.0;

  @override
  void initState() {
    fatchCurrntBalance();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          DrawerHeader(
              margin: const EdgeInsets.all(0),
              padding: const EdgeInsets.all(0),
              child: Container(
                color: c1,
                child: const RiveAnimation.asset(
                  "assets/Animations/animation-4.riv",
                  fit: BoxFit.fill,
                ),
              )),
          GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const WalletPage(),
                  ));
            },
            child: ListTile(
              leading: const Icon(Icons.account_balance_wallet),
              title: const Text("My Wallet"),
              trailing: Text("₹ $cureentBalance"),
            ),
          ),
          box("Change City", Icons.pin_drop_outlined, const ChangeCityPage(flag: true)),
          box("Terms of Usage", Icons.article_outlined,
              const TermsofUsagePage()),
          box("FAQs & Support", Icons.info_outlined, const FAQandSupportPage()),
          GestureDetector(
            onTap: () {
              logOut(context);
            },
            child: const ListTile(
              leading: Icon(Icons.logout),
              title: Text("LogOut"),
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height / 3,
          ),
          const Text("v1.0.01")
        ],
      ),
    );
  }

  box(String titile, IconData icon, nextPage) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => nextPage,
            ));
      },
      child: ListTile(
        leading: Icon(icon),
        title: Text(titile),
      ),
    );
  }

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
}
