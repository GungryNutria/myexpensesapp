import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String hintText;
  final bool obscureText;
  final Function(String) onChanged;
  final FormFieldValidator<String>? validator;

  const CustomTextField({
    Key? key,
    required this.hintText,
    this.obscureText = false,
    required this.onChanged,
    this.validator,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: TextFormField(
        obscureText: obscureText,
        textAlign: TextAlign.justify,
        decoration: InputDecoration(
          filled: false,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Colors.black),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Colors.blue),
          ),
          hintText: hintText,
        ),
        onChanged: onChanged,
        validator: validator,
      ),
    );
  }
}
