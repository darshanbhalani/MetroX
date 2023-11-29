import 'package:MetroX/App/const/classes.dart';
import 'package:MetroX/App/const/data.dart';
import 'package:MetroX/App/const/wigets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CustomPageRoute extends PageRouteBuilder {
  final Widget child;
  final bool flag;

  CustomPageRoute({
    required this.child,
    required this.flag,
  }) : super(
          transitionDuration: const Duration(milliseconds: 300),
          pageBuilder: (context, animation, secondaryAnimation) => child,
        );

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
          Animation<double> secondaryAnimation, Widget child) =>
      SlideTransition(
        position: Tween<Offset>(
          begin: flag ? const Offset(1, 0) : const Offset(0, 1),
          end: Offset.zero,
        ).animate(animation),
        child: child,
      );
}

enum paymentMethod { Wallet, Razorpay, Dual }

enum paymentMode { Ticket_Payment, Wallet_Recharge, Card_Recharge }

enum paymentStatus {
  Credited,
  Debited,
}

class TransactionService {
  static add({
    required String id,
    required paymentMethod method,
    required paymentMode mode,
    required String amount,
    required paymentStatus status,
    required String time,
    required String date,
  }) async {
    await fire.collection("transactions").doc(id).set({
      "Id": id,
      "Time": time,
      "Date": date,
      "Method": paymentMethodList[method],
      "Mode": paymentModeList[mode],
      "Amount": amount,
      "Phone No": auth.currentUser!.phoneNumber,
      "Status": paymentStatusList[status],
      "TimeStamp": Timestamp.now()
    });
    await fire
        .collection("users")
        .doc(auth.currentUser?.phoneNumber.toString())
        .update({
      "Transaction": FieldValue.arrayUnion([id])
    });
  }
}
