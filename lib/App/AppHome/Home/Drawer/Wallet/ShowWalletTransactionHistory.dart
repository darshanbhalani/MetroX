import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:MetroX/App/const/color.dart';

class ShowWalletTransactionHistory extends StatefulWidget {
  const ShowWalletTransactionHistory({super.key});

  @override
  State<ShowWalletTransactionHistory> createState() => _ShowWalletTransactionHistoryState();
}

class _ShowWalletTransactionHistoryState extends State<ShowWalletTransactionHistory> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: c1,
        title: const Text("Show Wallet Payments History"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0),
        child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection("transactions").where("Method", isEqualTo: "Wallet").orderBy("TimeStamp",descending: true)
              .snapshots(),
          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            return ListView(
              children: snapshot.data!.docs.map((snap) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ListTile(
                      tileColor: c2,
                      title: Text(snap["Mode"]),
                      subtitle: Text("${snap["Date"]} : ${snap["Time"]}"),
                      trailing: Text(snap["Status"]=="Credited" ?
                      "+${snap["Amount"]}" :
                      "-${snap["Amount"]}",
                        style: TextStyle(color: snap["Status"]=="Credited" ? Colors.green:Colors.red,
                          fontSize: 20,

                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    )
                  ],
                );
              }).toList(),
            );
          },
        ),
      ),
    );
  }
}
