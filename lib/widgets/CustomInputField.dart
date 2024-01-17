import 'package:flutter/material.dart';

class CustomInputField extends StatelessWidget {
  const CustomInputField(
      {super.key,
      required this.controller,
      required this.labelText,
      required this.hintText,
      this.autoCorrect = true,
      this.autofocus = false,
      this.keyboardType = TextInputType.text,
      this.validator,
      this.obscureText = false,
      this.obscureCharacter = '*',
      this.suffixIcon});

  final TextEditingController controller;
  final String labelText;
  final String hintText;
  final bool autoCorrect;
  final bool autofocus;
  final TextInputType keyboardType;
  final FormFieldValidator<String>? validator;
  final bool obscureText;
  final String obscureCharacter;
  final Icon? suffixIcon;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.deepOrange),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.orangeAccent),
          ),
          errorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.redAccent),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.red),
          ),
          suffixIconColor: Colors.orangeAccent,
          suffixIcon: suffixIcon,
          alignLabelWithHint: true,
          hintText: hintText,
          labelText: labelText,
          contentPadding: EdgeInsets.all(18)),
      controller: controller,
      autocorrect: autoCorrect,
      autofocus: autofocus,
      keyboardType: keyboardType,
      maxLines: 1,
      validator: validator,
      obscureText: obscureText,
      obscuringCharacter: obscureCharacter,
    );
  }
}
