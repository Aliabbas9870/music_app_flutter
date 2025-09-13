import 'package:flutter/material.dart';

class CustomeTextFormField extends StatelessWidget {
  String placeholder;
  String hintText;
  TextInputType type;
  bool obscure;
  TextEditingController controller;
  CustomeTextFormField(
      {super.key,
      
      required this.hintText,
      required this.obscure,
      required this.controller,
      required this.type,
      required this.placeholder});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: (value) {
        if(value==null){
          return hintText;
        }
      },
      controller: controller,
      obscureText: obscure,keyboardType: type,
      
      decoration: InputDecoration(
        hintText: hintText,
        
        
          border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)))),
    );
  }
}
