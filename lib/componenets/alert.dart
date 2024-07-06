import 'package:flutter/material.dart';

class Commons{
  void AlertMe(String msg,context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.black,
          title: Center(
            child: Text(
              'Error : $msg',
              style: const TextStyle(color: Colors.red,fontSize: 13),
            ),
          ),
        );
      },
    );
  }
  void ShowLoading(context){
    showDialog(
      context: context,
      builder: (context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}