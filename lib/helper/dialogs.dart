import 'package:flutter/material.dart';

class dialogs {

  static void showsnackbar(BuildContext context, msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg,style: const TextStyle(fontSize: 16) ,textAlign: TextAlign.center,),
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.green,
      
    ));
  }
    static void showprogressbar(BuildContext context) {
    showDialog(context: context, builder: (_) => Center(
      child: CircularProgressIndicator(color: Colors.green[300],)));
  }
}
