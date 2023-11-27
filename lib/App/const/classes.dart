import 'package:flutter/material.dart';

class CustomPageRoute extends PageRouteBuilder{
  final Widget child;
  final bool flag;

  CustomPageRoute({
    required this.child,
    required this.flag,
  }):super(
    transitionDuration: const Duration(milliseconds: 300),
    pageBuilder: (context,animation,secondaryAnimation) => child,
  );

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) =>
  SlideTransition(
    position: Tween<Offset>(
      begin: flag ? const Offset(1,0):const Offset(0,1),
      end: Offset.zero,
    ).animate(animation),
    child: child,
  );
}

