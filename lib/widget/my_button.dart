import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  final Widget child;
  final VoidCallback onpress;
  final EdgeInsetsGeometry? padding;
  final bool ispress;
  final Color? btnbackground;
  final firstColor;
  final secondColor;

  const MyButton(
      {super.key,
      required this.child,
      required this.onpress,
      this.padding,
      this.ispress = false,
       this.btnbackground,
      this.firstColor = Colors.white,
      this.secondColor = Colors.amber});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onpress,
      child: AnimatedContainer(
        duration: Duration(milliseconds: 100),
        padding: padding ?? const EdgeInsets.all(20),
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: btnbackground,
            boxShadow: ispress
                ? [
                    BoxShadow(
                        color: firstColor,
                        blurRadius: 5,
                        spreadRadius: 1,
                        offset: Offset(2, 2)),
                    BoxShadow(
                        color: firstColor,
                        blurRadius: 5,
                        spreadRadius: 1,
                        offset: Offset(-1, -1))
                  ]
                : [
                    BoxShadow(
                        color: firstColor,
                        blurRadius: 7,
                        spreadRadius: 1,
                        offset: Offset(6, 6)),
                    BoxShadow(
                        color: firstColor,
                        blurRadius: 7,
                        spreadRadius: 1,
                        offset: Offset(-6, -6))
                  ]),
        child: Center(
          child: child,
        ),
      ),
    );
  }
}
