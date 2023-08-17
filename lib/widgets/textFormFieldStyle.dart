import 'package:flutter/material.dart';
import 'package:shop/colors.dart';

class TextFormFieldStyle extends StatelessWidget {
  final String hintText;
  final TextInputType textInputType;
  final String? Function(String?) validator;
  void Function(String?)? onsaved;
  final IconData icon;
 final bool enabled;
 final bool obscureText;
 TextEditingController? controller;








 TextFormFieldStyle({super.key, required this.hintText, required this.textInputType, required this.validator,  this.onsaved, required this.icon,  this.enabled=true,  this.obscureText=false, this.controller});@override

  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText:obscureText,
      enabled: enabled,
      onSaved: onsaved,
      keyboardType: textInputType,
      validator: validator,
      decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),

          ),
          hintText: hintText,
          hintStyle: TextStyle(
            color: blueColor,
            fontSize: 17
          ),
          suffixIcon: Icon(icon, color: lightBlueColor,)),

    );
  }
}
