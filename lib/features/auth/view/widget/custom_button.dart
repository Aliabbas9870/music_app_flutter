import 'package:flutter/material.dart';
import 'package:musicplay/core/theme/app_color.dart';

class CustomButton extends StatelessWidget {
  String text;
  CustomButton({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Container(
        width: MediaQuery.of(context).size.width / 0.07,
        height: 60,
        decoration: BoxDecoration(
            color: AppColor.bg, borderRadius: BorderRadius.circular(14)),
        child: Center(
            child: Text(
          text,
          style: TextStyle(
              color: AppColor.primary, fontSize: 15, fontWeight: FontWeight.bold),
        )),
      ),
    );
  }
}
