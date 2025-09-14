import 'package:flutter/material.dart';
import 'package:musicplay/core/theme/app_color.dart';

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
      this.firstColor =AppColor.light,
      this.secondColor = AppColor.background});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onpress,
      child: AnimatedContainer(
        duration: Duration(milliseconds: 100),
        padding: padding ?? const EdgeInsets.all(14),
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: btnbackground,
            boxShadow: ispress
                ? [
                    BoxShadow(
                        color: firstColor,
                       
                        spreadRadius: 1,
                        offset: Offset(2, 2)),
                    BoxShadow(
                        color: firstColor,
                     
                        spreadRadius: 1,
                        offset: Offset(-1, -1))
                  ]
                : [
                    BoxShadow(
                        color: firstColor,
                        blurRadius: 2,
                        spreadRadius: 1,
                        offset: Offset(2, 2)),
                    BoxShadow(
                        color: firstColor,
                        blurRadius: 5,
                        spreadRadius: 1,
                        offset: Offset(-1, -1)) 
                  ]),
        child: Center(
          child: child,
        ),
      ),
    );
  }
}
