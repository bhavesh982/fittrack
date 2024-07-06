import 'package:flutter/material.dart';
class DetailsField extends StatelessWidget {
  final controller;
  final String hintText;


  const DetailsField({super.key, this.controller, required this.hintText});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 100.0),
      child: TextField(
        controller: controller,
        decoration:  InputDecoration(
          enabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.white)
          ),
          focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey)
          ),
          fillColor: Colors.white70,
          filled: true,
          hintText: hintText,
        ),
      ),
    );
  }
}
