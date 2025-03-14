import 'package:flutter/material.dart';

import 'package:flutter/material.dart';

class MyTextField extends StatelessWidget {
  final controller;
  final prefixIcon;
  final String hintText;
  final bool obscureText;
  final String? errorText; // Added errorText property

  const MyTextField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.obscureText,
    required this.prefixIcon,
    this.errorText, // Initialize the errorText property with null
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(
          prefixIcon: prefixIcon,
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.lightBlue),
          ),
          errorText: errorText, // Display error text if provided
          fillColor: Colors.grey.shade200,
          filled: true,
          labelText: hintText,
          hintStyle: TextStyle(color: Colors.grey[500]),
        ),
      ),
    );
  }
}
